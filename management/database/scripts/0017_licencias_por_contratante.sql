-- ==============================================================================
-- MIGRACIÓN: LICENCIAS POR CONTRATANTE
-- Archivo: 24_licencias_por_contratante.sql
-- Descripción: Cambia el modelo de licencias de "por dispositivo" a "por cuenta".
--   - LicenciasXContratante: elimina DispositivoAsignado, añade FechaExpiracion y Activo.
--   - DispositivosXContratante: elimina IdLicencia y FechaVencimiento.
--   - Reescribe triggers de límites (usuarios y dispositivos) a nivel de cuenta.
--   - Nueva función de asignación de licencia (trial, comercial, canje).
--   - Funciones auxiliares: get_licencia_activa, get_stats_contratante.
--
-- Nota: El flujo de upgrade/crédito/cola se maneja en SQL 25 (sistema de crédito).
-- Este archivo solo prepara la estructura y funciones base.
-- ==============================================================================

BEGIN;

-- ==============================================================================
-- 1. MIGRACIÓN DE LicenciasXContratante (IDEMPOTENTE)
-- ==============================================================================

-- 1.1. Eliminar columna de asignación por dispositivo (modelo anterior)
ALTER TABLE public."LicenciasXContratante"
  DROP COLUMN IF EXISTS "DispositivoAsignado";

-- 1.2. Renombrar FechaAsignacion → FechaInicio (semántica correcta)
--      Solo renombra si FechaAsignacion existe (osea, no ha sido renombrada aún)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'LicenciasXContratante'
      AND column_name = 'FechaAsignacion'
  ) THEN
    ALTER TABLE public."LicenciasXContratante"
      RENAME COLUMN "FechaAsignacion" TO "FechaInicio";
  END IF;
END $$;

-- 1.3. Añadir FechaExpiracion: calculada al asignar como FechaInicio + DuracionDias
ALTER TABLE public."LicenciasXContratante"
  ADD COLUMN IF NOT EXISTS "FechaExpiracion" TIMESTAMPTZ;

-- 1.4. Añadir Activo: TRUE = licencia que rige hoy. Solo una puede ser TRUE por contratante.
--      Las anteriores quedan en FALSE como historial de compras/canjes.
ALTER TABLE public."LicenciasXContratante"
  ADD COLUMN IF NOT EXISTS "Activo" BOOLEAN NOT NULL DEFAULT TRUE;

-- 1.5. Índice único parcial: garantiza que solo exista 1 licencia activa por contratante
--      a nivel de base de datos, sin afectar el historial de filas inactivas.
DROP INDEX IF EXISTS "idx_unico_licencia_activa_por_contratante";
CREATE UNIQUE INDEX "idx_unico_licencia_activa_por_contratante"
  ON public."LicenciasXContratante" ("IdContratante")
  WHERE "Activo" = TRUE;

-- ==============================================================================
-- 2. MIGRACIÓN DE DispositivosXContratante
-- ==============================================================================

-- 2.1. Eliminar IdLicencia: la licencia ya no está en el dispositivo sino en la cuenta
ALTER TABLE public."DispositivosXContratante"
  DROP COLUMN IF EXISTS "IdLicencia";

-- 2.2. Eliminar FechaVencimiento: la expiración es de la licencia del contratante
ALTER TABLE public."DispositivosXContratante"
  DROP COLUMN IF EXISTS "FechaVencimiento";

-- Nota: EquipoMarca, EquipoModelo, HardwareId, IsConnected se mantienen.
-- La app Android los escribe; la web los lee.

-- ==============================================================================
-- 3. FUNCIÓN AUXILIAR: Obtiene la licencia activa de un contratante
--    Retorna NULL si no tiene ninguna activa y vigente.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.get_licencia_activa(p_id_contratante UUID)
RETURNS TABLE (
  "IdLicenciaContratante" INT,
  "IdLicencia"            SMALLINT,
  "Nombre"                VARCHAR(50),
  "LimiteDispositivos"    INT,
  "LimiteUsuarios"        INT,
  "PrecioCentimos"        INT,
  "DuracionDias"          INT,
  "FechaInicio"           TIMESTAMPTZ,
  "FechaExpiracion"       TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    lxc."IdLicenciaContratante",
    lxc."IdLicencia",
    l."Nombre",
    l."LimiteDispositivos",
    l."LimiteUsuarios",
    l."PrecioCentimos",
    l."DuracionDias",
    lxc."FechaInicio",
    lxc."FechaExpiracion"
  FROM public."LicenciasXContratante" lxc
  JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
  WHERE lxc."IdContratante" = p_id_contratante
    AND lxc."Activo" = TRUE
    AND lxc."FechaExpiracion" > NOW()
  LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- ==============================================================================
-- 4. FUNCIÓN: asignar_licencia_contratante
--    Usada por: onboarding (trial), canje de código (comercial).
--
--    Lógica:
--    - Si no hay licencia activa → asigna directamente (FechaInicio = NOW()).
--    - Si ya hay licencia activa del mismo tipo o inferior → acumula días
--      sobre la FechaExpiracion existente (no interrumpe el servicio).
--    - Si la nueva licencia es un UPGRADE (mayor PrecioCentimos) →
--      esta función NO aplica el upgrade; usa calcular_upgrade_licencia() primero
--      para mostrar el prorrateo al usuario y luego aplicar_upgrade_licencia().
--
--    Parámetros:
--      p_id_contratante  UUID     — El contratante que recibe la licencia
--      p_id_licencia     SMALLINT — ID del plan a asignar (de la tabla Licencias)
--      p_numero_orden    VARCHAR  — Número de orden (pasarela o SYSTEM_TRIAL)
--
--    Retorna: FechaExpiracion resultante
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.asignar_licencia_contratante(
  p_id_contratante UUID,
  p_id_licencia    SMALLINT,
  p_numero_orden   VARCHAR(50)
) RETURNS TIMESTAMPTZ AS $$
DECLARE
  v_duracion_dias    INT;
  v_licencia_activa  RECORD;
  v_fecha_inicio     TIMESTAMPTZ;
  v_fecha_expiracion TIMESTAMPTZ;
BEGIN
  -- 1. Obtener duración real del plan desde el catálogo (nunca valor hardcodeado)
  SELECT "DuracionDias"
    INTO v_duracion_dias
    FROM public."Licencias"
   WHERE "IdLicencia" = p_id_licencia;

  IF v_duracion_dias IS NULL THEN
    RAISE EXCEPTION 'Licencia con IdLicencia=% no encontrada en catálogo.', p_id_licencia;
  END IF;

  -- 2. Verificar si ya existe una licencia activa y vigente
  SELECT lxc."IdLicenciaContratante", lxc."FechaExpiracion", l."PrecioCentimos"
    INTO v_licencia_activa
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = p_id_contratante
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  IF FOUND THEN
    -- 3a. Ya hay licencia activa vigente → acumulamos días sobre la expiración actual
    v_fecha_inicio     := NOW();
    v_fecha_expiracion := v_licencia_activa."FechaExpiracion" + (v_duracion_dias || ' days')::INTERVAL;

    -- Desactivar la licencia anterior (pasa a historial)
    UPDATE public."LicenciasXContratante"
       SET "Activo" = FALSE
     WHERE "IdLicenciaContratante" = v_licencia_activa."IdLicenciaContratante";
  ELSE
    -- 3b. Sin licencia activa → asignar desde hoy
    v_fecha_inicio     := NOW();
    v_fecha_expiracion := NOW() + (v_duracion_dias || ' days')::INTERVAL;
  END IF;

  -- 4. Insertar la nueva licencia activa
  INSERT INTO public."LicenciasXContratante"
    ("IdContratante", "IdLicencia", "NumeroOrden", "FechaInicio", "FechaExpiracion", "Activo")
  VALUES
    (p_id_contratante, p_id_licencia, p_numero_orden, v_fecha_inicio, v_fecha_expiracion, TRUE);

  RETURN v_fecha_expiracion;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 5. FUNCIÓN AUXILIAR: get_stats_contratante
--    Retorna el conteo de dispositivos activos y usuarios únicos autorizados
--    para un contratante. Usada por la página de licencias para mostrar el
--    uso actual del plan sin múltiples queries desde la UI.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.get_stats_contratante(p_id_contratante UUID)
RETURNS TABLE (
  total_dispositivos BIGINT,
  total_usuarios     BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    (
      SELECT COUNT(*)
      FROM public."DispositivosXContratante"
      WHERE "IdContratante" = p_id_contratante
    ) AS total_dispositivos,
    (
      SELECT COUNT(DISTINCT a."IdUsuario")
      FROM public."AutorizacionesXUsuario" a
      JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
      WHERE d."IdContratante" = p_id_contratante
    ) AS total_usuarios;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- ==============================================================================
-- 6. TRIGGER: check_device_limit
--    BEFORE INSERT OR UPDATE en DispositivosXContratante.
--    Bloquea la creación o activación si el contratante ya alcanzó el LimiteDispositivos
--    de dispositivos activos en su licencia activa.
--    Modificado: 2026-06-28 | Autor: AGENT_ROLE | Justificación: Validar límites en base a dispositivos activos.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.check_device_limit()
RETURNS TRIGGER AS $$
DECLARE
  v_limite_disp  INT;
  v_total_disp   INT;
  v_nombre_plan  VARCHAR(50);
BEGIN
  -- 1. Obtener límite de la licencia activa vigente del contratante
  SELECT l."LimiteDispositivos", l."Nombre"
    INTO v_limite_disp, v_nombre_plan
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = NEW."IdContratante"
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  IF v_limite_disp IS NULL THEN
    RAISE EXCEPTION 'Sin licencia activa: el contratante no tiene un plan vigente para crear o activar dispositivos.';
  END IF;

  -- 2. Validar solo si se está insertando un dispositivo activo o si se está activando uno inactivo
  IF (TG_OP = 'INSERT' AND NEW."Activo" = TRUE) OR 
     (TG_OP = 'UPDATE' AND OLD."Activo" = FALSE AND NEW."Activo" = TRUE) THEN
     
     SELECT COUNT(*) INTO v_total_disp
       FROM public."DispositivosXContratante"
      WHERE "IdContratante" = NEW."IdContratante"
        AND "Activo" = TRUE;

     -- 3. Bloquear si se supera el límite de activos
     IF v_total_disp >= v_limite_disp THEN
       RAISE EXCEPTION 'LímiteDispositivos: el plan "%" permite hasta % dispositivos activos. Ya tienes % activos.',
         v_nombre_plan, v_limite_disp, v_total_disp;
     END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS enforce_device_limit ON public."DispositivosXContratante";
CREATE TRIGGER enforce_device_limit
  BEFORE INSERT OR UPDATE ON public."DispositivosXContratante"
  FOR EACH ROW
  EXECUTE FUNCTION public.check_device_limit();

-- ==============================================================================
-- 7. TRIGGER: check_user_limit
--    BEFORE INSERT OR UPDATE en AutorizacionesXUsuario.
--    Valida que el total de usuarios ÚNICOS autorizados en estado Aprobado (2)
--    en cualquier dispositivo del contratante no supere el LimiteUsuarios de su plan.
--    Modificado: 2026-06-28 | Autor: AGENT_ROLE | Justificación: Validar límites en base a usuarios aprobados.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.check_user_limit()
RETURNS TRIGGER AS $$
DECLARE
  v_id_contratante  UUID;
  v_limite_users    INT;
  v_total_users     INT;
  v_nombre_plan     VARCHAR(50);
BEGIN
  -- 1. Obtener el contratante dueño del dispositivo al que se quiere vincular
  SELECT "IdContratante" INTO v_id_contratante
    FROM public."DispositivosXContratante"
   WHERE "IdDispositivo" = NEW."IdDispositivo";

  IF v_id_contratante IS NULL THEN
    RAISE EXCEPTION 'Dispositivo no encontrado o sin contratante asignado.';
  END IF;

  -- 2. Obtener LimiteUsuarios del plan activo del contratante
  SELECT l."LimiteUsuarios", l."Nombre"
    INTO v_limite_users, v_nombre_plan
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = v_id_contratante
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  IF v_limite_users IS NULL THEN
    RAISE EXCEPTION 'Sin licencia activa: el contratante no tiene un plan vigente.';
  END IF;

  -- 3. Validar solo si se está insertando en estado Aprobado (2) o si se está cambiando de otro estado a Aprobado (2)
  IF (TG_OP = 'INSERT' AND NEW."IdEstadoAuth" = 2) OR 
     (TG_OP = 'UPDATE' AND OLD."IdEstadoAuth" != 2 AND NEW."IdEstadoAuth" = 2) THEN

     -- Contar usuarios ÚNICOS ya autorizados (Aprobados) en cualquier caja de este contratante
     SELECT COUNT(DISTINCT a."IdUsuario") INTO v_total_users
       FROM public."AutorizacionesXUsuario" a
       JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
      WHERE d."IdContratante" = v_id_contratante
        AND a."IdEstadoAuth" = 2;

     -- 4. Verificar que el usuario no sea ya uno de los autorizados previamente en estado Aprobado
     -- (si ya tiene acceso aprobado a otra caja del contratante, no consume cupo nuevo)
     IF EXISTS (
       SELECT 1
         FROM public."AutorizacionesXUsuario" a
         JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
        WHERE d."IdContratante" = v_id_contratante
          AND a."IdUsuario" = NEW."IdUsuario"
          AND a."IdEstadoAuth" = 2
          AND a."IdAutorizacion" != NEW."IdAutorizacion" -- evitar contarse a sí mismo en un UPDATE
     ) THEN
       RETURN NEW;
     END IF;

     -- 5. Si es un usuario nuevo en estado aprobado, verificar que haya cupo disponible
     IF v_total_users >= v_limite_users THEN
       RAISE EXCEPTION 'LímiteUsuarios: el plan "%" permite hasta % usuarios únicos aprobados. Ya tienes % aprobados.',
         v_nombre_plan, v_limite_users, v_total_users;
     END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS enforce_user_limit ON public."AutorizacionesXUsuario";
CREATE TRIGGER enforce_user_limit
  BEFORE INSERT OR UPDATE ON public."AutorizacionesXUsuario"
  FOR EACH ROW
  EXECUTE FUNCTION public.check_user_limit();

-- ==============================================================================
-- 8. RLS ACTUALIZADA: LicenciasXContratante
--    La policy existente (auth.uid() = IdContratante) ya cubre las nuevas
--    columnas. Solo nos aseguramos de que esté activa y sea para ALL.
-- ==============================================================================

ALTER TABLE public."LicenciasXContratante" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Contratantes ven sus propias Licencias" ON public."LicenciasXContratante";
CREATE POLICY "Contratantes ven sus propias Licencias"
  ON public."LicenciasXContratante"
  FOR ALL
  USING (auth.uid() = "IdContratante");

-- ==============================================================================
-- 9. HABILITAR REALTIME PARA LicenciasXContratante
--     Permite que la UI reaccione en tiempo real si un admin canjea desde
--     otra pestaña o si el sistema asigna el trial automáticamente.
-- ==============================================================================

ALTER TABLE public."LicenciasXContratante" REPLICA IDENTITY FULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
     WHERE pubname = 'supabase_realtime'
       AND tablename = 'LicenciasXContratante'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public."LicenciasXContratante";
  END IF;
END $$;

COMMIT;


-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 17_rls_onboarding_vinculacion.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: y)
-- ==========================================================================

-- ==========================================================
-- 17_RLS_ONBOARDING_Y_VINCULACION_REACTIVA.sql
-- Descripción: Ajustes finales para lectura inicial anon y
-- gestión de billeteras post-vinculación.
-- ==========================================================

-- A. PERMISOS DE LECTURA INICIAL (ONBOARDING)
-- Permite que cualquier app instalada (anon) vea qué billeteras soportamos
DROP POLICY IF EXISTS "Lectura_Anon_Billeteras" ON "public"."Billeteras";
CREATE POLICY "Lectura_Anon_Billeteras" ON "public"."Billeteras"
FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "Lectura_Anon_Filtros" ON "public"."FiltrosXBilletera";
CREATE POLICY "Lectura_Anon_Filtros" ON "public"."FiltrosXBilletera"
FOR SELECT TO anon USING (true);

-- B. GESTIÓN DE BILLETERAS DEL DISPOSITIVO
-- Permite que la app registre qué billeteras usará tras vincularse.
-- La seguridad reside en que el dispositivo debe conocer su propio IdDispositivo (UUID).
ALTER TABLE "public"."BilleterasXDispositivo" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Dispositivo_Gestiona_Sus_Billeteras" ON "public"."BilleterasXDispositivo";
CREATE POLICY "Dispositivo_Gestiona_Sus_Billeteras"
ON "public"."BilleterasXDispositivo"
FOR ALL
TO anon
USING (true)
WITH CHECK (true);

-- C. HABILITAR REALTIME PARA ACTUALIZACIONES DINÁMICAS
-- Ejecutar si no se hizo previamente para que el App Admin reaccione a cambios en filtros
ALTER PUBLICATION supabase_realtime ADD TABLE "public"."Billeteras";
ALTER PUBLICATION supabase_realtime ADD TABLE "public"."FiltrosXBilletera";
ALTER PUBLICATION supabase_realtime ADD TABLE "public"."BilleterasXDispositivo";



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 33_rpc_resolver_disputas.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: v_id_contratante)
-- ==========================================================================

-- ==========================================================
-- 33_RPC_RESOLVER_DISPUTAS.SQL
-- Objetivo: Proporcionar una función atómica para que el Admin
-- resuelva conflictos de autoría entre vendedores.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.resolver_disputa(
    p_id_sync UUID,
    p_id_usuario_ganador UUID,
    p_es_descarte BOOLEAN DEFAULT FALSE
)
RETURNS JSONB AS $$
DECLARE
    v_id_contratante UUID;
BEGIN
    -- 1. Validar existencia y obtener contratante para seguridad (opcional si se confía en RLS)
    SELECT "IdContratante" INTO v_id_contratante
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync;

    IF v_id_contratante IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    IF p_es_descarte THEN
        -- CASO A: Descartar el pago (Nadie gana)
        UPDATE public."NotificacionesXDispositivo"
        SET "EstadoProgreso" = 'PENDIENTE', -- O 'DESCARTADO' si existiera, volvemos a pendiente para que se reclame bien o se observe.
                                           -- En este flujo, mejor 'PENDIENTE' y limpiar contadores.
            "IdUsuarioGanador" = NULL,
            "ContadorReclamaciones" = 0
        WHERE "IdSync" = p_id_sync;

        DELETE FROM public."NotificacionesAUsuarios"
        WHERE "IdSync" = p_id_sync;

        RETURN jsonb_build_object('success', true, 'action', 'DISCARDED');
    ELSE
        -- CASO B: Asignar un ganador
        -- 1. Marcar al ganador como APROBADO
        UPDATE public."NotificacionesAUsuarios"
        SET "EstadoReclamacion" = 'APROBADO'
        WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario_ganador;

        -- 2. Marcar a todos los demás reclamantes como RECHAZADO
        UPDATE public."NotificacionesAUsuarios"
        SET "EstadoReclamacion" = 'RECHAZADO'
        WHERE "IdSync" = p_id_sync AND "IdUsuario" <> p_id_usuario_ganador;

        -- 3. Actualizar la maestra
        UPDATE public."NotificacionesXDispositivo"
        SET "EstadoProgreso" = 'COMPLETADO',
            "IdUsuarioGanador" = p_id_usuario_ganador
        WHERE "IdSync" = p_id_sync;

        RETURN jsonb_build_object('success', true, 'action', 'RESOLVED');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 8. TRIGGER: enforce_downgrade_limits
--    AFTER INSERT OR UPDATE en LicenciasXContratante.
--    Desactiva dispositivos excedentes (Activo = FALSE) y bloquea usuarios excedentes
--    (IdEstadoAuth = 3) al cambiar a un plan inferior (downgrade).
--    Creado: 2026-06-28 | Autor: AGENT_ROLE | Justificación: Automatización de límites ante downgrade.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.enforce_downgrade_limits()
RETURNS TRIGGER AS $$
DECLARE
  v_limite_disp  INT;
  v_limite_users INT;
BEGIN
  -- 1. Si la licencia pasa a estar activa, recuperar sus límites
  IF NEW."Activo" = TRUE THEN
    SELECT l."LimiteDispositivos", l."LimiteUsuarios"
      INTO v_limite_disp, v_limite_users
      FROM public."Licencias" l
     WHERE l."IdLicencia" = NEW."IdLicencia";

    -- 2. Desactivar automáticamente dispositivos excedentes (los más nuevos)
    UPDATE public."DispositivosXContratante"
       SET "Activo" = FALSE
     WHERE "IdDispositivo" IN (
         SELECT "IdDispositivo"
           FROM public."DispositivosXContratante"
          WHERE "IdContratante" = NEW."IdContratante"
            AND "Activo" = TRUE
          ORDER BY "FechaReg" DESC
         OFFSET v_limite_disp
     );

    -- 3. Bloquear automáticamente usuarios/vendedores excedentes (las autorizaciones más nuevas)
    UPDATE public."AutorizacionesXUsuario"
       SET "IdEstadoAuth" = 3 -- Bloqueado
     WHERE "IdAutorizacion" IN (
         SELECT a."IdAutorizacion"
           FROM public."AutorizacionesXUsuario" a
           JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
          WHERE d."IdContratante" = NEW."IdContratante"
            AND a."IdEstadoAuth" = 2
          ORDER BY a."FechRegist" DESC
         OFFSET v_limite_users
     );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS enforce_downgrade_limits_trigger ON public."LicenciasXContratante";
CREATE TRIGGER enforce_downgrade_limits_trigger
  AFTER INSERT OR UPDATE ON public."LicenciasXContratante"
  FOR EACH ROW
  EXECUTE FUNCTION public.enforce_downgrade_limits();

