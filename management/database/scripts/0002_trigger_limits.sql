-- ==========================================================
-- TRIGGER: VALIDACIÓN DE LÍMITE DE USUARIOS
-- Objetivo: Evitar que un negocio registre más vendedores (usuarios)
-- a una caja de lo que su licencia pre-pagada le permite.
-- ==========================================================

CREATE OR REPLACE FUNCTION public.check_user_limit()
RETURNS TRIGGER AS $$
DECLARE
    limit_users INT;
    active_users INT;
BEGIN
    -- 1. Obtenemos el límite definido en la Licencia asignada a este Dispositivo (Caja)
    SELECT l."LimiteUsuarios" INTO limit_users
    FROM public."DispositivosXContratante" d
    JOIN public."Licencias" l ON d."IdLicencia" = l."IdLicencia"
    WHERE d."IdDispositivo" = NEW."IdDispositivo";

    -- 2. Contamos cuántos usuarios ya están conectados/autorizados en esa Caja
    SELECT COUNT(*) INTO active_users
    FROM public."AutorizacionesXUsuario"
    WHERE "IdDispositivo" = NEW."IdDispositivo" 
      AND "IsConnected" = TRUE;

    -- 3. Si la suma actual más el que intenta ingresar supera el límite, bloqueamos la BD.
    IF active_users >= limit_users THEN
        RAISE EXCEPTION 'SuperadoLímite: La licencia de este dispositivo solo permite % usuarios.', limit_users;
    END IF;

    -- Si todo está bien, permitimos que el usuario se vincule a la caja.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Anclamos la función a la tabla de Autorizaciones antes de que ocurra una Inserción.
DROP TRIGGER IF EXISTS enforce_user_limit ON public."AutorizacionesXUsuario";

CREATE TRIGGER enforce_user_limit
BEFORE INSERT ON public."AutorizacionesXUsuario"
FOR EACH ROW
EXECUTE FUNCTION public.check_user_limit();


-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 21_rls_vinculacion_viewer.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: AutorizacionesXUsuario)
-- ==========================================================================

-- ==========================================================
-- 21_RLS_VINCULACION_VIEWER.SQL
-- Descripción: Permisos específicos para el flujo de vinculación
-- del Vendedor (Viewer).
-- ==========================================================

-- 1. TABLA: AutorizacionesXUsuario (Gestión de Solicitudes)
ALTER TABLE public."AutorizacionesXUsuario" ENABLE ROW LEVEL SECURITY;

-- Los vendedores solo ven y gestionan sus propias solicitudes
DROP POLICY IF EXISTS "Usuarios ven sus propias autorizaciones" ON public."AutorizacionesXUsuario";
CREATE POLICY "Usuarios ven sus propias autorizaciones"
ON public."AutorizacionesXUsuario" FOR SELECT USING (auth.uid() = "IdUsuario");

DROP POLICY IF EXISTS "Usuarios pueden solicitar vinculación" ON public."AutorizacionesXUsuario";
CREATE POLICY "Usuarios pueden solicitar vinculación"
ON public."AutorizacionesXUsuario" FOR INSERT WITH CHECK (auth.uid() = "IdUsuario");

DROP POLICY IF EXISTS "Usuarios pueden cancelar sus solicitudes" ON public."AutorizacionesXUsuario";
CREATE POLICY "Usuarios pueden cancelar sus solicitudes"
ON public."AutorizacionesXUsuario" FOR DELETE USING (auth.uid() = "IdUsuario");


-- 2. TABLA: Contratantes (Buscador de Negocios)
-- Ya existen políticas de dueño, pero añadimos una para que el Vendedor encuentre al Admin por nombre.
DROP POLICY IF EXISTS "Busqueda_Negocios_Viewer" ON public."Contratantes";
CREATE POLICY "Busqueda_Negocios_Viewer"
ON public."Contratantes" FOR SELECT USING (true);


-- 3. TABLA: DispositivosXContratante (Listar cajas para vincular)
-- El script 10 permitía ver huérfanos. Aquí permitimos que el Vendedor vea cajas YA ASIGNADAS
-- a un contratante para poder solicitar unirse a ellas.
DROP POLICY IF EXISTS "Vendedores_Ven_Cajas_Asignadas" ON public."DispositivosXContratante";
CREATE POLICY "Vendedores_Ven_Cajas_Asignadas"
ON public."DispositivosXContratante" FOR SELECT
USING ("IdContratante" IS NOT NULL AND "Activo" = true);



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 23_fix_licencia_trigger_security.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: check_user_limit)
-- ==========================================================================

-- ==========================================================
-- 23_FIX_LICENCIA_TRIGGER_SECURITY.SQL
-- Descripción: Cambia las funciones de validación de límites
-- a SECURITY DEFINER. Esto permite que los vendedores (Viewer)
-- puedan validar si el negocio tiene licencia activa al vincularse,
-- ignorando las restricciones de RLS sobre LicenciasXContratante.
-- ==========================================================

-- 1. Modificar función de límite de usuarios
-- Esta función se dispara al insertar en AutorizacionesXUsuario
ALTER FUNCTION public.check_user_limit() SECURITY DEFINER;

-- 2. Modificar función de límite de dispositivos
-- (Por consistencia, aunque el viewer no inserta dispositivos directamente)
ALTER FUNCTION public.check_device_limit() SECURITY DEFINER;

-- NOTA: Al usar SECURITY DEFINER, las funciones se ejecutan con los privilegios
-- del creador (postgres/admin), permitiendo leer la tabla LicenciasXContratante
-- incluso si el usuario actual no tiene permisos directos de SELECT por RLS.



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 24_fix_db_defaults.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: AutorizacionesXUsuario)
-- ==========================================================================

-- ==========================================================
-- 24_FIX_DB_DEFAULTS.SQL
-- Descripción: Asegura valores por defecto en la base de datos
-- para evitar errores de decodificación en la App Android
-- cuando los campos vienen NULL.
-- ==========================================================

-- 1. Asegurar que la columna tenga un valor por defecto en la BD
-- 1 = Pendiente (según tabla EstadosAuth)
ALTER TABLE public."AutorizacionesXUsuario"
ALTER COLUMN "IdEstadoAuth" SET DEFAULT 1;

-- 2. Corregir registros existentes que quedaron en NULL
UPDATE public."AutorizacionesXUsuario"
SET "IdEstadoAuth" = 1
WHERE "IdEstadoAuth" IS NULL;

-- 3. Lo mismo para el Rol de Usuario (por si acaso)
-- 1 = Vendedor / Viewer
ALTER TABLE public."Usuarios"
ALTER COLUMN "IdRol" SET DEFAULT 1;

-- 4. Asegurar que IsConnected tenga default false
ALTER TABLE public."AutorizacionesXUsuario"
ALTER COLUMN "IsConnected" SET DEFAULT FALSE;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 28_fix_realtime_auth_flow_viewer_v2.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: AutorizacionesXUsuario)
-- ==========================================================================

-- ==============================================================================
-- 28_FIX_REALTIME_AUTH_FLOW_VIEWER_V2.SQL
-- Proyecto: NotificaPe - App Viewer
-- Descripción: Versión corregida para evitar error 42710 (Duplicate Table in Publication)
-- y asegurar la reactividad del socket en Autorizaciones y Notificaciones.
-- ==============================================================================

-- 1. REPARACIÓN DE LA TABLA DE AUTORIZACIONES (Socket de Vinculación)
-- Forzamos identidad de réplica completa para que Supabase envíe el payload de cambio de estado.
ALTER TABLE public."AutorizacionesXUsuario" REPLICA IDENTITY FULL;

-- Asegurar que la tabla participe en la difusión por WebSockets de forma segura
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = 'AutorizacionesXUsuario'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public."AutorizacionesXUsuario";
    END IF;
END $$;

-- Política de lectura específica para que el Viewer vea su propio registro de aprobación
DROP POLICY IF EXISTS "Viewer_Ver_Propia_Autorizacion" ON public."AutorizacionesXUsuario";
CREATE POLICY "Viewer_Ver_Propia_Autorizacion"
ON public."AutorizacionesXUsuario"
FOR SELECT
TO authenticated
USING (auth.uid() = "IdUsuario");


-- 2. HABILITAR RECEPCIÓN DE NOTIFICACIONES (Socket de Home/Pagos)
-- Preparamos la tabla de notificaciones para ser escuchada por el Viewer.
ALTER TABLE public."NotificacionesXDispositivo" REPLICA IDENTITY FULL;

-- Asegurar que la tabla participe en la difusión por WebSockets de forma segura
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = 'NotificacionesXDispositivo'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public."NotificacionesXDispositivo";
    END IF;
END $$;

-- Política de Seguridad: El Viewer SOLO puede ver notificaciones de dispositivos
-- donde tiene una autorización en estado 2 (APROBADO).
DROP POLICY IF EXISTS "Viewer_Leer_Pagos_Cajas_Asignadas" ON public."NotificacionesXDispositivo";
CREATE POLICY "Viewer_Leer_Pagos_Cajas_Asignadas"
ON public."NotificacionesXDispositivo"
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public."AutorizacionesXUsuario"
        WHERE "IdDispositivo" = public."NotificacionesXDispositivo"."IdDispositivo"
        AND "IdUsuario" = auth.uid()
        AND "IdEstadoAuth" = 2
    )
);


-- 3. PERMISOS DE ACCESO AL ESQUEMA
-- Aseguramos que el rol de usuario autenticado pueda realizar las consultas necesarias.
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO authenticated;

-- ==============================================================================
-- INSTRUCCIONES:
-- 1. Ejecutar este script en el SQL Editor de Supabase.
-- 2. Reiniciar la App Viewer.
-- ==============================================================================

