-- ==============================================================================
-- SCRIPT MIGRACIÓN SUPABASE - PROYECTO: NOTIFICAPE
-- Descripción: Filtro de seguridad en Trigger FCM para Viewer (Evitar falsos pagos por S/ 0.00 o en REVISION)
-- Autor: Agent (SDD)
-- Fecha: 2026-10-04
-- ==============================================================================

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
    v_alias_dispositivo TEXT;
    v_nombre_negocio TEXT;
BEGIN
    -- 1. AutorizacionesXUsuario (SYNC_AUTH)
    IF TG_TABLE_NAME = 'AutorizacionesXUsuario' THEN
        IF TG_OP = 'UPDATE' THEN
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

    -- 2. Resolver IdDispositivo
    IF TG_TABLE_NAME = 'NotificacionesXDispositivo' OR TG_TABLE_NAME = 'BilleterasXDispositivo' THEN
        IF TG_OP = 'DELETE' THEN 
            dispositivo_id := OLD."IdDispositivo";
        ELSE 
            dispositivo_id := NEW."IdDispositivo"; 
        END IF;
    ELSIF TG_TABLE_NAME = 'NotificacionesAUsuarios' THEN
        IF TG_OP = 'DELETE' THEN 
            SELECT "IdDispositivo" INTO dispositivo_id FROM public."NotificacionesXDispositivo" WHERE "IdSync" = OLD."IdSync";
        ELSE 
            SELECT "IdDispositivo" INTO dispositivo_id FROM public."NotificacionesXDispositivo" WHERE "IdSync" = NEW."IdSync";
        END IF;
    END IF;

    -- 3. Envío Masivo Multicast
    IF dispositivo_id IS NOT NULL THEN
        SELECT COALESCE(jsonb_agg(DISTINCT u."FcmToken"), '[]'::jsonb) INTO target_tokens
        FROM public."AutorizacionesXUsuario" a
        JOIN public."Usuarios" u ON a."IdUsuario" = u."IdUsuario"
        WHERE a."IdDispositivo" = dispositivo_id 
          AND a."IdEstadoAuth" = 2 -- APROBADO
          AND u."FcmToken" IS NOT NULL;

        IF jsonb_array_length(target_tokens) > 0 THEN
            IF TG_TABLE_NAME = 'NotificacionesXDispositivo' THEN
                IF TG_OP = 'INSERT' THEN
                    -- BARRERA 1: Solo notificar cobros legítimos con monto válido
                    IF NEW."Privada" = false AND NEW."MontoCentimos" > 0 AND NEW."EstadoProgreso" = 'PENDIENTE' THEN
                        payload := jsonb_build_object('action', 'NEW_PAYMENT', 'target', target_tokens, 'data_payload', row_to_json(NEW));
                    ELSE
                        payload := NULL;
                    END IF;
                ELSIF TG_OP = 'UPDATE' THEN
                    IF OLD."EstadoProgreso" IS DISTINCT FROM NEW."EstadoProgreso" THEN
                        IF NEW."EstadoProgreso" = 'REVISION' THEN
                            payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME);
                        ELSIF NEW."EstadoProgreso" = 'DESCARTADO' THEN
                            payload := jsonb_build_object('action', 'UPDATE_PAYMENT', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'DISCARDED');
                        ELSIF NEW."EstadoProgreso" = 'APROBADO' THEN
                            payload := jsonb_build_object('action', 'UPDATE_PAYMENT', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'APPROVED');
                        ELSE
                            payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME);
                        END IF;
                    ELSE
                        payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME);
                    END IF;
                ELSE
                    payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME);
                END IF;
            ELSIF TG_TABLE_NAME = 'NotificacionesAUsuarios' THEN
                IF TG_OP = 'UPDATE' THEN
                    IF OLD."EstadoReclamacion" IS DISTINCT FROM NEW."EstadoReclamacion" THEN
                        IF NEW."EstadoReclamacion" = 'APROBADO' THEN
                            DECLARE
                                v_contador INT;
                            BEGIN
                                SELECT "ContadorReclamaciones" INTO v_contador FROM public."NotificacionesXDispositivo" WHERE "IdSync" = NEW."IdSync";
                                IF v_contador = 1 THEN
                                    payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME);
                                ELSE
                                    payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'CLAIM_WON', 'user_id', NEW."IdUsuario");
                                END IF;
                            END;
                        ELSIF NEW."EstadoReclamacion" = 'RECHAZADO' THEN
                            payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'CLAIM_LOST', 'user_id', NEW."IdUsuario");
                        ELSE
                            payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'UPDATE', 'user_id', NEW."IdUsuario");
                        END IF;
                    ELSE
                        payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'UPDATE', 'user_id', NEW."IdUsuario");
                    END IF;
                ELSIF TG_OP = 'INSERT' THEN
                    DECLARE
                        v_contador INT;
                        v_owner UUID;
                    BEGIN
                        SELECT "ContadorReclamaciones" INTO v_contador FROM public."NotificacionesXDispositivo" WHERE "IdSync" = NEW."IdSync";
                        IF v_contador = 1 THEN
                            payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME);
                        ELSE
                            SELECT "IdUsuario" INTO v_owner FROM public."NotificacionesAUsuarios" 
                            WHERE "IdSync" = NEW."IdSync" AND "IdUsuario" != NEW."IdUsuario"
                            ORDER BY "FechaReg" ASC LIMIT 1;
                            
                            payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', 'NEW_CLAIM', 'user_id', NEW."IdUsuario", 'owner_id', v_owner);
                        END IF;
                    END;
                ELSE
                    payload := jsonb_build_object('action', 'SYNC_PAYMENTS', 'target', target_tokens, 'table', TG_TABLE_NAME, 'operation', TG_OP, 'user_id', OLD."IdUsuario");
                END IF;
            ELSIF TG_TABLE_NAME = 'BilleterasXDispositivo' THEN
                IF TG_OP = 'UPDATE' THEN
                    IF OLD."Activo" IS DISTINCT FROM NEW."Activo" THEN
                        IF NEW."Activo" = true THEN
                            payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_tokens, 'operation', 'INSERT');
                        ELSE
                            payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_tokens, 'operation', 'DELETE');
                        END IF;
                    ELSE
                        payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_tokens, 'operation', 'UPDATE');
                    END IF;
                ELSE
                    payload := jsonb_build_object('action', 'SYNC_WALLETS', 'target', target_tokens, 'operation', TG_OP);
                END IF;
            END IF;
            
            IF payload IS NOT NULL THEN
                PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
            END IF;
        END IF;
    END IF;

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$function$;
