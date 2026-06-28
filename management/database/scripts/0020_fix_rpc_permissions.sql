-- ==============================================================================
-- CORRECCIÓN: Permisos + fix STABLE→VOLATILE en previsualizar_compra_licencia
-- Archivo: 27_fix_rpc_permissions.sql
-- Idempotente: seguro ejecutar varias veces.
-- ==============================================================================

BEGIN;

-- ==============================================================================
-- 1. OTORGAR PERMISOS A TABLAS PARA EL ROL POSTGRES
-- ==============================================================================

GRANT ALL ON public."CreditoXContratante" TO postgres;
GRANT ALL ON public."TransaccionesXCredito" TO postgres;
GRANT ALL ON public."LicenciasCola" TO postgres;
GRANT ALL ON public."TransaccionesXLicencia" TO postgres;
GRANT ALL ON public."LicenciasXContratante" TO postgres;

-- ==============================================================================
-- 2. OTORGAR ACCESO A SEQUENCES
-- ==============================================================================

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO postgres;

-- ==============================================================================
-- 3. FIX FK: LicenciasXContratante.NumeroOrden referenciaba tabla de pedidos
--    del esquema anterior (WooCommerce). Ya no aplica con el sistema de crédito.
--    Eliminamos la FK y dejamos NumeroOrden como texto libre nullable.
-- ==============================================================================

ALTER TABLE public."LicenciasXContratante"
  DROP CONSTRAINT IF EXISTS "LicenciasXContratante_NumeroOrden_fkey";

ALTER TABLE public."LicenciasXContratante"
  ALTER COLUMN "NumeroOrden" DROP NOT NULL;

-- ==============================================================================
-- 4. FIX CRÍTICO: ejecutar_compra_licencia_con_credito accedía a v_lic_activa
--    cuando p_aplicar_ahora = FALSE (programar en cola), pero el RECORD nunca
--    fue cargado en ese branch → "record is not assigned yet".
--    Solución: usar CASE WHEN p_aplicar_ahora para acceder al campo de forma segura.
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.ejecutar_compra_licencia_con_credito(
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
    FROM public.previsualizar_compra_licencia_con_credito(
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

    IF (SELECT "CreditoDisponibleEnUnidadMinima" FROM public."CreditoXContratante" WHERE "IdContratante" = p_id_contratante) < 0 THEN
      RAISE EXCEPTION 'Operacion invalida: credito resultante negativo.';
    END IF;

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
    SELECT lxc."IdLicenciaContratante", lxc."IdLicencia"
      INTO v_lic_activa
      FROM public."LicenciasXContratante" lxc
     WHERE lxc."IdContratante" = p_id_contratante
       AND lxc."Activo" = TRUE
       AND lxc."FechaExpiracion" > NOW()
     LIMIT 1;

    IF FOUND THEN
      UPDATE public."LicenciasXContratante"
         SET "Activo" = FALSE
       WHERE "IdLicenciaContratante" = v_lic_activa."IdLicenciaContratante";
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
    SELECT COALESCE(MAX("Prioridad"), 0) + 1 INTO v_nueva_prioridad
      FROM public."LicenciasCola"
     WHERE "IdContratante" = p_id_contratante
       AND "Estado" = 'PROGRAMADA';

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
      v_nueva_prioridad,
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
    CASE WHEN p_aplicar_ahora AND v_lic_activa IS NOT NULL THEN v_lic_activa."IdLicencia" ELSE NULL END,
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
    jsonb_build_object('origen', p_origen, 'aplicar_ahora', p_aplicar_ahora)
  ) RETURNING "IdTransaccionLicencia" INTO v_tx_lic;

  RETURN QUERY
  SELECT v_tx_lic, v_monto_final, v_credito_aplicado, (v_id_lic_cola IS NOT NULL), v_id_lic_contratante, v_id_lic_cola;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 5. FIX CRÍTICO: previsualizar_compra_licencia_con_credito era STABLE
--    pero llama a ensure_credito_contratante() que hace INSERT.
--    PostgreSQL prohíbe writes en funciones STABLE → "read-only transaction".
--    Solución: redeclararla como VOLATILE (permite writes).
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.previsualizar_compra_licencia_con_credito(
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
       AND lxc."FechaExpiracion" > NOW()
     LIMIT 1;

    IF FOUND AND v_activa."IdLicencia" <> p_id_licencia THEN
      IF v_activa."Moneda" <> v_moneda THEN
        RAISE EXCEPTION 'No se permite mezclar monedas en una misma operacion.';
      END IF;

      v_dias_restantes := GREATEST(0, EXTRACT(EPOCH FROM (v_activa."FechaExpiracion" - NOW())) / 86400.0);
      v_credito_generado := CEIL(((v_dias_restantes * (v_activa."PrecioCentimos"::NUMERIC / NULLIF(v_activa."DuracionDias", 0))) / p_factor_unidad_entera))::BIGINT * p_factor_unidad_entera;
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
-- 6. OTORGAR PERMISOS A FUNCIONES RPC (idempotente: GRANT no falla si ya existe)
-- ==============================================================================

GRANT EXECUTE ON FUNCTION public.previsualizar_compra_licencia_con_credito(UUID, SMALLINT, BOOLEAN, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.ejecutar_compra_licencia_con_credito(UUID, SMALLINT, BOOLEAN, VARCHAR, BIGINT, CHAR, TEXT, VARCHAR, TEXT, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancelar_licencia_programada(UUID, BIGINT, VARCHAR) TO authenticated;
GRANT EXECUTE ON FUNCTION public.ensure_credito_contratante(UUID, CHAR) TO authenticated;
GRANT EXECUTE ON FUNCTION public.registrar_tx_credito(UUID, TEXT, TEXT, BIGINT, CHAR, BIGINT, VARCHAR, VARCHAR, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION public.activar_licencias_programadas() TO authenticated;

-- ==============================================================================
-- 7. OTORGAR PERMISOS A FUNCIONES AUXILIARES
-- ==============================================================================

GRANT EXECUTE ON FUNCTION public.get_licencia_activa(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_stats_contratante(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.asignar_licencia_contratante(UUID, SMALLINT, VARCHAR) TO authenticated;
GRANT EXECUTE ON FUNCTION public.check_device_limit() TO authenticated;
GRANT EXECUTE ON FUNCTION public.check_user_limit() TO authenticated;

COMMIT;


-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 43_check_phone_availability_rpc.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: FUNCTION)
-- ==========================================================================

-- Función RPC para verificar disponibilidad de teléfono saltando RLS (Versión 3 - Escudo Total)
-- Propósito: Validar disponibilidad ignorando el prefijo +51 para compatibilidad con datos legacy
-- y asegurar la unicidad global absoluta en la tabla DispositivosXContratante.

CREATE OR REPLACE FUNCTION check_phone_availability(target_phone TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    clean_phone TEXT;
BEGIN
    -- 1. Normalización: Obtenemos la versión de 9 dígitos (sin +51) y limpiamos espacios
    clean_phone := TRIM(REPLACE(target_phone, '+51', ''));

    -- 2. Búsqueda: Retorna TRUE si NO existe el teléfono en ninguno de los formatos posibles.
    -- Se elimina la restricción de HardwareId para que incluso registros manuales o
    -- incompletos bloqueen la duplicidad y eviten errores de UNIQUE en el QR.
    RETURN NOT EXISTS (
        SELECT 1
        FROM "DispositivosXContratante"
        WHERE (
            "TelefonoDispositivo" = target_phone
            OR "TelefonoDispositivo" = clean_phone
            OR "TelefonoDispositivo" = ('+51' || clean_phone)
            OR "TelefonoDispositivo" = ('+51 ' || clean_phone)
        )
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Otorgar permisos de ejecución a roles anon (onboarding) y authenticated (ajustes)
GRANT EXECUTE ON FUNCTION check_phone_availability(TEXT) TO anon;
GRANT EXECUTE ON FUNCTION check_phone_availability(TEXT) TO authenticated;

COMMENT ON FUNCTION check_phone_availability(TEXT)
IS 'Verifica disponibilidad absoluta de teléfono comparando formatos con y sin prefijo +51, saltando RLS.';



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 26_check_phone_availability_viewer.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: FUNCTION)
-- ==========================================================================

-- Función RPC para verificar disponibilidad de teléfono en la tabla Usuarios (App Viewer)
-- Propósito: Validar que un teléfono no esté usado por otro vendedor, evitando el auto-bloqueo.

CREATE OR REPLACE FUNCTION check_phone_availability_viewer(target_phone TEXT, requester_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    clean_phone TEXT;
BEGIN
    -- 1. Normalización: Obtenemos la versión de 9 dígitos (sin +51) y limpiamos espacios
    clean_phone := TRIM(REPLACE(target_phone, '+51', ''));

    -- 2. Búsqueda: Retorna TRUE si NO existe el teléfono en otros usuarios.
    -- Excluimos al requester_id para permitir que el mismo usuario valide su propio número sin bloqueos.
    RETURN NOT EXISTS (
        SELECT 1
        FROM "Usuarios"
        WHERE (
            "TelefonoUsuario" = target_phone
            OR "TelefonoUsuario" = clean_phone
            OR "TelefonoUsuario" = ('+51' || clean_phone)
            OR "TelefonoUsuario" = ('+51 ' || clean_phone)
        )
        AND "IdUsuario" != requester_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Otorgar permisos de ejecución a usuarios autenticados (Onboarding)
GRANT EXECUTE ON FUNCTION check_phone_availability_viewer(TEXT, UUID) TO authenticated;

COMMENT ON FUNCTION check_phone_availability_viewer(TEXT, UUID)
IS 'Verifica disponibilidad de teléfono en la tabla Usuarios excluyendo al usuario que consulta para evitar auto-bloqueos.';

