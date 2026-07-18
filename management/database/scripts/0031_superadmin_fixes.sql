-- Script: 0031_superadmin_fixes.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-07-18
-- Justificación: Políticas RLS para Superadministradores para acceder a Dispositivos, Crédito y Notificaciones sin afectar usuarios normales. Función RPC para ajuste de créditos.

BEGIN;

-- 1. Políticas RLS para Superadministradores (Lectura Extendida y Update Acotado)

-- A. DispositivosXContratante
DROP POLICY IF EXISTS "Superadmin_Read_Dispositivos" ON public."DispositivosXContratante";
CREATE POLICY "Superadmin_Read_Dispositivos" ON public."DispositivosXContratante"
FOR SELECT USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

DROP POLICY IF EXISTS "Superadmin_Update_Dispositivos" ON public."DispositivosXContratante";
CREATE POLICY "Superadmin_Update_Dispositivos" ON public."DispositivosXContratante"
FOR UPDATE USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- B. CreditoXContratante
DROP POLICY IF EXISTS "Superadmin_Read_Credito" ON public."CreditoXContratante";
CREATE POLICY "Superadmin_Read_Credito" ON public."CreditoXContratante"
FOR SELECT USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- C. NotificacionesXDispositivo (Depurador Regex y Limpieza Spam)
DROP POLICY IF EXISTS "Superadmin_Read_Notificaciones" ON public."NotificacionesXDispositivo";
CREATE POLICY "Superadmin_Read_Notificaciones" ON public."NotificacionesXDispositivo"
FOR SELECT USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

DROP POLICY IF EXISTS "Superadmin_Update_Notificaciones" ON public."NotificacionesXDispositivo";
CREATE POLICY "Superadmin_Update_Notificaciones" ON public."NotificacionesXDispositivo"
FOR UPDATE USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- D. LicenciasCola
DROP POLICY IF EXISTS "Superadmin_Read_LicenciasCola" ON public."LicenciasCola";
CREATE POLICY "Superadmin_Read_LicenciasCola" ON public."LicenciasCola"
FOR SELECT USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

DROP POLICY IF EXISTS "Superadmin_Update_LicenciasCola" ON public."LicenciasCola";
CREATE POLICY "Superadmin_Update_LicenciasCola" ON public."LicenciasCola"
FOR UPDATE USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

DROP POLICY IF EXISTS "Superadmin_Delete_LicenciasCola" ON public."LicenciasCola";
CREATE POLICY "Superadmin_Delete_LicenciasCola" ON public."LicenciasCola"
FOR DELETE USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- E. Billeteras y FiltrosXBilletera (Permisos de gestión CRUD para Superadmin)
ALTER TABLE public."Billeteras" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public_Read_Billeteras" ON public."Billeteras";
CREATE POLICY "Public_Read_Billeteras" ON public."Billeteras" FOR SELECT USING (true);
DROP POLICY IF EXISTS "Superadmin_All_Billeteras" ON public."Billeteras";
CREATE POLICY "Superadmin_All_Billeteras" ON public."Billeteras"
FOR ALL USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

ALTER TABLE public."FiltrosXBilletera" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public_Read_Filtros" ON public."FiltrosXBilletera";
CREATE POLICY "Public_Read_Filtros" ON public."FiltrosXBilletera" FOR SELECT USING (true);
DROP POLICY IF EXISTS "Superadmin_All_Filtros" ON public."FiltrosXBilletera";
CREATE POLICY "Superadmin_All_Filtros" ON public."FiltrosXBilletera"
FOR ALL USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()))
WITH CHECK (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- F. Contratantes (Leer a todos los contratantes para el listado)
DROP POLICY IF EXISTS "Superadmin_Read_Contratantes" ON public."Contratantes";
CREATE POLICY "Superadmin_Read_Contratantes" ON public."Contratantes"
FOR SELECT USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));


-- 2. RPC: ajustar_credito_superadmin
-- Propósito: Modificar el saldo del contratante (sumar o restar) dejando rastro de auditoría y sin activar licencias.

CREATE OR REPLACE FUNCTION public.ajustar_credito_superadmin(
    p_id_contratante UUID,
    p_monto_ajuste BIGINT, -- Positivo (abono) o Negativo (cargo)
    p_moneda CHAR(3) DEFAULT 'PEN'
) RETURNS BOOLEAN AS $$
DECLARE
    v_es_superadmin BOOLEAN;
    v_tipo_movimiento TEXT;
    v_monto_absoluto BIGINT;
    v_saldo_actual BIGINT;
BEGIN
    -- Validar permisos de Superadmin
    SELECT EXISTS (
        SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()
    ) INTO v_es_superadmin;
    
    IF NOT v_es_superadmin THEN
        RAISE EXCEPTION 'Acceso denegado. Solo un superadministrador puede ejecutar esta accion.';
    END IF;

    IF p_monto_ajuste = 0 THEN
        RETURN TRUE; -- No hay cambio
    END IF;

    -- Asegurar registro
    PERFORM public.ensure_credito_contratante(p_id_contratante, p_moneda);

    -- Determinar operacion
    IF p_monto_ajuste > 0 THEN
        v_tipo_movimiento := 'ABONO';
        v_monto_absoluto := p_monto_ajuste;
    ELSE
        v_tipo_movimiento := 'CARGO';
        v_monto_absoluto := ABS(p_monto_ajuste);
    END IF;

    -- Bloquear y leer saldo actual
    SELECT "CreditoDisponibleEnUnidadMinima" INTO v_saldo_actual
    FROM public."CreditoXContratante"
    WHERE "IdContratante" = p_id_contratante
    FOR UPDATE;

    IF v_tipo_movimiento = 'CARGO' AND v_saldo_actual < v_monto_absoluto THEN
        RAISE EXCEPTION 'Saldo insuficiente. No se puede retirar % creditos del cliente (Saldo: %).', v_monto_absoluto, v_saldo_actual;
    END IF;

    -- Actualizar saldo
    UPDATE public."CreditoXContratante"
    SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + p_monto_ajuste,
        "UpdatedAt" = NOW()
    WHERE "IdContratante" = p_id_contratante;

    -- Registrar transaccion de auditoria
    PERFORM public.registrar_tx_credito(
        p_id_contratante,
        v_tipo_movimiento,
        'AJUSTE_SUPERADMIN',
        v_monto_absoluto,
        p_moneda,
        NULL,
        NULL,
        'AJUSTE-SA-' || EXTRACT(EPOCH FROM NOW())::BIGINT,
        jsonb_build_object('ejecutado_por', auth.uid(), 'monto_neto', p_monto_ajuste)
    );

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Permisos al RPC
GRANT EXECUTE ON FUNCTION public.ajustar_credito_superadmin(UUID, BIGINT, CHAR) TO authenticated;

COMMIT;
