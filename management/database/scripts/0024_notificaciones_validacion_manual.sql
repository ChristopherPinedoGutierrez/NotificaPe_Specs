-- ==========================================================
-- 35_notificaciones_validacion_manual.sql
-- Proposito: Añadir columna de auditoria para validaciones manuales
-- y crear un trigger defensivo para asegurar la pureza de los estados.
-- ==========================================================

-- 1. Añadir columna de auditoria
ALTER TABLE public."NotificacionesXDispositivo"
ADD COLUMN IF NOT EXISTS "ValidacionManual" BOOLEAN DEFAULT FALSE;

COMMENT ON COLUMN public."NotificacionesXDispositivo"."ValidacionManual" IS 'True si la notificacion fue corregida y aprobada manualmente por un Gestor desde el Web Panel.';

-- 2. Crear funcion de trigger para defender el estado PENDIENTE
CREATE OR REPLACE FUNCTION public.trg_defend_notif_state()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la app intenta guardarla como PENDIENTE pero el monto es 0 o no detecto remitente,
    -- forzamos su estado a REVISION para que no ensucie la bandeja de pagos validos.
    IF NEW."EstadoProgreso" = 'PENDIENTE' AND (NEW."MontoCentimos" = 0 OR NEW."Remitente" = 'Desconocido' OR NEW."Remitente" IS NULL) THEN
        NEW."EstadoProgreso" := 'REVISION';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Asignar el trigger a la tabla
DROP TRIGGER IF EXISTS trigger_defend_notif_state ON public."NotificacionesXDispositivo";
CREATE TRIGGER trigger_defend_notif_state
BEFORE INSERT OR UPDATE ON public."NotificacionesXDispositivo"
FOR EACH ROW EXECUTE FUNCTION public.trg_defend_notif_state();
