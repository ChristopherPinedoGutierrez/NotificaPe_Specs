-- ==============================================================================
-- SCRIPT MIGRACIÓN SUPABASE - PROYECTO: NOTIFICAPE
-- Descripción: Agrega columna FcmToken y Triggers para notificación Push-to-Pull vía Edge Function.
-- Autor: Agent (SDD)
-- Fecha: 2026-09-04
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
    -- NOTA: El Bearer token debe ser el ANON_KEY de Supabase para poder enrutar correctamente.
    auth_header JSONB := '{"Content-Type": "application/json", "Authorization": "Bearer [ANON_KEY_HERE]"}'::jsonb;
BEGIN
    -- Lógica BEFORE DELETE (Eliminación de Caja -> Desvincular)
    IF TG_OP = 'DELETE' AND TG_TABLE_NAME = 'DispositivosXContratante' THEN
        target_token := OLD."FcmToken";
        IF target_token IS NOT NULL THEN
            payload := jsonb_build_object('action', 'UNBIND_DEVICE', 'target', target_token);
            PERFORM net.http_post(
                url := edge_function_url,
                headers := auth_header,
                body := payload
            );
        END IF;
        RETURN OLD;
    END IF;

    -- Lógica AFTER UPDATE (Desactivación/Activación o Vencimiento)
    IF TG_OP = 'UPDATE' AND TG_TABLE_NAME = 'DispositivosXContratante' THEN
        IF OLD."Activo" IS DISTINCT FROM NEW."Activo" OR OLD."FechaVencimiento" IS DISTINCT FROM NEW."FechaVencimiento" THEN
            target_token := NEW."FcmToken";
            IF target_token IS NOT NULL THEN
                payload := jsonb_build_object('action', 'SYNC_DEVICE_STATUS', 'target', target_token);
                PERFORM net.http_post(
                    url := edge_function_url,
                    headers := auth_header,
                    body := payload
                );
            END IF;
        END IF;
        RETURN NEW;
    END IF;

    -- Lógica AFTER UPDATE, INSERT, DELETE para Billeteras (Cambio en reglas locales)
    IF TG_TABLE_NAME = 'BilleterasXDispositivo' THEN
        IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
            SELECT "FcmToken" INTO target_token FROM public."DispositivosXContratante" WHERE "IdDispositivo" = NEW."IdDispositivo";
        ELSIF TG_OP = 'DELETE' THEN
            SELECT "FcmToken" INTO target_token FROM public."DispositivosXContratante" WHERE "IdDispositivo" = OLD."IdDispositivo";
        END IF;
        
        IF target_token IS NOT NULL THEN
            payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_token);
            PERFORM net.http_post(
                url := edge_function_url,
                headers := auth_header,
                body := payload
            );
        END IF;
        
        IF TG_OP = 'DELETE' THEN
            RETURN OLD;
        ELSE
            RETURN NEW;
        END IF;
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
