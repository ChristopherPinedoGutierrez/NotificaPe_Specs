-- Script: 0036_fix_compras_y_motor_colas.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-08-04
-- Justificación: Fix de prorrateo para upgrades (evitando pérdida de valor de addons), habilitar compras mixtas Plan+Addon simultáneas y crear motor de colas.

BEGIN;

-- 1. Añadir campos a la cola de licencias
ALTER TABLE public."LicenciasCola" 
ADD COLUMN IF NOT EXISTS "ExtraUsuarios" INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS "ExtraDispositivos" INT DEFAULT 0;

-- 2. Previsualizar Compra (Actualizado para considerar extras)
CREATE OR REPLACE FUNCTION public.previsualizar_compra_licencia(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_factor_unidad_entera INT DEFAULT 100,
  p_extra_usuarios INT DEFAULT 0,
  p_extra_dispositivos INT DEFAULT 0
) RETURNS TABLE (
  id_licencia SMALLINT,
  precio_lista_en_unidad_minima BIGINT,
  credito_actual_en_unidad_minima BIGINT,
  credito_generado_en_unidad_minima BIGINT,
  credito_aplicable_en_unidad_minima BIGINT,
  monto_final_en_unidad_minima BIGINT,
  requiere_pasarela BOOLEAN,
  codigo_moneda CHAR(3)
) AS $$
DECLARE
  v_precio_base BIGINT;
  v_precio_extra_usr INT;
  v_precio_extra_disp INT;
  v_precio_total BIGINT;
  v_moneda CHAR(3);
  v_duracion_dias_destino INT;
  v_cred_actual BIGINT;
  v_activa RECORD;
  v_dias_restantes NUMERIC;
  v_credito_generado BIGINT := 0;
  v_valor_activa_total BIGINT;
BEGIN
  PERFORM public.ensure_credito_contratante(p_id_contratante);

  SELECT "PrecioCentimos", "Moneda", "PrecioExtraUsuarioCentimos", "PrecioExtraDispositivoCentimos", "DuracionDias"
    INTO v_precio_base, v_moneda, v_precio_extra_usr, v_precio_extra_disp, v_duracion_dias_destino
    FROM public."Licencias"
   WHERE "IdLicencia" = p_id_licencia
     AND "Activo" = TRUE;

  IF v_precio_base IS NULL THEN
    RAISE EXCEPTION 'Licencia destino no encontrada o inactiva.';
  END IF;

  v_precio_total := v_precio_base + 
                    (COALESCE(v_precio_extra_usr, 0) * p_extra_usuarios) + 
                    (COALESCE(v_precio_extra_disp, 0) * p_extra_dispositivos);

  SELECT c."CreditoDisponibleEnUnidadMinima"
    INTO v_cred_actual
    FROM public."CreditoXContratante" c
   WHERE c."IdContratante" = p_id_contratante;

  IF p_aplicar_ahora THEN
    SELECT lxc."IdLicencia", lxc."FechaExpiracion", l."PrecioCentimos", l."DuracionDias", l."Moneda",
           l."PrecioExtraUsuarioCentimos", l."PrecioExtraDispositivoCentimos",
           lxc."ExtraUsuarios", lxc."ExtraDispositivos"
      INTO v_activa
      FROM public."LicenciasXContratante" lxc
      JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
     WHERE lxc."IdContratante" = p_id_contratante
       AND lxc."Activo" = TRUE
     LIMIT 1;

    -- Generar crédito si cambia de plan o cambian sus extras
    IF FOUND AND (v_activa."IdLicencia" <> p_id_licencia OR COALESCE(v_activa."ExtraUsuarios",0) <> p_extra_usuarios OR COALESCE(v_activa."ExtraDispositivos",0) <> p_extra_dispositivos) THEN
      IF v_activa."Moneda" <> v_moneda THEN
        RAISE EXCEPTION 'No se permite mezclar monedas en una misma operacion.';
      END IF;

      v_dias_restantes := GREATEST(0, EXTRACT(EPOCH FROM (v_activa."FechaExpiracion" - NOW())) / 86400.0);
      
      v_valor_activa_total := COALESCE(v_activa."PrecioCentimos", 0) + 
                              (COALESCE(v_activa."PrecioExtraUsuarioCentimos", 0) * COALESCE(v_activa."ExtraUsuarios", 0)) +
                              (COALESCE(v_activa."PrecioExtraDispositivoCentimos", 0) * COALESCE(v_activa."ExtraDispositivos", 0));
                              
      IF v_valor_activa_total > 0 THEN
        v_credito_generado := CEIL(((v_dias_restantes * (v_valor_activa_total::NUMERIC / NULLIF(v_activa."DuracionDias", 0))) / p_factor_unidad_entera))::BIGINT * p_factor_unidad_entera;
      END IF;
    END IF;
  END IF;

  RETURN QUERY
  SELECT
    p_id_licencia,
    v_precio_total,
    COALESCE(v_cred_actual, 0),
    COALESCE(v_credito_generado, 0),
    LEAST(v_precio_total, COALESCE(v_cred_actual, 0) + COALESCE(v_credito_generado, 0)),
    GREATEST(0, v_precio_total - LEAST(v_precio_total, COALESCE(v_cred_actual, 0) + COALESCE(v_credito_generado, 0))),
    (GREATEST(0, v_precio_total - LEAST(v_precio_total, COALESCE(v_cred_actual, 0) + COALESCE(v_credito_generado, 0))) > 0),
    v_moneda;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.previsualizar_compra_licencia(UUID, SMALLINT, BOOLEAN, INT, INT, INT) TO authenticated;

-- 3. Ejecutar Compra Licencia Multiple (Actualizado para guardar extras)
DROP FUNCTION IF EXISTS public.ejecutar_compra_licencia_multiple(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT, INT);

CREATE OR REPLACE FUNCTION public.ejecutar_compra_licencia_multiple(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_clave_idempotencia VARCHAR(120),
  p_monto_cobrado_en_unidad_minima BIGINT DEFAULT 0,
  p_codigo_moneda CHAR(3) DEFAULT 'PEN',
  p_proveedor_pago TEXT DEFAULT NULL,
  p_id_operacion_pago VARCHAR(120) DEFAULT NULL,
  p_origen TEXT DEFAULT 'MIXTO',
  p_factor_unidad_entera INT DEFAULT 100,
  p_cantidad INT DEFAULT 1,
  p_extra_usuarios INT DEFAULT 0,
  p_extra_dispositivos INT DEFAULT 0
) RETURNS TABLE (
  id_transaccion_licencia BIGINT,
  monto_final_en_unidad_minima BIGINT,
  credito_aplicado_en_unidad_minima BIGINT,
  licencia_en_cola BOOLEAN,
  id_licencia_contratante INT,
  id_licencia_cola BIGINT
) AS $$
DECLARE
  v_prev RECORD;
  v_credito_total BIGINT;
  v_costo_unitario BIGINT;
  v_costo_total BIGINT;
  v_credito_aplicado BIGINT;
  v_monto_final BIGINT;
  v_lic_activa RECORD;
  v_duracion INT;
  v_id_lic_contratante INT := NULL;
  v_id_lic_cola BIGINT := NULL;
  v_tx_lic BIGINT;
  v_nueva_exp TIMESTAMPTZ;
  v_canal TEXT;
  v_credito_row RECORD;
  v_dias_restantes_trial NUMERIC;
  v_id_lic_origen SMALLINT := NULL;
  i INT;
BEGIN
  IF p_clave_idempotencia IS NULL OR LENGTH(TRIM(p_clave_idempotencia)) < 8 THEN
    RAISE EXCEPTION 'Clave idempotencia invalida.';
  END IF;

  IF p_cantidad IS NULL OR p_cantidad < 1 THEN
    RAISE EXCEPTION 'Cantidad de licencias invalida.';
  END IF;

  -- 1. Control de Idempotencia Global
  SELECT tx."IdTransaccionLicencia", tx."MontoFinalEnUnidadMinima", tx."CreditoAplicadoEnUnidadMinima", tx."IdLicenciaContratanteRef", tx."IdLicenciaColaRef"
    INTO v_tx_lic, v_monto_final, v_credito_aplicado, v_id_lic_contratante, v_id_lic_cola
    FROM public."TransaccionesXLicencia" tx
   WHERE tx."IdContratante" = p_id_contratante
     AND tx."ClaveIdempotencia" = p_clave_idempotencia
   LIMIT 1;

  IF FOUND THEN
    RETURN QUERY
    SELECT v_tx_lic, v_monto_final, v_credito_aplicado, (v_id_lic_cola IS NOT NULL), v_id_lic_contratante, v_id_lic_cola;
    RETURN;
  END IF;

  -- 2. Asegurar credito y bloqueo pesimista
  PERFORM public.ensure_credito_contratante(p_id_contratante, p_codigo_moneda);

  SELECT * INTO v_credito_row
    FROM public."CreditoXContratante"
   WHERE "IdContratante" = p_id_contratante
   FOR UPDATE;

  IF v_credito_row."CodigoMoneda" <> p_codigo_moneda THEN
    RAISE EXCEPTION 'Moneda de operacion no coincide con moneda de credito del contratante.';
  END IF;

  -- 3. Calcular montos llamando a la version actualizada de previsualizar
  SELECT * INTO v_prev
    FROM public.previsualizar_compra_licencia(
      p_id_contratante,
      p_id_licencia,
      p_aplicar_ahora,
      p_factor_unidad_entera,
      p_extra_usuarios,
      p_extra_dispositivos
    );

  v_costo_unitario := v_prev.precio_lista_en_unidad_minima;
  v_costo_total := v_costo_unitario * p_cantidad;
  
  v_credito_total := v_prev.credito_actual_en_unidad_minima + v_prev.credito_generado_en_unidad_minima;
  v_credito_aplicado := LEAST(v_costo_total, v_credito_total);
  v_monto_final := GREATEST(0, v_costo_total - v_credito_aplicado);

  IF p_monto_cobrado_en_unidad_minima < v_monto_final THEN
    RAISE EXCEPTION 'Monto cobrado insuficiente. Esperado %, recibido %.', v_monto_final, p_monto_cobrado_en_unidad_minima;
  END IF;

  -- 4. Modificar saldos de credito del contratante
  IF v_prev.credito_generado_en_unidad_minima > 0 THEN
    UPDATE public."CreditoXContratante"
       SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + v_prev.credito_generado_en_unidad_minima,
           "UpdatedAt" = NOW()
     WHERE "IdContratante" = p_id_contratante;

    PERFORM public.registrar_tx_credito(
      p_id_contratante,
      'ABONO',
      'CONVERSION_LICENCIA_REMANENTE',
      v_prev.credito_generado_en_unidad_minima,
      p_codigo_moneda,
      NULL,
      p_id_operacion_pago,
      p_clave_idempotencia || '-ABONO',
      jsonb_build_object('id_licencia_destino', p_id_licencia, 'cantidad', p_cantidad)
    );
  END IF;

  IF v_credito_aplicado > 0 THEN
    UPDATE public."CreditoXContratante"
       SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" - v_credito_aplicado,
           "UpdatedAt" = NOW()
     WHERE "IdContratante" = p_id_contratante;

    PERFORM public.registrar_tx_credito(
      p_id_contratante,
      'CARGO',
      'COMPRA_LICENCIA',
      v_credito_aplicado,
      p_codigo_moneda,
      NULL,
      p_id_operacion_pago,
      p_clave_idempotencia || '-CARGO',
      jsonb_build_object('id_licencia_destino', p_id_licencia, 'cantidad', p_cantidad)
    );
  END IF;

  -- 5. Insertar las licencias en bucle
  SELECT "DuracionDias" INTO v_duracion
    FROM public."Licencias"
   WHERE "IdLicencia" = p_id_licencia;

  FOR i IN 1..p_cantidad LOOP
    IF i = 1 AND p_aplicar_ahora THEN
      SELECT lxc."IdLicenciaContratante", lxc."IdLicencia", l."PrecioCentimos", lxc."FechaExpiracion"
        INTO v_lic_activa
        FROM public."LicenciasXContratante" lxc
        JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
       WHERE lxc."IdContratante" = p_id_contratante
         AND lxc."Activo" = TRUE
       LIMIT 1;

      IF FOUND THEN
        v_id_lic_origen := v_lic_activa."IdLicencia";
        
        UPDATE public."LicenciasXContratante"
           SET "Activo" = FALSE
         WHERE "IdLicenciaContratante" = v_lic_activa."IdLicenciaContratante";
         
        IF v_lic_activa."IdLicencia" <> p_id_licencia AND COALESCE(v_lic_activa."PrecioCentimos", 0) = 0 THEN
           v_dias_restantes_trial := GREATEST(0, EXTRACT(EPOCH FROM (v_lic_activa."FechaExpiracion" - NOW())) / 86400.0);
           v_duracion := v_duracion + CEIL(v_dias_restantes_trial)::INT;
        END IF;
      END IF;

      v_nueva_exp := NOW() + (v_duracion || ' days')::INTERVAL;

      INSERT INTO public."LicenciasXContratante" (
        "IdContratante",
        "IdLicencia",
        "NumeroOrden",
        "FechaInicio",
        "FechaExpiracion",
        "Activo",
        "ExtraUsuarios",
        "ExtraDispositivos"
      ) VALUES (
        p_id_contratante,
        p_id_licencia,
        COALESCE(p_id_operacion_pago, 'CREDITO-' || EXTRACT(EPOCH FROM NOW())::BIGINT),
        NOW(),
        v_nueva_exp,
        TRUE,
        p_extra_usuarios,
        p_extra_dispositivos
      ) RETURNING "IdLicenciaContratante" INTO v_id_lic_contratante;
    
    ELSE
      INSERT INTO public."LicenciasCola" (
        "IdContratante",
        "IdLicencia",
        "Prioridad",
        "Estado",
        "FechaProgramadaInicio",
        "Origen",
        "CostoListaEnUnidadMinima",
        "CreditoAplicadoEnUnidadMinima",
        "CostoFinalCobradoEnUnidadMinima",
        "CodigoMoneda",
        "ExtraUsuarios",
        "ExtraDispositivos"
      ) VALUES (
        p_id_contratante,
        p_id_licencia,
        9999, 
        'PROGRAMADA',
        NOW(),
        CASE
          WHEN v_monto_final = 0 THEN 'CANJE_CREDITO'
          WHEN v_credito_aplicado > 0 THEN 'MIXTO'
          ELSE 'PAGO_PASARELA'
        END,
        v_costo_unitario,
        CASE WHEN i = p_cantidad THEN v_credito_aplicado - (v_credito_aplicado / p_cantidad) * (p_cantidad - 1) ELSE v_credito_aplicado / p_cantidad END,
        CASE WHEN i = p_cantidad THEN v_monto_final - (v_monto_final / p_cantidad) * (p_cantidad - 1) ELSE v_monto_final / p_cantidad END,
        p_codigo_moneda,
        p_extra_usuarios,
        p_extra_dispositivos
      ) RETURNING "IdLicenciaCola" INTO v_id_lic_cola;
    END IF;
  END LOOP;

  PERFORM public.resecuenciar_prioridades(p_id_contratante);

  -- 6. Insertar registro global de Transaccion de Licencia
  v_canal := CASE
    WHEN v_monto_final = 0 THEN 'CREDITO'
    WHEN v_credito_aplicado > 0 THEN 'MIXTO'
    ELSE 'PASARELA'
  END;

  INSERT INTO public."TransaccionesXLicencia" (
    "IdContratante",
    "TipoOperacion",
    "CanalOperacion",
    "IdLicenciaOrigen",
    "IdLicenciaDestino",
    "IdLicenciaContratanteRef",
    "IdLicenciaColaRef",
    "PrecioListaEnUnidadMinima",
    "CreditoAplicadoEnUnidadMinima",
    "MontoCobradoEnUnidadMinima",
    "MontoFinalEnUnidadMinima",
    "CodigoMoneda",
    "ProveedorPago",
    "IdOperacionPago",
    "ComprobanteTipo",
    "ComprobanteEmitido",
    "EstadoOperacion",
    "ClaveIdempotencia",
    "Metadata"
  ) VALUES (
    p_id_contratante,
    CASE WHEN p_aplicar_ahora THEN 'COMPRA_APLICADA' ELSE 'COMPRA_PROGRAMADA' END,
    v_canal,
    v_id_lic_origen,
    p_id_licencia,
    v_id_lic_contratante,
    v_id_lic_cola,
    v_costo_total,
    v_credito_aplicado,
    p_monto_cobrado_en_unidad_minima,
    v_monto_final,
    p_codigo_moneda,
    p_proveedor_pago,
    p_id_operacion_pago,
    CASE WHEN v_monto_final = 0 THEN 'INTERNO_CREDITO' ELSE 'BOLETA' END,
    CASE WHEN v_monto_final = 0 THEN FALSE ELSE TRUE END,
    'OK',
    p_clave_idempotencia,
    jsonb_build_object('origen', p_origen, 'aplicar_ahora', p_aplicar_ahora, 'cantidad', p_cantidad, 'dias_trial_sumados', COALESCE(v_dias_restantes_trial, 0), 'extra_usuarios', p_extra_usuarios, 'extra_dispositivos', p_extra_dispositivos)
  ) RETURNING "IdTransaccionLicencia" INTO v_tx_lic;

  RETURN QUERY
  SELECT v_tx_lic, v_monto_final, v_credito_aplicado, (v_id_lic_cola IS NOT NULL), v_id_lic_contratante, v_id_lic_cola;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.ejecutar_compra_licencia_multiple(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT, INT, INT, INT) TO authenticated;

-- 4. Alias simple ejecutar_compra_licencia
DROP FUNCTION IF EXISTS public.ejecutar_compra_licencia(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT);

CREATE OR REPLACE FUNCTION public.ejecutar_compra_licencia(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_clave_idempotencia VARCHAR(120),
  p_monto_cobrado_en_unidad_minima BIGINT DEFAULT 0,
  p_codigo_moneda CHAR(3) DEFAULT 'PEN',
  p_proveedor_pago TEXT DEFAULT NULL,
  p_id_operacion_pago VARCHAR(120) DEFAULT NULL,
  p_origen TEXT DEFAULT 'MIXTO',
  p_factor_unidad_entera INT DEFAULT 100,
  p_extra_usuarios INT DEFAULT 0,
  p_extra_dispositivos INT DEFAULT 0
) RETURNS TABLE (
  id_transaccion_licencia BIGINT,
  monto_final_en_unidad_minima BIGINT,
  credito_aplicado_en_unidad_minima BIGINT,
  licencia_en_cola BOOLEAN,
  id_licencia_contratante INT,
  id_licencia_cola BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM public.ejecutar_compra_licencia_multiple(
    p_id_contratante,
    p_id_licencia,
    p_aplicar_ahora,
    p_clave_idempotencia,
    p_monto_cobrado_en_unidad_minima,
    p_codigo_moneda,
    p_proveedor_pago,
    p_id_operacion_pago,
    p_origen,
    p_factor_unidad_entera,
    1, -- cantidad = 1
    p_extra_usuarios,
    p_extra_dispositivos
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.ejecutar_compra_licencia(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT, INT, INT) TO authenticated;


-- 5. Motor de Colas de Licencias
CREATE OR REPLACE FUNCTION public.procesar_licencias_cola()
RETURNS VOID AS $$
DECLARE
  v_contratante RECORD;
  v_lic_cola RECORD;
  v_duracion INT;
  v_nueva_exp TIMESTAMPTZ;
BEGIN
  -- 5.1 Desactivar licencias expiradas
  UPDATE public."LicenciasXContratante"
     SET "Activo" = FALSE
   WHERE "Activo" = TRUE
     AND "FechaExpiracion" <= NOW();

  -- 5.2 Buscar contratantes que NO tengan una licencia activa y tengan licencias programadas
  FOR v_contratante IN 
    SELECT DISTINCT lc."IdContratante"
      FROM public."LicenciasCola" lc
     WHERE lc."Estado" = 'PROGRAMADA'
       AND NOT EXISTS (
           SELECT 1 
             FROM public."LicenciasXContratante" lxc
            WHERE lxc."IdContratante" = lc."IdContratante"
              AND lxc."Activo" = TRUE
              AND lxc."FechaExpiracion" > NOW()
       )
  LOOP
    -- 5.3 Tomar la licencia en cola con mayor prioridad (Prioridad mas baja)
    SELECT * INTO v_lic_cola
      FROM public."LicenciasCola"
     WHERE "IdContratante" = v_contratante."IdContratante"
       AND "Estado" = 'PROGRAMADA'
     ORDER BY "Prioridad" ASC
     LIMIT 1
     FOR UPDATE;

    IF FOUND THEN
      -- Obtener duracion del plan
      SELECT "DuracionDias" INTO v_duracion
        FROM public."Licencias"
       WHERE "IdLicencia" = v_lic_cola."IdLicencia";

      v_nueva_exp := NOW() + (v_duracion || ' days')::INTERVAL;

      -- Insertar en licencias activas
      INSERT INTO public."LicenciasXContratante" (
        "IdContratante",
        "IdLicencia",
        "NumeroOrden",
        "FechaInicio",
        "FechaExpiracion",
        "Activo",
        "ExtraUsuarios",
        "ExtraDispositivos"
      ) VALUES (
        v_lic_cola."IdContratante",
        v_lic_cola."IdLicencia",
        'COLA-' || v_lic_cola."IdLicenciaCola", 
        NOW(),
        v_nueva_exp,
        TRUE,
        COALESCE(v_lic_cola."ExtraUsuarios", 0),
        COALESCE(v_lic_cola."ExtraDispositivos", 0)
      );

      -- Marcar como completada en la cola
      UPDATE public."LicenciasCola"
         SET "Estado" = 'COMPLETADA',
             "UpdatedAt" = NOW()
       WHERE "IdLicenciaCola" = v_lic_cola."IdLicenciaCola";
       
      -- Resecuenciar la cola restante
      PERFORM public.resecuenciar_prioridades(v_contratante."IdContratante");
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Cron Job Diario (pg_cron)
-- Habilita la extension por si no estuviera
CREATE EXTENSION IF NOT EXISTS pg_cron;
-- Desprograma si ya existe para recrearlo limpio
-- (Removed unschedule)
-- Programa para las 00:01 todos los dias
SELECT cron.schedule('procesar-licencias-cola-diario', '1 0 * * *', 'SELECT public.procesar_licencias_cola()');

COMMIT;
