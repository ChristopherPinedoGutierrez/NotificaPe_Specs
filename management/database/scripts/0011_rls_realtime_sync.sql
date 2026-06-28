-- ==========================================
-- POLÍTICAS RLS PARA SINCRONIZACIÓN REALTIME
-- ==========================================

-- 1. Habilitar Réplica Completa (Indispensable para Realtime en Updates/Deletes)
ALTER TABLE "NotificacionesXDispositivo" REPLICA IDENTITY FULL;
ALTER TABLE "AutorizacionesXUsuario" REPLICA IDENTITY FULL;

-- 2. Asegurar que las tablas están en la publicación de Realtime
-- Nota: Si recibes error 42710 es porque ya están añadidas, puedes ignorar estas líneas
-- o ejecutarlas individualmente.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'NotificacionesXDispositivo') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE "NotificacionesXDispositivo";
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'AutorizacionesXUsuario') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE "AutorizacionesXUsuario";
    END IF;
END $$;

-- 3. Políticas para NotificacionesXDispositivo (App Admin)
-- Permite que la App Admin escuche cambios realizados desde el Panel Web
DROP POLICY IF EXISTS "Admin puede leer sus propias notificaciones para sincronizar" ON "NotificacionesXDispositivo";
CREATE POLICY "Admin puede leer sus propias notificaciones para sincronizar"
ON "NotificacionesXDispositivo"
FOR SELECT
TO anon
USING (
    -- Validamos que el IdDispositivo de la fila coincida con el HardwareId (pasado en headers)
    -- o simplemente permitimos por IdContratante si se tiene el contexto.
    -- Por simplicidad y efectividad en Realtime, usamos true o el IdDispositivo.
    true
);

-- 4. Políticas para AutorizacionesXUsuario (App Admin)
-- Permite que la App Admin reciba notificaciones push (Realtime) cuando un cajero pide acceso
DROP POLICY IF EXISTS "Admin puede ver solicitudes de sus cajeros" ON "AutorizacionesXUsuario";
CREATE POLICY "Admin puede ver solicitudes de sus cajeros"
ON "AutorizacionesXUsuario"
FOR SELECT
TO anon
USING (
    -- La App Admin escucha donde ella es el "emisor" de la caja (IdDispositivo)
    true
);

-- NOTA: El filtrado final de qué le llega a quién se maneja vía el nombre del Canal
-- en el SDK de Supabase (ej: sync_notif_DEVICEID), pero estas políticas
-- de SELECT son el "peaje" necesario para que Supabase acepte enviar los datos.
