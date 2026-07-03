-- ==============================================================================
-- Migration: Support Bulk Multi-Month Purchases
-- Author: lead-architect
-- Description: Creates executing function public.ejecutar_compra_licencia_multiple
-- ==============================================================================

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
  p_cantidad INT DEFAULT 1
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

  -- 3. Calcular montos
  SELECT * INTO v_prev
    FROM public.previsualizar_compra_licencia(
      p_id_contratante,
      p_id_licencia,
      p_aplicar_ahora,
      p_factor_unidad_entera
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
        "Activo"
      ) VALUES (
        p_id_contratante,
        p_id_licencia,
        COALESCE(p_id_operacion_pago, 'CREDITO-' || EXTRACT(EPOCH FROM NOW())::BIGINT),
        NOW(),
        v_nueva_exp,
        TRUE
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
        "CodigoMoneda"
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
        p_codigo_moneda
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
    jsonb_build_object('origen', p_origen, 'aplicar_ahora', p_aplicar_ahora, 'cantidad', p_cantidad, 'dias_trial_sumados', COALESCE(v_dias_restantes_trial, 0))
  ) RETURNING "IdTransaccionLicencia" INTO v_tx_lic;

  RETURN QUERY
  SELECT v_tx_lic, v_monto_final, v_credito_aplicado, (v_id_lic_cola IS NOT NULL), v_id_lic_contratante, v_id_lic_cola;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.ejecutar_compra_licencia_multiple(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT, INT) TO authenticated;
