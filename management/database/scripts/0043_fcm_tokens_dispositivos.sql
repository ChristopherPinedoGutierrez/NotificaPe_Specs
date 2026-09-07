-- ==============================================================================
-- SCRIPT MIGRACIÓN SUPABASE - PROYECTO: NOTIFICAPE
-- Descripción: Agrega columna FcmToken y Triggers para notificación Push-to-Pull vía Edge Function.
-- Autor: Agent (SDD)
-- Fecha: 2026-09-04
-- Actualizado: 2026-09-07 (Inclusión de Triggers de Reglas y Notificaciones)
-- ==============================================================================

-- 1. EXTENSIÓN NECESARIA PARA WEBHOOKS (Si no existe)
CREATE EXTENSION IF NOT EXISTS "pg_net";

-- 2. MODIFICACIÓN DE ESQUEMA
ALTER TABLE public."DispositivosXContratante" ADD COLUMN IF NOT EXISTS "FcmToken" TEXT;
ALTER TABLE public."DispositivosXContratante" ADD COLUMN IF NOT EXISTS "AppVersion" VARCHAR(20);

-- 3. FUNCIÓN DISPARADORA (DISPATCHER)
CREATE OR REPLACE FUNCTION public.fn_dispatch_fcm()
RETURNS TRIGGER AS $$
DECLARE
    target_token TEXT;
    payload JSONB;
    edge_function_url TEXT := 'https://ukwzdlrnengpdnnuvofo.supabase.co/functions/v1/fcm-dispatcher';
    auth_header JSONB := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrd3pkbHJuZW5ncGRubnV2b2ZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MDE2NzgsImV4cCI6MjA5MTE3NzY3OH0.FJHI1KMmSMxB6bhALnBN-qspRlQ4_ippNvTusT6xesY"}'::jsonb;
    disp_record RECORD;
    billetera_id SMALLINT;
BEGIN
    -- Lógica BEFORE DELETE (Eliminación de Caja -> Desvincular)
    IF TG_OP = 'DELETE' AND TG_TABLE_NAME = 'DispositivosXContratante' THEN
        target_token := OLD."FcmToken";
        IF target_token IS NOT NULL THEN
            payload := jsonb_build_object('action', 'UNBIND_DEVICE', 'target', target_token);
            PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
        END IF;
        RETURN OLD;
    END IF;

    -- Lógica AFTER UPDATE (Desactivación/Activación)
    IF TG_OP = 'UPDATE' AND TG_TABLE_NAME = 'DispositivosXContratante' THEN
        IF OLD."Activo" IS DISTINCT FROM NEW."Activo" THEN
            target_token := NEW."FcmToken";
            IF target_token IS NOT NULL THEN
                payload := jsonb_build_object('action', 'SYNC_DEVICE_STATUS', 'target', target_token);
                PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
            END IF;
        END IF;
        RETURN NEW;
    END IF;

    -- Lógica para Billeteras
    IF TG_TABLE_NAME = 'BilleterasXDispositivo' THEN
        IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
            SELECT "FcmToken" INTO target_token FROM public."DispositivosXContratante" WHERE "IdDispositivo" = NEW."IdDispositivo";
        ELSIF TG_OP = 'DELETE' THEN
            SELECT "FcmToken" INTO target_token FROM public."DispositivosXContratante" WHERE "IdDispositivo" = OLD."IdDispositivo";
        END IF;
        IF target_token IS NOT NULL THEN
            payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_token);
            PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
        END IF;
        IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
    END IF;

    -- Lógica para Reglas/Filtros
    IF TG_TABLE_NAME = 'FiltrosXBilletera' THEN
        IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
            billetera_id := NEW."IdBilletera";
        ELSIF TG_OP = 'DELETE' THEN
            billetera_id := OLD."IdBilletera";
        END IF;
        FOR disp_record IN
            SELECT d."FcmToken"
            FROM public."DispositivosXContratante" d
            JOIN public."BilleterasXDispositivo" bd ON d."IdDispositivo" = bd."IdDispositivo"
            WHERE bd."IdBilletera" = billetera_id AND d."FcmToken" IS NOT NULL
        LOOP
            payload := jsonb_build_object('action', 'SYNC_RULES', 'target', disp_record."FcmToken");
            PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
        END LOOP;
        IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
    END IF;

    -- Lógica para Notificaciones
    IF TG_TABLE_NAME = 'NotificacionesXDispositivo' THEN
        IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
            SELECT "FcmToken" INTO target_token FROM public."DispositivosXContratante" WHERE "IdDispositivo" = OLD."IdDispositivo";
            IF target_token IS NOT NULL THEN
                payload := jsonb_build_object('action', 'SYNC_NOTIFICATIONS', 'target', target_token);
                PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
            END IF;
        END IF;
        IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. CREACIÓN DE TRIGGERS
DROP TRIGGER IF EXISTS trg_fcm_delete_caja ON public."DispositivosXContratante";
CREATE TRIGGER trg_fcm_delete_caja
    BEFORE DELETE ON public."DispositivosXContratante"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm();

DROP TRIGGER IF EXISTS trg_fcm_update_caja ON public."DispositivosXContratante";
CREATE TRIGGER trg_fcm_update_caja
    AFTER UPDATE ON public."DispositivosXContratante"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm();

DROP TRIGGER IF EXISTS trg_fcm_wallets_caja ON public."BilleterasXDispositivo";
CREATE TRIGGER trg_fcm_wallets_caja
    AFTER INSERT OR UPDATE OR DELETE ON public."BilleterasXDispositivo"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm();

DROP TRIGGER IF EXISTS trg_fcm_filtros_caja ON public."FiltrosXBilletera";
CREATE TRIGGER trg_fcm_filtros_caja
    AFTER INSERT OR UPDATE OR DELETE ON public."FiltrosXBilletera"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm();

DROP TRIGGER IF EXISTS trg_fcm_notificaciones_caja ON public."NotificacionesXDispositivo";
CREATE TRIGGER trg_fcm_notificaciones_caja
    AFTER UPDATE OR DELETE ON public."NotificacionesXDispositivo"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm();
