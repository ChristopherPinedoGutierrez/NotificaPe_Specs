-- Script: 0029_rpc_observacion_justificacion_reclamos
-- App Origen: NotificaPe_Viewer
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-07-14
-- Justificación: Implementación de funciones RPC seguras (SECURITY DEFINER) para permitir la actualización de observaciones comerciales y descargos/justificaciones en disputas sin bloqueos por políticas RLS restrictivas en la tabla NotificacionesAUsuarios.

-- 1. RPC para actualizar la observación de una reclamación de pago
CREATE OR REPLACE FUNCTION public.actualizar_observacion_reclamo(
    p_id_sync uuid, 
    p_id_usuario uuid, 
    p_observacion text
)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_estado_maestra VARCHAR(20);
BEGIN
    -- Validar existencia y que el pago no esté cerrado en la maestra
    SELECT "EstadoProgreso" INTO v_estado_maestra
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync;

    IF v_estado_maestra IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    IF v_estado_maestra = 'CERRADO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PERIOD_CLOSED');
    END IF;

    -- Actualizar la observación en NotificacionesAUsuarios para este usuario
    UPDATE public."NotificacionesAUsuarios"
    SET "Observacion" = p_observacion
    WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('success', false, 'error', 'CLAIM_NOT_FOUND');
    END IF;

    RETURN jsonb_build_object('success', true);
END;
$function$;

-- 2. RPC para actualizar la justificación/descargo de una disputa activa
CREATE OR REPLACE FUNCTION public.actualizar_justificacion_reclamo(
    p_id_sync uuid, 
    p_id_usuario uuid, 
    p_justificacion text
)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_estado_maestra VARCHAR(20);
BEGIN
    -- Validar existencia y que el pago no esté cerrado en la maestra
    SELECT "EstadoProgreso" INTO v_estado_maestra
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync;

    IF v_estado_maestra IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    IF v_estado_maestra = 'CERRADO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PERIOD_CLOSED');
    END IF;

    -- Actualizar la justificación en NotificacionesAUsuarios para este usuario
    UPDATE public."NotificacionesAUsuarios"
    SET "JustificacionConflicto" = p_justificacion
    WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

    IF NOT FOUND THEN
        RETURN jsonb_build_object('success', false, 'error', 'CLAIM_NOT_FOUND');
    END IF;

    RETURN jsonb_build_object('success', true);
END;
$function$;
