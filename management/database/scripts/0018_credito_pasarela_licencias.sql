-- ==============================================================================
-- MIGRACION: CREDITO + COLA + TRANSACCIONES DE LICENCIAS
-- Archivo: 25_credito_pasarela_licencias.sql
-- Objetivo:
--   - Sustituir prorrateo directo por modelo de credito.
--   - Soportar compras inmediatas o programadas (cola).
--   - Garantizar seguridad transaccional e idempotencia.
-- ==============================================================================

BEGIN;

-- ==============================================================================
-- 1) TABLAS NUEVAS
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public."CreditoXContratante" (
  "IdContratante" UUID PRIMARY KEY REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
  "CreditoDisponibleEnUnidadMinima" BIGINT NOT NULL DEFAULT 0 CHECK ("CreditoDisponibleEnUnidadMinima" >= 0),
  "CodigoMoneda" CHAR(3) NOT NULL DEFAULT 'PEN',
  "UpdatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public."TransaccionesXCredito" (
  "IdTransaccionCredito" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "IdContratante" UUID NOT NULL REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
  "TipoMovimiento" TEXT NOT NULL CHECK ("TipoMovimiento" IN ('ABONO', 'CARGO', 'AJUSTE')),
  "OrigenMovimiento" TEXT NOT NULL,
  "MontoEnUnidadMinima" BIGINT NOT NULL CHECK ("MontoEnUnidadMinima" > 0),
  "CodigoMoneda" CHAR(3) NOT NULL,
  "IdTransaccionLicenciaRef" BIGINT NULL,
  "ReferenciaExterna" VARCHAR(120) NULL,
  "ClaveIdempotencia" VARCHAR(120) NULL,
  "Metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
  "CreatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "idx_tx_credito_contratante_created"
  ON public."TransaccionesXCredito" ("IdContratante", "CreatedAt" DESC);

CREATE UNIQUE INDEX IF NOT EXISTS "idx_tx_credito_idempotencia"
  ON public."TransaccionesXCredito" ("IdContratante", "ClaveIdempotencia")
  WHERE "ClaveIdempotencia" IS NOT NULL;

CREATE TABLE IF NOT EXISTS public."LicenciasCola" (
  "IdLicenciaCola" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "IdContratante" UUID NOT NULL REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
  "IdLicencia" SMALLINT NOT NULL REFERENCES public."Licencias"("IdLicencia"),
  "Prioridad" INT NOT NULL,
  "Estado" TEXT NOT NULL DEFAULT 'PROGRAMADA' CHECK ("Estado" IN ('PROGRAMADA', 'CANCELADA', 'APLICADA')),
  "FechaProgramadaInicio" TIMESTAMPTZ NOT NULL,
  "Origen" TEXT NOT NULL CHECK ("Origen" IN ('PAGO_PASARELA', 'CANJE_CREDITO', 'MIXTO')),
  "CostoListaEnUnidadMinima" BIGINT NOT NULL CHECK ("CostoListaEnUnidadMinima" >= 0),
  "CreditoAplicadoEnUnidadMinima" BIGINT NOT NULL DEFAULT 0 CHECK ("CreditoAplicadoEnUnidadMinima" >= 0),
  "CostoFinalCobradoEnUnidadMinima" BIGINT NOT NULL DEFAULT 0 CHECK ("CostoFinalCobradoEnUnidadMinima" >= 0),
  "CodigoMoneda" CHAR(3) NOT NULL,
  "CreatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  "UpdatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "idx_licencias_cola_estado_fecha"
  ON public."LicenciasCola" ("Estado", "FechaProgramadaInicio");

CREATE INDEX IF NOT EXISTS "idx_licencias_cola_contratante_prioridad"
  ON public."LicenciasCola" ("IdContratante", "Prioridad");

CREATE TABLE IF NOT EXISTS public."TransaccionesXLicencia" (
  "IdTransaccionLicencia" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "IdContratante" UUID NOT NULL REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
  "TipoOperacion" TEXT NOT NULL,
  "CanalOperacion" TEXT NOT NULL CHECK ("CanalOperacion" IN ('PASARELA', 'CREDITO', 'MIXTO')),
  "IdLicenciaOrigen" SMALLINT NULL REFERENCES public."Licencias"("IdLicencia"),
  "IdLicenciaDestino" SMALLINT NULL REFERENCES public."Licencias"("IdLicencia"),
  "IdLicenciaContratanteRef" INT NULL REFERENCES public."LicenciasXContratante"("IdLicenciaContratante"),
  "IdLicenciaColaRef" BIGINT NULL REFERENCES public."LicenciasCola"("IdLicenciaCola"),
  "PrecioListaEnUnidadMinima" BIGINT NOT NULL DEFAULT 0,
  "CreditoAplicadoEnUnidadMinima" BIGINT NOT NULL DEFAULT 0,
  "MontoCobradoEnUnidadMinima" BIGINT NOT NULL DEFAULT 0,
  "MontoFinalEnUnidadMinima" BIGINT NOT NULL DEFAULT 0,
  "CodigoMoneda" CHAR(3) NOT NULL,
  "ProveedorPago" TEXT NULL,
  "IdOperacionPago" VARCHAR(120) NULL,
  "ComprobanteTipo" TEXT NOT NULL DEFAULT 'INTERNO_CREDITO',
  "ComprobanteNumero" VARCHAR(120) NULL,
  "ComprobanteEmitido" BOOLEAN NOT NULL DEFAULT FALSE,
  "EstadoOperacion" TEXT NOT NULL DEFAULT 'OK' CHECK ("EstadoOperacion" IN ('OK', 'ERROR', 'REVERTIDA')),
  "ClaveIdempotencia" VARCHAR(120) NOT NULL,
  "Metadata" JSONB NOT NULL DEFAULT '{}'::jsonb,
  "CreatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS "idx_tx_licencia_idempotencia"
  ON public."TransaccionesXLicencia" ("IdContratante", "ClaveIdempotencia");

CREATE INDEX IF NOT EXISTS "idx_tx_licencia_contratante_created"
  ON public."TransaccionesXLicencia" ("IdContratante", "CreatedAt" DESC);

-- ==============================================================================
-- 2) FUNCIONES AUXILIARES
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.ensure_credito_contratante(
  p_id_contratante UUID,
  p_codigo_moneda CHAR(3) DEFAULT 'PEN'
) RETURNS VOID AS $$
BEGIN
  INSERT INTO public."CreditoXContratante" ("IdContratante", "CreditoDisponibleEnUnidadMinima", "CodigoMoneda")
  VALUES (p_id_contratante, 0, p_codigo_moneda)
  ON CONFLICT ("IdContratante") DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.registrar_tx_credito(
  p_id_contratante UUID,
  p_tipo_movimiento TEXT,
  p_origen TEXT,
  p_monto BIGINT,
  p_codigo_moneda CHAR(3),
  p_id_tx_licencia_ref BIGINT DEFAULT NULL,
  p_referencia_externa VARCHAR(120) DEFAULT NULL,
  p_clave_idempotencia VARCHAR(120) DEFAULT NULL,
  p_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS BIGINT AS $$
DECLARE
  v_id BIGINT;
BEGIN
  IF p_monto <= 0 THEN
    RAISE EXCEPTION 'El monto de credito debe ser mayor a cero.';
  END IF;

  INSERT INTO public."TransaccionesXCredito" (
    "IdContratante",
    "TipoMovimiento",
    "OrigenMovimiento",
    "MontoEnUnidadMinima",
    "CodigoMoneda",
    "IdTransaccionLicenciaRef",
    "ReferenciaExterna",
    "ClaveIdempotencia",
    "Metadata"
  ) VALUES (
    p_id_contratante,
    p_tipo_movimiento,
    p_origen,
    p_monto,
    p_codigo_moneda,
    p_id_tx_licencia_ref,
    p_referencia_externa,
    p_clave_idempotencia,
    COALESCE(p_metadata, '{}'::jsonb)
  )
  RETURNING "IdTransaccionCredito" INTO v_id;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

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

  -- Lock pesimista por contratante para evitar doble gasto concurrente.
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

  IF v_item."CostoFinalCobradoEnUnidadMinima" = 0 THEN
    -- Compra 100% credito: devolucion 1:1 del costo lista.
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
  END IF;

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

CREATE OR REPLACE FUNCTION public.activar_licencias_programadas()
RETURNS INT AS $$
DECLARE
  v_item RECORD;
  v_cont INT := 0;
  v_duracion INT;
BEGIN
  FOR v_item IN
    SELECT lc.*
      FROM public."LicenciasCola" lc
     WHERE lc."Estado" = 'PROGRAMADA'
       AND lc."FechaProgramadaInicio" <= NOW()
     ORDER BY lc."IdContratante", lc."Prioridad"
  LOOP
    -- Solo activamos si no existe licencia vigente activa para ese contratante.
    IF EXISTS (
      SELECT 1
        FROM public."LicenciasXContratante" lxc
       WHERE lxc."IdContratante" = v_item."IdContratante"
         AND lxc."Activo" = TRUE
         AND lxc."FechaExpiracion" > NOW()
    ) THEN
      CONTINUE;
    END IF;

    UPDATE public."LicenciasXContratante"
       SET "Activo" = FALSE
     WHERE "IdContratante" = v_item."IdContratante"
       AND "Activo" = TRUE;

    SELECT "DuracionDias" INTO v_duracion
      FROM public."Licencias"
     WHERE "IdLicencia" = v_item."IdLicencia";

    INSERT INTO public."LicenciasXContratante" (
      "IdContratante",
      "IdLicencia",
      "NumeroOrden",
      "FechaInicio",
      "FechaExpiracion",
      "Activo"
    ) VALUES (
      v_item."IdContratante",
      v_item."IdLicencia",
      'COLA-' || v_item."IdLicenciaCola",
      NOW(),
      NOW() + (v_duracion || ' days')::INTERVAL,
      TRUE
    );

    UPDATE public."LicenciasCola"
       SET "Estado" = 'APLICADA',
           "UpdatedAt" = NOW()
     WHERE "IdLicenciaCola" = v_item."IdLicenciaCola";

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
      v_item."IdContratante",
      'ACTIVACION_COLA',
      CASE WHEN v_item."CostoFinalCobradoEnUnidadMinima" = 0 THEN 'CREDITO' ELSE 'MIXTO' END,
      v_item."IdLicencia",
      v_item."IdLicenciaCola",
      v_item."CostoListaEnUnidadMinima",
      v_item."CreditoAplicadoEnUnidadMinima",
      v_item."CostoFinalCobradoEnUnidadMinima",
      v_item."CostoFinalCobradoEnUnidadMinima",
      v_item."CodigoMoneda",
      'INTERNO_CREDITO',
      FALSE,
      'OK',
      'ACT-COLA-' || v_item."IdLicenciaCola"::text,
      jsonb_build_object('activacion_automatica', TRUE)
    );

    v_cont := v_cont + 1;
  END LOOP;

  RETURN v_cont;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 3) RLS Y PERMISOS
-- ==============================================================================

ALTER TABLE public."CreditoXContratante" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."TransaccionesXCredito" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."LicenciasCola" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."TransaccionesXLicencia" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Contratante read CreditoXContratante" ON public."CreditoXContratante";
CREATE POLICY "Contratante read CreditoXContratante"
  ON public."CreditoXContratante"
  FOR SELECT
  USING (auth.uid() = "IdContratante");

DROP POLICY IF EXISTS "Contratante read TransaccionesXCredito" ON public."TransaccionesXCredito";
CREATE POLICY "Contratante read TransaccionesXCredito"
  ON public."TransaccionesXCredito"
  FOR SELECT
  USING (auth.uid() = "IdContratante");

DROP POLICY IF EXISTS "Contratante read LicenciasCola" ON public."LicenciasCola";
CREATE POLICY "Contratante read LicenciasCola"
  ON public."LicenciasCola"
  FOR SELECT
  USING (auth.uid() = "IdContratante");

DROP POLICY IF EXISTS "Contratante read TransaccionesXLicencia" ON public."TransaccionesXLicencia";
CREATE POLICY "Contratante read TransaccionesXLicencia"
  ON public."TransaccionesXLicencia"
  FOR SELECT
  USING (auth.uid() = "IdContratante");

-- ==============================================================================
-- 4) REALTIME BASICO PARA CREDITO/COLA
-- ==============================================================================

ALTER TABLE public."CreditoXContratante" REPLICA IDENTITY FULL;
ALTER TABLE public."LicenciasCola" REPLICA IDENTITY FULL;
ALTER TABLE public."TransaccionesXLicencia" REPLICA IDENTITY FULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
     WHERE pubname = 'supabase_realtime' AND tablename = 'CreditoXContratante'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public."CreditoXContratante";
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
     WHERE pubname = 'supabase_realtime' AND tablename = 'LicenciasCola'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public."LicenciasCola";
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
     WHERE pubname = 'supabase_realtime' AND tablename = 'TransaccionesXLicencia'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public."TransaccionesXLicencia";
  END IF;
END $$;

COMMIT;


-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 01_cleanup_offline_devices.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: IF)
-- ==========================================================================

-- =================================================================
-- SCRIPT 01: LIMPIEZA AUTOMÁTICA DE DISPOSITIVOS OFFLINE
-- Objetivo: Garantizar que IsConnected sea false si el dispositivo se desconecta bruscamente.
-- =================================================================

-- 1. Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 2. Asegurar que la tabla tenga soporte para rastreo de tiempo
-- Añadimos la columna updated_at si no existe
ALTER TABLE "DispositivosXContratante"
ADD COLUMN IF NOT EXISTS "updated_at" TIMESTAMPTZ DEFAULT now();

-- 3. Crear función para actualizar el timestamp automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updated_at" = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 4. Crear el Trigger para la tabla
-- Esto garantiza que cada vez que la App haga "track" o "sync", el tiempo se actualice.
DROP TRIGGER IF EXISTS update_devices_modtime ON "DispositivosXContratante";
CREATE TRIGGER update_devices_modtime
    BEFORE UPDATE ON "DispositivosXContratante"
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

-- 5. Crear la función de limpieza (Cron Job Logic)
CREATE OR REPLACE FUNCTION cleanup_offline_devices()
RETURNS void AS $$
BEGIN
  -- Marcamos como desconectados a los que no han tenido actividad en 2 minutos
  UPDATE "DispositivosXContratante"
  SET "IsConnected" = false
  WHERE "IsConnected" = true
    AND "updated_at" < (now() - interval '2 minutes');
END;
$$ LANGUAGE plpgsql;

-- 6. Programar la tarea para que corra cada minuto de forma segura
-- Nota: cron.schedule(nombre, ...) en Supabase actualiza la tarea si ya existe.
-- Se eliminó cron.unschedule para evitar el error XX000 en la primera ejecución.
SELECT cron.schedule(
  'cleanup-devices-task',
  '* * * * *',
  'SELECT cleanup_offline_devices()'
);



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> cleanup_devices.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: IF)
-- ==========================================================================

-- ==========================================
-- ESTRATEGIA DE RESILIENCIA: LIMPIEZA AUTOMÁTICA
-- ==========================================

-- 1. Habilitar la extensión de tareas programadas (pg_cron)
-- Esto permite que Supabase ejecute tareas en segundo plano sin intervención externa.
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 2. Crear la función de limpieza
-- Esta lógica detecta dispositivos que "parecen" conectados pero cuya
-- última actividad (updated_at) fue hace más de 2 minutos.
CREATE OR REPLACE FUNCTION cleanup_offline_devices()
RETURNS void AS $$
BEGIN
  UPDATE "DispositivosXContratante"
  SET "IsConnected" = false
  WHERE "IsConnected" = true
    AND "updated_at" < (now() - interval '2 minutes');
END;
$$ LANGUAGE plpgsql;

-- 3. Programar el Cron Job
-- Se ejecuta cada 1 minuto ('* * * * *') para garantizar que el panel
-- web refleje el estado real lo más pronto posible tras una desconexión.
SELECT cron.schedule(
  'cleanup-devices-task', -- Identificador de la tarea
  '* * * * *',           -- Cada minuto
  'SELECT cleanup_offline_devices()'
);

-- NOTA: Para verificar que la tarea está corriendo, puedes ejecutar:
-- SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 10;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 25_notificaciones_disputas_logic.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: IF)
-- ==========================================================================

-- ==========================================================
-- 25_NOTIFICACIONES_DISPUTAS_LOGIC.SQL
-- Lógica para reclamación de notificaciones y gestión de conflictos
-- ==========================================================

-- 1. Tabla de Disputas (Si no existe)
CREATE TABLE IF NOT EXISTS public."DisputasNotificaciones" (
    "IdDisputa" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "IdSync" UUID REFERENCES public."NotificacionesXDispositivo"("IdSync") ON DELETE CASCADE,
    "IdUsuarioReclamante" UUID REFERENCES public."Usuarios"("IdUsuario"),
    "Motivo" TEXT,
    "FechaRegistro" TIMESTAMPTZ DEFAULT NOW(),
    "Estado" VARCHAR(20) DEFAULT 'PENDIENTE', -- PENDIENTE, RESUELTA, RECHAZADA
    "Resolucion" TEXT
);

-- 2. Función Atómica para Reclamar Notificación (RPC)
-- Esta función asegura que dos usuarios no reclamen la misma notif. al mismo tiempo.
CREATE OR REPLACE FUNCTION public.reclamar_notificacion(p_id_sync UUID, p_id_usuario UUID)
RETURNS JSON AS $$
DECLARE
    v_estado_actual VARCHAR(20);
    v_id_dispositivo UUID;
BEGIN
    -- 1. Bloquear la fila para evitar condiciones de carrera
    SELECT "EstadoProgreso", "IdDispositivo" INTO v_estado_actual, v_id_dispositivo
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync
    FOR UPDATE;

    -- 2. Validar estado
    IF v_estado_actual != 'PENDIENTE' THEN
        RETURN json_build_object('success', false, 'error', 'ALREADY_CLAIMED');
    END IF;

    -- 3. Marcar como completada
    UPDATE public."NotificacionesXDispositivo"
    SET "EstadoProgreso" = 'COMPLETADO'
    WHERE "IdSync" = p_id_sync;

    -- 4. Asignar al usuario
    INSERT INTO public."NotificacionesAUsuarios" ("IdSync", "IdUsuario")
    VALUES (p_id_sync, p_id_usuario);

    RETURN json_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 35_cierre_de_caja.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: IF)
-- ==========================================================================

-- ==========================================================
-- 35_CIERRE_DE_CAJA.SQL
-- Objetivo: Implementar el bloqueo de seguridad para evitar
-- reclamaciones retroactivas después de un cierre de caja.
-- ==========================================================

-- 1. TABLA DE CIERRES DE CAJA
CREATE TABLE IF NOT EXISTS public."CierresDeCaja" (
    "IdCierre" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "IdContratante" UUID NOT NULL REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
    "IdUsuarioAdmin" UUID NOT NULL REFERENCES public."Usuarios"("IdUsuario"),
    "FechaCierre" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "Observaciones" TEXT,
    "created_at" TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TRIGGER PARA BLOQUEAR RECLAMACIONES EN PERIODOS CERRADOS
CREATE OR REPLACE FUNCTION public.fn_trg_validar_cierre_caja()
RETURNS TRIGGER AS $$
DECLARE
    v_fecha_notif TIMESTAMPTZ;
    v_id_contratante UUID;
    v_ultimo_cierre TIMESTAMPTZ;
BEGIN
    -- 1. Obtener fecha de la notificación y el contratante
    SELECT "FechaOpera", "IdContratante" INTO v_fecha_notif, v_id_contratante
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = NEW."IdSync";

    -- 2. Buscar el último cierre de este contratante
    SELECT MAX("FechaCierre") INTO v_ultimo_cierre
    FROM public."CierresDeCaja"
    WHERE "IdContratante" = v_id_contratante;

    -- 3. Si existe un cierre y la notificación es anterior o igual, bloquear
    IF v_ultimo_cierre IS NOT NULL AND v_fecha_notif <= v_ultimo_cierre THEN
        RAISE EXCEPTION 'PERIOD_CLOSED_BY_ADMIN' USING HINT = 'La fecha del pago pertenece a un periodo ya cerrado por caja.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_before_insert_reclamacion_cierre ON public."NotificacionesAUsuarios";
CREATE TRIGGER trg_before_insert_reclamacion_cierre
BEFORE INSERT ON public."NotificacionesAUsuarios"
FOR EACH ROW
EXECUTE FUNCTION public.fn_trg_validar_cierre_caja();

-- 3. RPC PARA EJECUTAR EL CIERRE
CREATE OR REPLACE FUNCTION public.cerrar_caja(
    p_id_contratante UUID,
    p_id_usuario_admin UUID,
    p_observaciones TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_id_cierre UUID;
BEGIN
    -- Insertar el cierre
    INSERT INTO public."CierresDeCaja" ("IdContratante", "IdUsuarioAdmin", "FechaCierre", "Observaciones")
    VALUES (p_id_contratante, p_id_usuario_admin, NOW(), p_observaciones)
    RETURNING "IdCierre" INTO v_id_cierre;

    -- Opcional: Podríamos marcar todas las notificaciones PENDIENTES anteriores como CERRADAS
    -- pero el trigger ya las bloquea para nuevos reclamos.

    RETURN jsonb_build_object('success', true, 'id_cierre', v_id_cierre);
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 39_fix_ambiguedad_rpc.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: IF)
-- ==========================================================================

-- ==========================================================
-- 39_FIX_AMBIGUEDAD_RPC.SQL
-- Objetivo: Eliminar la función obsoleta de 3 parámetros para
-- evitar que la justificación caiga en el campo Observación.
-- ==========================================================

-- 1. ELIMINAR LA FUNCIÓN ANTIGUA (Firma de 3 parámetros)
-- Esto es lo que faltaba: CREATE OR REPLACE no borra funciones con distinta firma.
DROP FUNCTION IF EXISTS public.reclamar_notificacion_v2(uuid, uuid, text);

-- 2. RE-INSTALAR LA VERSIÓN CORRECTA (Firma de 4 parámetros)
CREATE OR REPLACE FUNCTION public.reclamar_notificacion_v2(
    p_id_sync UUID,
    p_id_usuario UUID,
    p_observacion TEXT DEFAULT NULL,
    p_justificacion TEXT DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_estado_maestra VARCHAR(20);
BEGIN
    -- Bloqueo preventivo
    SELECT "EstadoProgreso" INTO v_estado_maestra
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync
    FOR UPDATE;

    IF v_estado_maestra IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    IF v_estado_maestra = 'CERRADO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PERIOD_CLOSED');
    END IF;

    -- INSERT/UPDATE usando nombres de columnas explícitos
    INSERT INTO public."NotificacionesAUsuarios" (
        "IdSync",
        "IdUsuario",
        "Observacion",
        "JustificacionConflicto"
    )
    VALUES (
        p_id_sync,
        p_id_usuario,
        p_observacion,
        p_justificacion
    )
    ON CONFLICT ("IdSync", "IdUsuario") DO UPDATE
    SET
        "JustificacionConflicto" = COALESCE(EXCLUDED."JustificacionConflicto", public."NotificacionesAUsuarios"."JustificacionConflicto"),
        "Observacion" = COALESCE(EXCLUDED."Observacion", public."NotificacionesAUsuarios"."Observacion")
    WHERE public."NotificacionesAUsuarios"."EstadoReclamacion" = 'PROCESANDO';

    RETURN jsonb_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

