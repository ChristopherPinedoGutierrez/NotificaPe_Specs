-- ==============================================================================
-- 30_business_rules_creditos_licencias.sql
-- Implementación de reglas de negocio finales para licencias y créditos
-- ==============================================================================

BEGIN;

-- ==============================================================================
-- 1. FUNCION: RESECUENCIAR PRIORIDADES
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.resecuenciar_prioridades(p_id_contratante UUID)
RETURNS VOID AS $$
DECLARE
  v_item RECORD;
  v_nueva_prio INT := 1;
BEGIN
  FOR v_item IN 
    SELECT "IdLicenciaCola"
      FROM public."LicenciasCola"
     WHERE "IdContratante" = p_id_contratante
       AND "Estado" = 'PROGRAMADA'
     ORDER BY "Prioridad" ASC
  LOOP
    UPDATE public."LicenciasCola"
       SET "Prioridad" = v_nueva_prio
     WHERE "IdLicenciaCola" = v_item."IdLicenciaCola";
    v_nueva_prio := v_nueva_prio + 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 2. RENOMBRAR Y ARREGLAR PREVISUALIZAR
-- ==============================================================================
DROP FUNCTION IF EXISTS public.previsualizar_compra_licencia_con_credito(UUID, SMALLINT, BOOLEAN, INT);

CREATE OR REPLACE FUNCTION public.previsualizar_compra_licencia(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_factor_unidad_entera INT DEFAULT 100
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
  v_precio BIGINT;
  v_moneda CHAR(3);
  v_cred_actual BIGINT;
  v_activa RECORD;
  v_dias_restantes NUMERIC;
  v_credito_generado BIGINT := 0;
BEGIN
  PERFORM public.ensure_credito_contratante(p_id_contratante);

  SELECT "PrecioCentimos", "Moneda"
    INTO v_precio, v_moneda
    FROM public."Licencias"
   WHERE "IdLicencia" = p_id_licencia
     AND "Activo" = TRUE;

  IF v_precio IS NULL THEN
    RAISE EXCEPTION 'Licencia destino no encontrada o inactiva.';
  END IF;

  SELECT c."CreditoDisponibleEnUnidadMinima"
    INTO v_cred_actual
    FROM public."CreditoXContratante" c
   WHERE c."IdContratante" = p_id_contratante;

  IF p_aplicar_ahora THEN
    SELECT lxc."IdLicencia", lxc."FechaExpiracion", l."PrecioCentimos", l."DuracionDias", l."Moneda"
      INTO v_activa
      FROM public."LicenciasXContratante" lxc
      JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
     WHERE lxc."IdContratante" = p_id_contratante
       AND lxc."Activo" = TRUE
     LIMIT 1;

    IF FOUND AND v_activa."IdLicencia" <> p_id_licencia THEN
      IF v_activa."Moneda" <> v_moneda THEN
        RAISE EXCEPTION 'No se permite mezclar monedas en una misma operacion.';
      END IF;

      v_dias_restantes := GREATEST(0, EXTRACT(EPOCH FROM (v_activa."FechaExpiracion" - NOW())) / 86400.0);
      
      -- Si el plan activo costaba > 0, genera credito. Si es 0 (Trial), no genera credito.
      IF COALESCE(v_activa."PrecioCentimos", 0) > 0 THEN
        v_credito_generado := CEIL(((v_dias_restantes * (v_activa."PrecioCentimos"::NUMERIC / NULLIF(v_activa."DuracionDias", 0))) / p_factor_unidad_entera))::BIGINT * p_factor_unidad_entera;
      END IF;
    END IF;
  END IF;

  RETURN QUERY
  SELECT
    p_id_licencia,
    v_precio,
    COALESCE(v_cred_actual, 0),
    COALESCE(v_credito_generado, 0),
    LEAST(v_precio, COALESCE(v_cred_actual, 0) + COALESCE(v_credito_generado, 0)),
    GREATEST(0, v_precio - LEAST(v_precio, COALESCE(v_cred_actual, 0) + COALESCE(v_credito_generado, 0))),
    (GREATEST(0, v_precio - LEAST(v_precio, COALESCE(v_cred_actual, 0) + COALESCE(v_credito_generado, 0))) > 0),
    v_moneda;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;


-- ==============================================================================
-- 2. RENOMBRAR Y ARREGLAR EJECUTAR COMPRA (TRIAL SUMA DIAS)
-- ==============================================================================
DROP FUNCTION IF EXISTS public.ejecutar_compra_licencia_con_credito(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT);

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
  p_factor_unidad_entera INT DEFAULT 100
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
  v_costo BIGINT;
  v_credito_aplicado BIGINT;
  v_monto_final BIGINT;
  v_lic_activa RECORD;
  v_duracion INT;
  v_id_lic_contratante INT;
  v_id_lic_cola BIGINT;
  v_tx_lic BIGINT;
  v_nueva_exp TIMESTAMPTZ;
  v_nueva_prioridad INT;
  v_canal TEXT;
  v_credito_row RECORD;
  v_dias_restantes_trial NUMERIC;
  v_id_lic_origen SMALLINT := NULL;
BEGIN
  IF p_clave_idempotencia IS NULL OR LENGTH(TRIM(p_clave_idempotencia)) < 8 THEN
    RAISE EXCEPTION 'Clave idempotencia invalida.';
  END IF;

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

  PERFORM public.ensure_credito_contratante(p_id_contratante, p_codigo_moneda);

  SELECT * INTO v_credito_row
    FROM public."CreditoXContratante"
   WHERE "IdContratante" = p_id_contratante
   FOR UPDATE;

  IF v_credito_row."CodigoMoneda" <> p_codigo_moneda THEN
    RAISE EXCEPTION 'Moneda de operacion no coincide con moneda de credito del contratante.';
  END IF;

  SELECT * INTO v_prev
    FROM public.previsualizar_compra_licencia(
      p_id_contratante,
      p_id_licencia,
      p_aplicar_ahora,
      p_factor_unidad_entera
    );

  v_costo := v_prev.precio_lista_en_unidad_minima;
  v_credito_total := v_prev.credito_actual_en_unidad_minima + v_prev.credito_generado_en_unidad_minima;
  v_credito_aplicado := LEAST(v_costo, v_credito_total);
  v_monto_final := GREATEST(0, v_costo - v_credito_aplicado);

  IF p_monto_cobrado_en_unidad_minima < v_monto_final THEN
    RAISE EXCEPTION 'Monto cobrado insuficiente. Esperado %, recibido %.', v_monto_final, p_monto_cobrado_en_unidad_minima;
  END IF;

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
      jsonb_build_object('id_licencia_destino', p_id_licencia)
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
      jsonb_build_object('id_licencia_destino', p_id_licencia)
    );
  END IF;

  SELECT "DuracionDias" INTO v_duracion
    FROM public."Licencias"
   WHERE "IdLicencia" = p_id_licencia;

  IF p_aplicar_ahora THEN
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
       
      -- LOGICA DE PRUEBA (TRIAL): Si el plan activo costaba 0, sumar los dias de prueba restantes
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
      9999, -- Se asignará al final por el resecuenciador
      'PROGRAMADA',
      NOW(),
      CASE
        WHEN v_monto_final = 0 THEN 'CANJE_CREDITO'
        WHEN v_credito_aplicado > 0 THEN 'MIXTO'
        ELSE 'PAGO_PASARELA'
      END,
      v_costo,
      v_credito_aplicado,
      v_monto_final,
      p_codigo_moneda
    ) RETURNING "IdLicenciaCola" INTO v_id_lic_cola;
    
    PERFORM public.resecuenciar_prioridades(p_id_contratante);
  END IF;

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
    v_costo,
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
    jsonb_build_object('origen', p_origen, 'aplicar_ahora', p_aplicar_ahora, 'dias_trial_sumados', COALESCE(v_dias_restantes_trial, 0))
  ) RETURNING "IdTransaccionLicencia" INTO v_tx_lic;

  RETURN QUERY
  SELECT v_tx_lic, v_monto_final, v_credito_aplicado, (v_id_lic_cola IS NOT NULL), v_id_lic_contratante, v_id_lic_cola;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 3. ARREGLAR CANCELAR LICENCIA (DEVUELVE 100% SIEMPRE)
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.cancelar_licencia_programada(
  p_id_contratante UUID,
  p_id_licencia_cola BIGINT,
  p_clave_idempotencia VARCHAR(120)
) RETURNS BOOLEAN AS $$
DECLARE
  v_item RECORD;
BEGIN
  PERFORM public.ensure_credito_contratante(p_id_contratante);

  SELECT * INTO v_item
    FROM public."LicenciasCola"
   WHERE "IdLicenciaCola" = p_id_licencia_cola
     AND "IdContratante" = p_id_contratante
     AND "Estado" = 'PROGRAMADA'
   FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No existe licencia programada para cancelar.';
  END IF;

  UPDATE public."LicenciasCola"
     SET "Estado" = 'CANCELADA',
         "UpdatedAt" = NOW()
   WHERE "IdLicenciaCola" = p_id_licencia_cola;
         
  PERFORM public.resecuenciar_prioridades(p_id_contratante);

  -- SIEMPRE devolucion 1:1 del costo lista, sin importar como pago
  UPDATE public."CreditoXContratante"
     SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + v_item."CostoListaEnUnidadMinima",
         "UpdatedAt" = NOW()
   WHERE "IdContratante" = p_id_contratante;

  PERFORM public.registrar_tx_credito(
    p_id_contratante,
    'ABONO',
    'CANCELACION_COLA',
    v_item."CostoListaEnUnidadMinima",
    v_item."CodigoMoneda",
    NULL,
    p_id_licencia_cola::text,
    p_clave_idempotencia,
    jsonb_build_object('id_licencia_cola', p_id_licencia_cola)
  );

  INSERT INTO public."TransaccionesXLicencia" (
    "IdContratante",
    "TipoOperacion",
    "CanalOperacion",
    "IdLicenciaDestino",
    "IdLicenciaColaRef",
    "PrecioListaEnUnidadMinima",
    "CreditoAplicadoEnUnidadMinima",
    "MontoCobradoEnUnidadMinima",
    "MontoFinalEnUnidadMinima",
    "CodigoMoneda",
    "ComprobanteTipo",
    "ComprobanteEmitido",
    "EstadoOperacion",
    "ClaveIdempotencia",
    "Metadata"
  ) VALUES (
    p_id_contratante,
    'CANCELACION_COLA',
    'CREDITO',
    v_item."IdLicencia",
    v_item."IdLicenciaCola",
    v_item."CostoListaEnUnidadMinima",
    0,
    0,
    0,
    v_item."CodigoMoneda",
    'INTERNO_CREDITO',
    FALSE,
    'OK',
    p_clave_idempotencia,
    jsonb_build_object('id_licencia_cola', p_id_licencia_cola)
  );

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 4. NUEVA FUNCION: REORDENAR COLA
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.reordenar_licencia_cola(
  p_id_contratante UUID,
  p_id_licencia_cola BIGINT,
  p_direccion TEXT -- 'UP' o 'DOWN'
) RETURNS BOOLEAN AS $$
DECLARE
  v_item_actual RECORD;
  v_item_swap RECORD;
BEGIN
  -- Bloquear la tabla para reorden seguro
  LOCK TABLE public."LicenciasCola" IN ROW EXCLUSIVE MODE;

  SELECT * INTO v_item_actual
    FROM public."LicenciasCola"
   WHERE "IdLicenciaCola" = p_id_licencia_cola
     AND "IdContratante" = p_id_contratante
     AND "Estado" = 'PROGRAMADA';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Item no encontrado en la cola programada.';
  END IF;

  IF p_direccion = 'UP' THEN
    -- Encontrar el item inmediatamente superior (menor prioridad numero)
    SELECT * INTO v_item_swap
      FROM public."LicenciasCola"
     WHERE "IdContratante" = p_id_contratante
       AND "Estado" = 'PROGRAMADA'
       AND "Prioridad" < v_item_actual."Prioridad"
     ORDER BY "Prioridad" DESC
     LIMIT 1;
  ELSIF p_direccion = 'DOWN' THEN
    -- Encontrar el item inmediatamente inferior (mayor prioridad numero)
    SELECT * INTO v_item_swap
      FROM public."LicenciasCola"
     WHERE "IdContratante" = p_id_contratante
       AND "Estado" = 'PROGRAMADA'
       AND "Prioridad" > v_item_actual."Prioridad"
     ORDER BY "Prioridad" ASC
     LIMIT 1;
  ELSE
    RAISE EXCEPTION 'Direccion invalida. Use UP o DOWN.';
  END IF;

  IF v_item_swap IS NOT NULL THEN
    UPDATE public."LicenciasCola" SET "Prioridad" = v_item_swap."Prioridad" WHERE "IdLicenciaCola" = v_item_actual."IdLicenciaCola";
    UPDATE public."LicenciasCola" SET "Prioridad" = v_item_actual."Prioridad" WHERE "IdLicenciaCola" = v_item_swap."IdLicenciaCola";
    
    PERFORM public.resecuenciar_prioridades(p_id_contratante);
  END IF;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 6. PERMISOS
-- ==============================================================================
GRANT EXECUTE ON FUNCTION public.previsualizar_compra_licencia(UUID, SMALLINT, BOOLEAN, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.ejecutar_compra_licencia(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.reordenar_licencia_cola(UUID, BIGINT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.resecuenciar_prioridades(UUID) TO authenticated;

COMMIT;
