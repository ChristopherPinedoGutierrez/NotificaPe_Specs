-- ==============================================================================
-- 22_rls_conflictos_admin.sql
-- Descripción: Policy RLS que permite al Contratante (admin) leer los conflictos
--              reportados sobre las notificaciones de sus dispositivos.
--
-- Contexto: El script 19 creó ConflictosXNotificacion con RLS para vendedores
--           (reportar y ver sus propios conflictos). Pero el admin también necesita
--           leer todos los conflictos de su scope para incluirlos en el reporte
--           XLSX (columna "Referencia") y para resolver disputas desde el panel.
-- ==============================================================================

-- El Contratante puede leer todos los conflictos de sus notificaciones.
-- La verificación de propiedad va vía NotificacionesXDispositivo.IdContratante.
CREATE POLICY "Contratante lee conflictos de sus dispositivos"
ON public."ConflictosXNotificacion"
FOR SELECT
USING (
    EXISTS (
        SELECT 1
        FROM public."NotificacionesXDispositivo" n
        WHERE n."IdSync"         = public."ConflictosXNotificacion"."IdSync"
          AND n."IdContratante"  = auth.uid()
    )
);

-- Opcional: el Contratante puede marcar conflictos como resueltos (UPDATE).
-- Necesario si el admin resuelve desde el panel web sin pasar por una función RPC.
CREATE POLICY "Contratante resuelve conflictos de sus dispositivos"
ON public."ConflictosXNotificacion"
FOR UPDATE
USING (
    EXISTS (
        SELECT 1
        FROM public."NotificacionesXDispositivo" n
        WHERE n."IdSync"         = public."ConflictosXNotificacion"."IdSync"
          AND n."IdContratante"  = auth.uid()
    )
);
