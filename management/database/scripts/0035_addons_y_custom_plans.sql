-- Script: 0035_addons_y_custom_plans.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-08-03
-- Justificación: [CR-014] Módulos de Expansión (Add-ons) y Planes a Medida (Enterprise).

BEGIN;

-- 1. Alterar tabla Licencias (Catálogo Maestro)
ALTER TABLE public."Licencias" 
ADD COLUMN IF NOT EXISTS "IdContratanteExclusivo" UUID REFERENCES auth.users(id) ON DELETE CASCADE,
ADD COLUMN IF NOT EXISTS "PermiteAddons" BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS "PrecioExtraUsuarioCentimos" INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS "PrecioExtraDispositivoCentimos" INT DEFAULT 0;

-- 2. Alterar tabla LicenciasXContratante (Inventario Activo)
ALTER TABLE public."LicenciasXContratante"
ADD COLUMN IF NOT EXISTS "ExtraUsuarios" INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS "ExtraDispositivos" INT DEFAULT 0;

-- 3. Actualizar función de ayuda: get_licencia_activa
DROP FUNCTION IF EXISTS public.get_licencia_activa(UUID);
CREATE OR REPLACE FUNCTION public.get_licencia_activa(p_id_contratante UUID)
RETURNS TABLE (
  "IdLicenciaContratante" INT,
  "IdLicencia"            SMALLINT,
  "Nombre"                VARCHAR(50),
  "LimiteDispositivos"    INT,
  "LimiteUsuarios"        INT,
  "PrecioCentimos"        INT,
  "DuracionDias"          INT,
  "FechaInicio"           TIMESTAMPTZ,
  "FechaExpiracion"       TIMESTAMPTZ,
  "ExtraUsuarios"         INT,
  "ExtraDispositivos"     INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    lxc."IdLicenciaContratante",
    lxc."IdLicencia",
    l."Nombre",
    l."LimiteDispositivos",
    l."LimiteUsuarios",
    l."PrecioCentimos",
    l."DuracionDias",
    lxc."FechaInicio",
    lxc."FechaExpiracion",
    lxc."ExtraUsuarios",
    lxc."ExtraDispositivos"
  FROM public."LicenciasXContratante" lxc
  JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
  WHERE lxc."IdContratante" = p_id_contratante
    AND lxc."Activo" = TRUE
    AND lxc."FechaExpiracion" > NOW()
  LIMIT 1;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;


-- 4. Actualizar Trigger: check_device_limit
CREATE OR REPLACE FUNCTION public.check_device_limit()
RETURNS TRIGGER AS $$
DECLARE
  v_limite_disp  INT;
  v_extra_disp   INT;
  v_total_limit  INT;
  v_total_disp   INT;
  v_nombre_plan  VARCHAR(50);
BEGIN
  -- Obtener límite base y extra
  SELECT l."LimiteDispositivos", l."Nombre", COALESCE(lxc."ExtraDispositivos", 0)
    INTO v_limite_disp, v_nombre_plan, v_extra_disp
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = NEW."IdContratante"
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  IF v_limite_disp IS NULL THEN
    RAISE EXCEPTION 'Sin licencia activa: el contratante no tiene un plan vigente para crear o activar dispositivos.';
  END IF;
  
  v_total_limit := v_limite_disp + v_extra_disp;

  -- Validar
  IF (TG_OP = 'INSERT' AND NEW."Activo" = TRUE) OR 
     (TG_OP = 'UPDATE' AND OLD."Activo" = FALSE AND NEW."Activo" = TRUE) THEN
     
     SELECT COUNT(*) INTO v_total_disp
       FROM public."DispositivosXContratante"
      WHERE "IdContratante" = NEW."IdContratante"
        AND "Activo" = TRUE;

     IF v_total_disp >= v_total_limit THEN
       RAISE EXCEPTION 'LímiteDispositivos: el plan "%" (con expansiones) permite hasta % dispositivos activos. Ya tienes % activos.',
         v_nombre_plan, v_total_limit, v_total_disp;
     END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 5. Actualizar Trigger: check_user_limit
CREATE OR REPLACE FUNCTION public.check_user_limit()
RETURNS TRIGGER AS $$
DECLARE
  v_id_contratante  UUID;
  v_limite_users    INT;
  v_extra_users     INT;
  v_total_limit     INT;
  v_total_users     INT;
  v_nombre_plan     VARCHAR(50);
BEGIN
  SELECT "IdContratante" INTO v_id_contratante
    FROM public."DispositivosXContratante"
   WHERE "IdDispositivo" = NEW."IdDispositivo";

  IF v_id_contratante IS NULL THEN
    RAISE EXCEPTION 'Dispositivo no encontrado o sin contratante asignado.';
  END IF;

  SELECT l."LimiteUsuarios", l."Nombre", COALESCE(lxc."ExtraUsuarios", 0)
    INTO v_limite_users, v_nombre_plan, v_extra_users
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = v_id_contratante
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  IF v_limite_users IS NULL THEN
    RAISE EXCEPTION 'Sin licencia activa: el contratante no tiene un plan vigente.';
  END IF;
  
  v_total_limit := v_limite_users + v_extra_users;

  IF (TG_OP = 'INSERT' AND NEW."IdEstadoAuth" = 2) OR 
     (TG_OP = 'UPDATE' AND OLD."IdEstadoAuth" != 2 AND NEW."IdEstadoAuth" = 2) THEN

     SELECT COUNT(DISTINCT a."IdUsuario") INTO v_total_users
       FROM public."AutorizacionesXUsuario" a
       JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
      WHERE d."IdContratante" = v_id_contratante
        AND a."IdEstadoAuth" = 2;

     IF EXISTS (
       SELECT 1
         FROM public."AutorizacionesXUsuario" a
         JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
        WHERE d."IdContratante" = v_id_contratante
          AND a."IdUsuario" = NEW."IdUsuario"
          AND a."IdEstadoAuth" = 2
          AND a."IdAutorizacion" != NEW."IdAutorizacion"
     ) THEN
       RETURN NEW;
     END IF;

     IF v_total_users >= v_total_limit THEN
       RAISE EXCEPTION 'LímiteUsuarios: el plan "%" (con expansiones) permite hasta % usuarios únicos aprobados. Ya tienes % aprobados.',
         v_nombre_plan, v_total_limit, v_total_users;
     END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 6. Actualizar Trigger: enforce_downgrade_limits
CREATE OR REPLACE FUNCTION public.enforce_downgrade_limits()
RETURNS TRIGGER AS $$
DECLARE
  v_limite_disp  INT;
  v_limite_users INT;
  v_total_disp_limit INT;
  v_total_user_limit INT;
BEGIN
  IF NEW."Activo" = TRUE THEN
    SELECT l."LimiteDispositivos", l."LimiteUsuarios"
      INTO v_limite_disp, v_limite_users
      FROM public."Licencias" l
     WHERE l."IdLicencia" = NEW."IdLicencia";
     
    v_total_disp_limit := v_limite_disp + COALESCE(NEW."ExtraDispositivos", 0);
    v_total_user_limit := v_limite_users + COALESCE(NEW."ExtraUsuarios", 0);

    UPDATE public."DispositivosXContratante"
       SET "Activo" = FALSE
     WHERE "IdDispositivo" IN (
         SELECT "IdDispositivo"
           FROM public."DispositivosXContratante"
          WHERE "IdContratante" = NEW."IdContratante"
            AND "Activo" = TRUE
          ORDER BY "FechaReg" DESC
         OFFSET v_total_disp_limit
     );

    UPDATE public."AutorizacionesXUsuario"
       SET "IdEstadoAuth" = 3
     WHERE "IdAutorizacion" IN (
         SELECT a."IdAutorizacion"
           FROM public."AutorizacionesXUsuario" a
           JOIN public."DispositivosXContratante" d ON d."IdDispositivo" = a."IdDispositivo"
          WHERE d."IdContratante" = NEW."IdContratante"
            AND a."IdEstadoAuth" = 2
          ORDER BY a."FechRegist" DESC
         OFFSET v_total_user_limit
     );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 7. Función Transaccional de Compra de Add-ons (Ticket Mínimo y Vuelto en Crédito)
CREATE OR REPLACE FUNCTION public.procesar_compra_addon(
  p_id_contratante UUID,
  p_extra_usuarios INT,
  p_extra_dispositivos INT,
  p_monto_pagado_pasarela BIGINT,
  p_clave_idempotencia VARCHAR(120),
  p_id_operacion_pago VARCHAR(120) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
  v_lic_activa RECORD;
  v_dias_restantes NUMERIC;
  v_dias_plan NUMERIC;
  v_costo_unitario_usr BIGINT;
  v_costo_unitario_disp BIGINT;
  v_costo_total_prorrateado BIGINT;
  v_saldo_actual BIGINT;
  v_nuevo_saldo BIGINT;
BEGIN
  IF p_extra_usuarios < 0 OR p_extra_dispositivos < 0 THEN
    RAISE EXCEPTION 'Las cantidades extra no pueden ser negativas.';
  END IF;

  IF p_extra_usuarios = 0 AND p_extra_dispositivos = 0 THEN
    RAISE EXCEPTION 'Debe solicitar al menos un addon.';
  END IF;

  -- 1. Identificar Licencia Activa
  SELECT lxc."IdLicenciaContratante", lxc."FechaExpiracion", l."DuracionDias", l."PrecioExtraUsuarioCentimos", l."PrecioExtraDispositivoCentimos"
    INTO v_lic_activa
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = p_id_contratante
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No se encontro una licencia activa para agregar addons.';
  END IF;

  v_costo_unitario_usr := COALESCE(v_lic_activa."PrecioExtraUsuarioCentimos", 0);
  v_costo_unitario_disp := COALESCE(v_lic_activa."PrecioExtraDispositivoCentimos", 0);

  IF (p_extra_usuarios > 0 AND v_costo_unitario_usr = 0) OR (p_extra_dispositivos > 0 AND v_costo_unitario_disp = 0) THEN
    RAISE EXCEPTION 'El plan actual no admite o no tiene precio configurado para el addon solicitado.';
  END IF;

  -- 2. Prorrateo
  v_dias_plan := NULLIF(v_lic_activa."DuracionDias", 0);
  IF v_dias_plan IS NULL OR v_dias_plan = 0 THEN v_dias_plan := 30; END IF;

  v_dias_restantes := GREATEST(0, EXTRACT(EPOCH FROM (v_lic_activa."FechaExpiracion" - NOW())) / 86400.0);
  
  -- Fórmula de costo total
  v_costo_total_prorrateado := CEIL(
    ( (p_extra_usuarios * v_costo_unitario_usr) + (p_extra_dispositivos * v_costo_unitario_disp) ) 
    * (v_dias_restantes / v_dias_plan)
  )::BIGINT;

  -- 3. Validación Financiera
  PERFORM public.ensure_credito_contratante(p_id_contratante, 'PEN');
  
  SELECT "CreditoDisponibleEnUnidadMinima" INTO v_saldo_actual
    FROM public."CreditoXContratante"
   WHERE "IdContratante" = p_id_contratante
   FOR UPDATE; -- Lock pesimista

  v_nuevo_saldo := v_saldo_actual + COALESCE(p_monto_pagado_pasarela, 0) - v_costo_total_prorrateado;

  IF v_nuevo_saldo < 0 THEN
    RAISE EXCEPTION 'Fondos insuficientes. Costo prorrateado: %, Pagado en pasarela: %, Saldo actual: %', 
      v_costo_total_prorrateado, COALESCE(p_monto_pagado_pasarela, 0), v_saldo_actual;
  END IF;

  -- 4. Registro de Movimientos y Actualización de Saldos
  IF p_monto_pagado_pasarela > 0 THEN
    PERFORM public.registrar_tx_credito(
      p_id_contratante,
      'ABONO',
      'PAGO_ADDON_PASARELA',
      p_monto_pagado_pasarela,
      'PEN',
      NULL,
      p_id_operacion_pago,
      p_clave_idempotencia || '-PASARELA'
    );
  END IF;

  IF v_costo_total_prorrateado > 0 THEN
    PERFORM public.registrar_tx_credito(
      p_id_contratante,
      'CARGO',
      'COMPRA_ADDON',
      v_costo_total_prorrateado,
      'PEN',
      NULL,
      p_id_operacion_pago,
      p_clave_idempotencia || '-CARGO'
    );
  END IF;

  UPDATE public."CreditoXContratante"
     SET "CreditoDisponibleEnUnidadMinima" = v_nuevo_saldo,
         "UpdatedAt" = NOW()
   WHERE "IdContratante" = p_id_contratante;

  -- 5. Aplicación del Módulo a la Licencia Activa
  UPDATE public."LicenciasXContratante"
     SET "ExtraUsuarios" = COALESCE("ExtraUsuarios", 0) + p_extra_usuarios,
         "ExtraDispositivos" = COALESCE("ExtraDispositivos", 0) + p_extra_dispositivos
   WHERE "IdLicenciaContratante" = v_lic_activa."IdLicenciaContratante";

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMIT;
