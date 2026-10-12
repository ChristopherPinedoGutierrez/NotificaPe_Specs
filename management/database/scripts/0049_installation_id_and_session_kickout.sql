-- ==============================================================================
-- SCRIPT: 0049_installation_id_and_session_kickout.sql
-- App Origen: viewer
-- Autor: Senior Architect / Antigravity
-- Fecha: 2026-10-11
-- Justificación: Añade soporte para Identificador Único de Dispositivo (InstallationId)
--                en la tabla Usuarios para desacoplar la rotación de FCM tokens
--                del relevo de hardware, y dispara FORCE_LOGOUT al dispositivo previo
--                al detectar un nuevo InstallationId.
-- ==============================================================================

ALTER TABLE public."Usuarios" ADD COLUMN IF NOT EXISTS "InstallationId" VARCHAR(64);

CREATE OR REPLACE FUNCTION public.fn_trg_kickout_sesion_dispositivo()
RETURNS TRIGGER AS $$
DECLARE
    edge_function_url TEXT := 'https://ukwzdlrnengpdnnuvofo.supabase.co/functions/v1/fcm-dispatcher';
    auth_header JSONB := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrd3pkbHJuZW5ncGRubnV2b2ZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MDE2NzgsImV4cCI6MjA5MTE3NzY3OH0.FJHI1KMmSMxB6bhALnBN-qspRlQ4_ippNvTusT6xesY"}'::jsonb;
    payload JSONB;
BEGIN
    IF OLD."InstallationId" IS NOT NULL 
       AND NEW."InstallationId" IS DISTINCT FROM OLD."InstallationId" 
       AND OLD."FcmToken" IS NOT NULL THEN
        
        payload := jsonb_build_object(
            'action', 'FORCE_LOGOUT',
            'target', OLD."FcmToken",
            'data_payload', jsonb_build_object(
                'reason', 'SESSION_REPLACED_BY_NEW_DEVICE',
                'newInstallationId', NEW."InstallationId"
            )::text
        );
        
        PERFORM net.http_post(url := edge_function_url, headers := auth_header, body := payload);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_kickout_sesion_dispositivo ON public."Usuarios";
CREATE TRIGGER trg_kickout_sesion_dispositivo
AFTER UPDATE OF "InstallationId" ON public."Usuarios"
FOR EACH ROW
EXECUTE FUNCTION public.fn_trg_kickout_sesion_dispositivo();
