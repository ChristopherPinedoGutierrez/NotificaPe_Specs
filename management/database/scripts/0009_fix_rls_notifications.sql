-- CORRECCIÓN: Las notificaciones deben filtrarse por Contratante Y Dispositivo
-- para evitar que una caja vea lo de otra del mismo dueño.

DROP POLICY IF EXISTS "Dueño lee y edita notificaciones de sus cajas" ON public."NotificacionesXDispositivo";

CREATE POLICY "Dueño accede a notificaciones de sus propios dispositivos"
ON public."NotificacionesXDispositivo"
FOR ALL
USING (
    auth.uid() = "IdContratante"
    AND
    EXISTS (
        SELECT 1 FROM public."DispositivosXContratante" d
        WHERE d."IdDispositivo" = public."NotificacionesXDispositivo"."IdDispositivo"
        AND d."IdContratante" = auth.uid()
    )
);
