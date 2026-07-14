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

-- 3. RPC para retirar un reclamo o disputa previniendo estados inconsistentes (limbo)
CREATE OR REPLACE FUNCTION public.retirar_reclamo_v4(
    p_id_sync uuid, 
    p_id_usuario uuid
)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_estado_maestra VARCHAR(20);
    v_restantes INT;
    v_unico_usuario UUID;
BEGIN
    -- 1. Validar estado en la maestra
    SELECT "EstadoProgreso" INTO v_estado_maestra
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync;

    IF v_estado_maestra IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    IF v_estado_maestra = 'CERRADO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PERIOD_CLOSED');
    END IF;

    -- 2. Eliminar la participación del usuario actual
    DELETE FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

    -- 3. Contar cuántos usuarios quedan reclamando este pago
    SELECT COUNT(*), MIN("IdUsuario") INTO v_restantes, v_unico_usuario
    FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" = p_id_sync;

    IF v_restantes = 0 THEN
        -- CASO A: No queda nadie. Liberación total del pago a PENDIENTE.
        UPDATE public."NotificacionesXDispositivo"
        SET "IdUsuarioGanador" = NULL,
            "EstadoProgreso" = 'PENDIENTE',
            "ContadorReclamaciones" = 0
        WHERE "IdSync" = p_id_sync;
    ELSIF v_restantes = 1 THEN
        -- CASO B: Queda exactamente un usuario. Se vuelve el ganador oficial.
        -- Su reclamación se aprueba.
        UPDATE public."NotificacionesAUsuarios"
        SET "EstadoReclamacion" = 'APROBADO'
        WHERE "IdSync" = p_id_sync AND "IdUsuario" = v_unico_usuario;

        -- Actualizar la maestra a COMPLETADO con el ganador único
        UPDATE public."NotificacionesXDispositivo"
        SET "IdUsuarioGanador" = v_unico_usuario,
            "EstadoProgreso" = 'COMPLETADO',
            "ContadorReclamaciones" = 1
        WHERE "IdSync" = p_id_sync;
    ELSE
        -- CASO C: Quedan múltiples usuarios. El pago sigue en disputa (REVISION).
        -- Solo actualizamos el contador de reclamaciones en la maestra.
        UPDATE public."NotificacionesXDispositivo"
        SET "ContadorReclamaciones" = v_restantes
        WHERE "IdSync" = p_id_sync;
    END IF;

    RETURN jsonb_build_object('success', true);
END;
$function$;

