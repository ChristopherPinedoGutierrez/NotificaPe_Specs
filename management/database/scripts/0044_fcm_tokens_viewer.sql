-- ==============================================================================
-- SCRIPT MIGRACIÓN SUPABASE - PROYECTO: NOTIFICAPE
-- Descripción: Agrega columna FcmToken a Usuarios y Triggers para notificación Push-to-Pull hacia Viewer.
-- Autor: Agent (SDD)
-- Fecha: 2026-09-13
-- Fase: [E6] Refactorización Push-to-Pull (FCM) en Viewer
-- ==============================================================================

-- 1. EXTENSIÓN NECESARIA PARA WEBHOOKS (Si no existe, ya debería existir por Admin)
CREATE EXTENSION IF NOT EXISTS "pg_net";

-- 2. MODIFICACIÓN DE ESQUEMA
ALTER TABLE public."Usuarios" ADD COLUMN IF NOT EXISTS "FcmToken" TEXT;

-- 3. FUNCIÓN DISPARADORA (DISPATCHER PARA VIEWER)
CREATE OR REPLACE FUNCTION public.fn_dispatch_fcm_viewer()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    target_token TEXT;
    target_tokens JSONB;
    payload JSONB;
    edge_function_url TEXT := 'https://ukwzdlrnengpdnnuvofo.supabase.co/functions/v1/fcm-dispatcher';
    auth_header JSONB := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrd3pkbHJuZW5ncGRubnV2b2ZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MDE2NzgsImV4cCI6MjA5MTE3NzY3OH0.FJHI1KMmSMxB6bhALnBN-qspRlQ4_ippNvTusT6xesY"}'::jsonb;
    dispositivo_id UUID;
    v_alias_dispositivo VARCHAR(50);
    v_nombre_negocio VARCHAR(100);
BEGIN
    -- Lógica para AutorizacionesXUsuario (SYNC_AUTH)
    IF TG_TABLE_NAME = 'AutorizacionesXUsuario' THEN
        IF TG_OP = 'UPDATE' THEN
            -- Solo notificar si cambió el estado de aprobación
            IF OLD."IdEstadoAuth" IS DISTINCT FROM NEW."IdEstadoAuth" THEN
                SELECT "FcmToken" INTO target_token FROM public."Usuarios" WHERE "IdUsuario" = NEW."IdUsuario";
                
                SELECT d."AliasDispositivo", c."NombreNegocio" 
                INTO v_alias_dispositivo, v_nombre_negocio
                FROM public."DispositivosXContratante" d
                JOIN public."Contratantes" c ON d."IdContratante" = c."IdContratante"
                WHERE d."IdDispositivo" = NEW."IdDispositivo";

                IF target_token IS NOT NULL THEN
                    payload := jsonb_build_object(
                        'action', 'SYNC_AUTH', 
                        'target', target_token,
                        'data_payload', jsonb_build_object(
                            'idAutorizacion', NEW."IdAutorizacion",
                            'estado', NEW."IdEstadoAuth",
                            'dispositivo_id', NEW."IdDispositivo",
                            'alias_dispositivo', v_alias_dispositivo,
                            'nombre_negocio', v_nombre_negocio
                        )::text
                    );
                    PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
                END IF;
            END IF;
        END IF;
        RETURN NEW;
    END IF;

    -- Extraer el IdDispositivo afectado para Notificaciones o Billeteras
    IF TG_TABLE_NAME = 'NotificacionesXDispositivo' OR TG_TABLE_NAME = 'BilleterasXDispositivo' THEN
        IF TG_OP = 'DELETE' THEN 
            dispositivo_id := OLD."IdDispositivo";
        ELSE 
            dispositivo_id := NEW."IdDispositivo"; 
        END IF;
    ELSIF TG_TABLE_NAME = 'NotificacionesAUsuarios' THEN
        -- Para conflictos, necesitamos subir a la tabla maestra para saber de qué caja es el reclamo
        IF TG_OP = 'DELETE' THEN 
            SELECT "IdDispositivo" INTO dispositivo_id FROM public."NotificacionesXDispositivo" WHERE "IdSync" = OLD."IdSync";
        ELSE 
            SELECT "IdDispositivo" INTO dispositivo_id FROM public."NotificacionesXDispositivo" WHERE "IdSync" = NEW."IdSync";
        END IF;
    END IF;

    -- Envío masivo Multicast (Sin IsConnected)
    IF dispositivo_id IS NOT NULL THEN
        SELECT COALESCE(jsonb_agg(u."FcmToken"), '[]'::jsonb) INTO target_tokens
        FROM public."AutorizacionesXUsuario" a
        JOIN public."Usuarios" u ON a."IdUsuario" = u."IdUsuario"
        WHERE a."IdDispositivo" = dispositivo_id 
          AND a."IdEstadoAuth" = 2 -- 2 = APROBADO
          AND u."FcmToken" IS NOT NULL;

        IF jsonb_array_length(target_tokens) > 0 THEN
            IF TG_TABLE_NAME = 'NotificacionesXDispositivo' THEN
                IF TG_OP = 'INSERT' THEN
                    payload := jsonb_build_object('action', 'NEW_PAYMENT', 'target', target_tokens, 'data_payload', row_to_json(NEW));
                ELSIF TG_OP = 'UPDATE' THEN
                    payload := jsonb_build_object('action', 'UPDATE_PAYMENT', 'target', target_tokens);
                ELSE
                    payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens);
                END IF;
            ELSIF TG_TABLE_NAME = 'NotificacionesAUsuarios' THEN
                payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens);
            ELSIF TG_TABLE_NAME = 'BilleterasXDispositivo' THEN
                payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_tokens);
            END IF;
            PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
        END IF;
    END IF;

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$function$;

-- 4. CREACIÓN DE TRIGGERS (EL FRANCOTIRADOR FCM VIEWER)

-- 4.1 Trigger en Autorizaciones (Para expulsar o aprobar cajeros)
DROP TRIGGER IF EXISTS trg_fcm_update_auth_viewer ON public."AutorizacionesXUsuario";
CREATE TRIGGER trg_fcm_update_auth_viewer
    AFTER UPDATE ON public."AutorizacionesXUsuario"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm_viewer();

-- 4.2 Trigger en Pagos (Nuevos cobros validados)
DROP TRIGGER IF EXISTS trg_fcm_notificaciones_viewer ON public."NotificacionesXDispositivo";
CREATE TRIGGER trg_fcm_notificaciones_viewer
    AFTER INSERT OR UPDATE OR DELETE ON public."NotificacionesXDispositivo"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm_viewer();

-- 4.3 Trigger en Reclamos (Participación y Disputas de Cajeros)
DROP TRIGGER IF EXISTS trg_fcm_conflictos_viewer ON public."NotificacionesAUsuarios";
CREATE TRIGGER trg_fcm_conflictos_viewer
    AFTER INSERT OR UPDATE OR DELETE ON public."NotificacionesAUsuarios"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm_viewer();

-- 4.4 Trigger en QRs/Billeteras (Configuración admin cambia QR)
DROP TRIGGER IF EXISTS trg_fcm_wallets_viewer ON public."BilleterasXDispositivo";
CREATE TRIGGER trg_fcm_wallets_viewer
    AFTER INSERT OR UPDATE OR DELETE ON public."BilleterasXDispositivo"
    FOR EACH ROW EXECUTE FUNCTION public.fn_dispatch_fcm_viewer();
