-- Script: 0047_motor_colas_jit_y_continuidad.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-10-05
-- Justificación: Corrección de constraint en LicenciasCola ('APLICADA' en vez de 'COMPLETADA'), motor de colas con aislamiento de errores (BEGIN...EXCEPTION), activación reactiva Just-In-Time (JIT) y encadenamiento continuo de fechas.

BEGIN;

-- 1. Función Centralizada Just-In-Time (JIT) para activar cola
CREATE OR REPLACE FUNCTION public.activar_licencia_cola_si_aplica(
  p_id_contratante UUID
) RETURNS JSONB AS $$
DECLARE
  v_lic_cola RECORD;
  v_duracion INT;
  v_ult_exp TIMESTAMPTZ;
  v_fecha_inicio TIMESTAMPTZ;
  v_nueva_exp TIMESTAMPTZ;
  v_id_lic_contratante INT;
BEGIN
  -- Control de autorización: el usuario solo puede activar su propia cola salvo que sea superadmin/service_role
  IF auth.role() = 'authenticated' AND auth.uid() <> p_id_contratante THEN
    IF NOT EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdUsuario" = auth.uid()) THEN
      RAISE EXCEPTION 'No autorizado para activar la cola de otro contratante.';
    END IF;
  END IF;

  -- 1.1 Si el contratante ya tiene una licencia activa vigente, no hay nada que promover
  IF EXISTS (
    SELECT 1 
      FROM public."LicenciasXContratante"
     WHERE "IdContratante" = p_id_contratante
       AND "Activo" = TRUE
       AND "FechaExpiracion" > NOW()
  ) THEN
    RETURN jsonb_build_object('activada', FALSE, 'motivo', 'LICENCIA_ACTIVA_VIGENTE');
  END IF;

  -- 1.2 Marcar como inactivas licencias que hayan expirado
  UPDATE public."LicenciasXContratante"
     SET "Activo" = FALSE
   WHERE "IdContratante" = p_id_contratante
     AND "Activo" = TRUE
     AND "FechaExpiracion" <= NOW();

  -- 1.3 Bloqueo pesimista sobre la licencia en cola prioritaria
  SELECT * INTO v_lic_cola
    FROM public."LicenciasCola"
   WHERE "IdContratante" = p_id_contratante
     AND "Estado" = 'PROGRAMADA'
   ORDER BY "Prioridad" ASC
   LIMIT 1
   FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('activada', FALSE, 'motivo', 'SIN_LICENCIAS_EN_COLA');
  END IF;

  -- 1.4 Obtener duración del plan
  SELECT "DuracionDias" INTO v_duracion
    FROM public."Licencias"
   WHERE "IdLicencia" = v_lic_cola."IdLicencia";

  IF v_duracion IS NULL OR v_duracion <= 0 THEN
    v_duracion := 30;
  END IF;

  -- 1.5 Obtener la última fecha de expiración previa para continuidad (estrictamente de licencias ya vencidas)
  SELECT "FechaExpiracion" INTO v_ult_exp
    FROM public."LicenciasXContratante"
   WHERE "IdContratante" = p_id_contratante
     AND "FechaExpiracion" <= NOW()
   ORDER BY "FechaExpiracion" DESC
   LIMIT 1;

  -- Si expiró recientemente (y el periodo cubriría tiempo futuro), se encadena a la previa.
  -- Si venció hace mucho tiempo (o la suma quedaría en el pasado), arranca desde NOW().
  IF v_ult_exp IS NOT NULL AND (v_ult_exp + (v_duracion || ' days')::INTERVAL) > NOW() THEN
    v_fecha_inicio := v_ult_exp;
  ELSE
    v_fecha_inicio := NOW();
  END IF;

  v_nueva_exp := v_fecha_inicio + (v_duracion || ' days')::INTERVAL;

  -- 1.6 Insertar en LicenciasXContratante
  INSERT INTO public."LicenciasXContratante" (
    "IdContratante",
    "IdLicencia",
    "NumeroOrden",
    "FechaInicio",
    "FechaExpiracion",
    "Activo",
    "ExtraUsuarios",
    "ExtraDispositivos"
  ) VALUES (
    p_id_contratante,
    v_lic_cola."IdLicencia",
    'COLA-' || v_lic_cola."IdLicenciaCola",
    v_fecha_inicio,
    v_nueva_exp,
    TRUE,
    COALESCE(v_lic_cola."ExtraUsuarios", 0),
    COALESCE(v_lic_cola."ExtraDispositivos", 0)
  ) RETURNING "IdLicenciaContratante" INTO v_id_lic_contratante;

  -- 1.7 Marcar como APLICADA en la cola (cumpliendo LicenciasCola_Estado_check)
  UPDATE public."LicenciasCola"
     SET "Estado" = 'APLICADA',
         "UpdatedAt" = NOW()
   WHERE "IdLicenciaCola" = v_lic_cola."IdLicenciaCola";

  -- 1.8 Resecuenciar prioridades restantes
  PERFORM public.resecuenciar_prioridades(p_id_contratante);

  RETURN jsonb_build_object(
    'activada', TRUE,
    'id_licencia_contratante', v_id_lic_contratante,
    'id_licencia', v_lic_cola."IdLicencia",
    'id_licencia_cola', v_lic_cola."IdLicenciaCola",
    'fecha_inicio', v_fecha_inicio,
    'fecha_expiracion', v_nueva_exp
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.activar_licencia_cola_si_aplica(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.activar_licencia_cola_si_aplica(UUID) TO service_role;


-- 2. Motor de Colas General (Actualizado con aislamiento de errores y reutilización de lógica JIT)
CREATE OR REPLACE FUNCTION public.procesar_licencias_cola()
RETURNS VOID AS $$
DECLARE
  v_contratante RECORD;
BEGIN
  -- 2.1 Desactivar licencias expiradas globalmente
  UPDATE public."LicenciasXContratante"
     SET "Activo" = FALSE
   WHERE "Activo" = TRUE
     AND "FechaExpiracion" <= NOW();

  -- 2.2 Buscar contratantes con licencias PROGRAMADAS sin licencia activa vigente
  FOR v_contratante IN 
    SELECT DISTINCT lc."IdContratante"
      FROM public."LicenciasCola" lc
     WHERE lc."Estado" = 'PROGRAMADA'
       AND NOT EXISTS (
           SELECT 1 
             FROM public."LicenciasXContratante" lxc
            WHERE lxc."IdContratante" = lc."IdContratante"
              AND lxc."Activo" = TRUE
              AND lxc."FechaExpiracion" > NOW()
       )
  LOOP
    -- Bloque protegido por contratante: si uno falla, no aborta la transacción global
    BEGIN
      PERFORM public.activar_licencia_cola_si_aplica(v_contratante."IdContratante");
    EXCEPTION WHEN OTHERS THEN
      RAISE WARNING 'Error procesando cola de contratante %: %', v_contratante."IdContratante", SQLERRM;
    END;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.procesar_licencias_cola() TO authenticated;
GRANT EXECUTE ON FUNCTION public.procesar_licencias_cola() TO service_role;


-- 3. Programación en pg_cron (1 vez al día a medianoche hora local / 05:01 UTC)
CREATE EXTENSION IF NOT EXISTS pg_cron;

DO $$
BEGIN
  PERFORM cron.unschedule('procesar-licencias-cola-diario');
EXCEPTION WHEN OTHERS THEN
  -- Si no existía, continuar
END $$;

SELECT cron.schedule('procesar-licencias-cola-diario', '1 5 * * *', 'SELECT public.procesar_licencias_cola()');

COMMIT;
