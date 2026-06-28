-- ==============================================================================
-- TESTING: CARGA MANUAL DE CREDITO Y LIMPIEZA DE DATOS DE PRUEBA
-- Archivo: 26_testing_credito_manual.sql
-- Uso: Solo para entornos de desarrollo/staging. NUNCA en produccion.
-- ==============================================================================

-- REEMPLAZA este valor con tu IdContratante real (auth.uid())
-- Lo puedes obtener con: SELECT id FROM auth.users WHERE email = 'tu@email.com';
\set ID_CONTRATANTE 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'

-- ==============================================================================
-- A) INICIALIZAR FILA DE CREDITO (si no existe aun)
-- ==============================================================================
-- Equivalente a lo que hace ensure_credito_contratante() al hacer onboarding.

INSERT INTO public."CreditoXContratante" ("IdContratante", "CreditoDisponibleEnUnidadMinima", "CodigoMoneda")
VALUES (:'ID_CONTRATANTE', 0, 'PEN')
ON CONFLICT ("IdContratante") DO NOTHING;


-- ==============================================================================
-- B) CARGAR CREDITO PARA PRUEBAS
-- ==============================================================================
-- Cambia el monto segun lo que necesites probar.
-- Los valores estan en unidades minimas (centimos).
-- Ejemplos:
--   5000  = S/ 50.00
--   10000 = S/ 100.00
--   50000 = S/ 500.00

DO $$
DECLARE
  v_id UUID := :'ID_CONTRATANTE';
  v_monto BIGINT := 10000; -- S/ 100.00 para pruebas
BEGIN
  -- Sumar credito
  UPDATE public."CreditoXContratante"
     SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + v_monto,
         "UpdatedAt" = NOW()
   WHERE "IdContratante" = v_id;

  -- Registrar el movimiento en el ledger (para que la auditoria quede limpia)
  INSERT INTO public."TransaccionesXCredito" (
    "IdContratante",
    "TipoMovimiento",
    "OrigenMovimiento",
    "MontoEnUnidadMinima",
    "CodigoMoneda",
    "Metadata"
  ) VALUES (
    v_id,
    'ABONO',
    'AJUSTE_PRUEBAS',
    v_monto,
    'PEN',
    '{"nota": "carga manual para testing local"}'::jsonb
  );

  RAISE NOTICE 'Credito cargado: % centimos (S/ %.2f)', v_monto, (v_monto::NUMERIC / 100);
END;
$$;


-- ==============================================================================
-- C) VERIFICAR ESTADO ACTUAL DEL CONTRATANTE
-- ==============================================================================

SELECT
  c."CreditoDisponibleEnUnidadMinima" AS credito_centimos,
  ROUND(c."CreditoDisponibleEnUnidadMinima"::NUMERIC / 100, 2) AS credito_soles,
  c."CodigoMoneda",
  c."UpdatedAt",
  lxc."IdLicencia",
  l."Nombre" AS licencia_activa,
  lxc."FechaInicio",
  lxc."FechaExpiracion",
  lxc."Activo"
FROM public."CreditoXContratante" c
LEFT JOIN public."LicenciasXContratante" lxc
  ON lxc."IdContratante" = c."IdContratante"
  AND lxc."Activo" = TRUE
LEFT JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
WHERE c."IdContratante" = :'ID_CONTRATANTE';


-- ==============================================================================
-- D) VER COLA DE LICENCIAS PROGRAMADAS
-- ==============================================================================

SELECT
  lc."IdLicenciaCola",
  l."Nombre" AS licencia,
  lc."Estado",
  lc."FechaProgramadaInicio",
  lc."Origen",
  lc."CostoListaEnUnidadMinima",
  lc."CreditoAplicadoEnUnidadMinima",
  lc."CostoFinalCobradoEnUnidadMinima"
FROM public."LicenciasCola" lc
JOIN public."Licencias" l ON l."IdLicencia" = lc."IdLicencia"
WHERE lc."IdContratante" = :'ID_CONTRATANTE'
ORDER BY lc."Prioridad";


-- ==============================================================================
-- E) LIMPIEZA COMPLETA DE DATOS DE PRUEBA
-- ==============================================================================
-- Ejecutar despues de cada sesion de pruebas para dejar el estado limpio.
-- NO borra la fila de CreditoXContratante, solo la resetea a 0.
-- NO borra la licencia TRIAL original (la de IdLicencia mas baja vigente).

DO $$
DECLARE
  v_id UUID := :'ID_CONTRATANTE';
  v_id_trial SMALLINT;
BEGIN
  -- Obtener la primera licencia (TRIAL) para no borrarla
  SELECT "IdLicencia" INTO v_id_trial
    FROM public."LicenciasXContratante"
   WHERE "IdContratante" = v_id
   ORDER BY "IdLicenciaContratante" ASC
   LIMIT 1;

  -- Borrar cola de licencias
  DELETE FROM public."LicenciasCola"
   WHERE "IdContratante" = v_id;

  -- Borrar transacciones de licencias
  DELETE FROM public."TransaccionesXLicencia"
   WHERE "IdContratante" = v_id;

  -- Borrar transacciones de credito
  DELETE FROM public."TransaccionesXCredito"
   WHERE "IdContratante" = v_id;

  -- Resetear credito a 0
  UPDATE public."CreditoXContratante"
     SET "CreditoDisponibleEnUnidadMinima" = 0,
         "UpdatedAt" = NOW()
   WHERE "IdContratante" = v_id;

  -- Desactivar licencias de prueba (conserva solo el TRIAL)
  UPDATE public."LicenciasXContratante"
     SET "Activo" = FALSE
   WHERE "IdContratante" = v_id
     AND "IdLicenciaContratante" <> COALESCE(v_id_trial, -1);

  -- Reactivar el TRIAL si existe
  IF v_id_trial IS NOT NULL THEN
    UPDATE public."LicenciasXContratante"
       SET "Activo" = TRUE,
           "FechaExpiracion" = NOW() + INTERVAL '7 days'
     WHERE "IdContratante" = v_id
       AND "IdLicenciaContratante" = v_id_trial;
  END IF;

  RAISE NOTICE 'Limpieza completada para contratante %', v_id;
END;
$$;
