-- Script: 0048_webhooks_b2b_schema.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-10-05
-- Justificación: [CR-016] Módulo de Webhooks B2B Unidireccionales, auditoría de entregas, cuotas comerciales y gobernanza de add-on.

BEGIN;

-- ==============================================================================
-- 1. TABLA: WebhooksXContratante (Configuración de Endpoints)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public."WebhooksXContratante" (
    "IdWebhook" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "IdContratante" UUID NOT NULL REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
    "UrlEndpoint" VARCHAR(500) NOT NULL,
    "AuthTipo" VARCHAR(20) NOT NULL DEFAULT 'NONE', -- 'NONE', 'BEARER', 'CUSTOM_HEADER'
    "AuthToken" TEXT NULL,
    "CustomHeaderKey" VARCHAR(100) NULL,
    "CustomHeaderValue" TEXT NULL,
    "SecretFirma" VARCHAR(64) NOT NULL,
    "FiltroDispositivos" UUID[] NULL,               -- NULL = Todas las cajas; Array = Cajas específicas
    "Activo" BOOLEAN NOT NULL DEFAULT TRUE,
    "EstadoSalud" VARCHAR(20) NOT NULL DEFAULT 'SALUDABLE', -- 'SALUDABLE', 'CON_FALLAS', 'SUSPENDIDO'
    "FallasConsecutivas" INT NOT NULL DEFAULT 0,
    "UltimoDespacho" TIMESTAMPTZ NULL,
    "UltimoStatusHttp" INT NULL,
    "FechaCreacion" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_url_https CHECK ("UrlEndpoint" ~* '^https://')
);

CREATE INDEX IF NOT EXISTS idx_webhooks_contratante ON public."WebhooksXContratante"("IdContratante") WHERE "Activo" = TRUE;

-- ==============================================================================
-- 2. TABLA: EntregasWebhooks (Auditoría de Entregas)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public."EntregasWebhooks" (
    "IdEntrega" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "IdWebhook" UUID NOT NULL REFERENCES public."WebhooksXContratante"("IdWebhook") ON DELETE CASCADE,
    "IdSync" UUID NULL REFERENCES public."NotificacionesXDispositivo"("IdSync") ON DELETE SET NULL,
    "StatusHttp" INT NOT NULL,                  -- 200, 404, 500, o 0 (timeout/error de red)
    "DuracionMs" INT NOT NULL,                  -- Tiempo de respuesta en milisegundos
    "RequestPayload" JSONB NOT NULL,
    "ResponseBody" TEXT NULL,                   -- Fragmento de respuesta del cliente (máx 500 chars)
    "ErrorDetalle" TEXT NULL,
    "FechaEntrega" TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_entregas_webhook_fecha ON public."EntregasWebhooks"("IdWebhook", "FechaEntrega" DESC);

-- ==============================================================================
-- 3. POLÍTICAS RLS (Row Level Security)
-- ==============================================================================
ALTER TABLE public."WebhooksXContratante" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."EntregasWebhooks" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Contratantes gestionan sus propios webhooks" ON public."WebhooksXContratante";
CREATE POLICY "Contratantes gestionan sus propios webhooks"
ON public."WebhooksXContratante"
FOR ALL
TO authenticated
USING ("IdContratante" = auth.uid())
WITH CHECK ("IdContratante" = auth.uid());

DROP POLICY IF EXISTS "Superadmin gestiona WebhooksXContratante" ON public."WebhooksXContratante";
CREATE POLICY "Superadmin gestiona WebhooksXContratante"
ON public."WebhooksXContratante"
FOR ALL
TO authenticated
USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

DROP POLICY IF EXISTS "Contratantes ven sus propias entregas" ON public."EntregasWebhooks";
CREATE POLICY "Contratantes ven sus propias entregas"
ON public."EntregasWebhooks"
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public."WebhooksXContratante" w
    WHERE w."IdWebhook" = "EntregasWebhooks"."IdWebhook"
      AND w."IdContratante" = auth.uid()
  )
);

DROP POLICY IF EXISTS "Superadmin lee EntregasWebhooks" ON public."EntregasWebhooks";
CREATE POLICY "Superadmin lee EntregasWebhooks"
ON public."EntregasWebhooks"
FOR SELECT
TO authenticated
USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- ==============================================================================
-- 4. INTEGRACIÓN DE CUOTAS Y PRECIOS EN CATÁLOGO DE LICENCIAS
-- ==============================================================================
ALTER TABLE public."Licencias"
ADD COLUMN IF NOT EXISTS "LimiteWebhooks" INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS "PrecioExtraWebhookCentimos" INT NOT NULL DEFAULT 3000;

-- Configurar límites base por plan
UPDATE public."Licencias" SET "LimiteWebhooks" = 0, "PrecioExtraWebhookCentimos" = 3000 WHERE "Nombre" ILIKE '%Comerciante%';
UPDATE public."Licencias" SET "LimiteWebhooks" = 1, "PrecioExtraWebhookCentimos" = 3000 WHERE "Nombre" ILIKE '%Empresario%';
UPDATE public."Licencias" SET "LimiteWebhooks" = 3, "PrecioExtraWebhookCentimos" = 3000 WHERE "Nombre" ILIKE '%PYME%';

-- Columnas de extras para instancias activas y colas
ALTER TABLE public."LicenciasXContratante"
ADD COLUMN IF NOT EXISTS "ExtraWebhooks" INT NOT NULL DEFAULT 0;

ALTER TABLE public."LicenciasCola"
ADD COLUMN IF NOT EXISTS "ExtraWebhooks" INT NOT NULL DEFAULT 0;

-- ==============================================================================
-- 5. FUNCIÓN DE CONSULTA DE CUOTA DISPONIBLE: get_cuota_webhooks
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.get_cuota_webhooks(p_id_contratante UUID)
RETURNS JSONB AS $$
DECLARE
  v_limite_base INT := 0;
  v_extras INT := 0;
  v_en_uso INT := 0;
  v_permite_webhooks BOOLEAN := FALSE;
BEGIN
  -- Validar identidad
  IF auth.role() = 'authenticated' AND auth.uid() <> p_id_contratante THEN
    IF NOT EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()) THEN
      RAISE EXCEPTION 'No autorizado para consultar la cuota de otro contratante.';
    END IF;
  END IF;

  SELECT COALESCE(l."LimiteWebhooks", 0), COALESCE(lxc."ExtraWebhooks", 0), (COALESCE(l."LimiteWebhooks", 0) + COALESCE(lxc."ExtraWebhooks", 0) > 0)
    INTO v_limite_base, v_extras, v_permite_webhooks
    FROM public."LicenciasXContratante" lxc
    JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
   WHERE lxc."IdContratante" = p_id_contratante
     AND lxc."Activo" = TRUE
     AND lxc."FechaExpiracion" > NOW()
   LIMIT 1;

  SELECT COUNT(*)::INT
    INTO v_en_uso
    FROM public."WebhooksXContratante"
   WHERE "IdContratante" = p_id_contratante
     AND "Activo" = TRUE;

  RETURN jsonb_build_object(
    'limite_base', v_limite_base,
    'extras', v_extras,
    'cuota_total', (v_limite_base + v_extras),
    'en_uso', v_en_uso,
    'disponibles', GREATEST(0, (v_limite_base + v_extras) - v_en_uso),
    'permite_webhooks', v_permite_webhooks
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- ==============================================================================
-- 6. ACTUALIZAR RPC: previsualizar_compra_licencia (Soporte p_extra_webhooks)
-- ==============================================================================
DROP FUNCTION IF EXISTS public.previsualizar_compra_licencia(uuid, smallint, boolean, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.previsualizar_compra_licencia(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_factor_unidad_entera INT,
  p_extra_usuarios INT DEFAULT 0,
  p_extra_dispositivos INT DEFAULT 0,
  p_extra_webhooks INT DEFAULT 0
) RETURNS TABLE(
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
  v_precio_extra_webhook INT;
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

  SELECT "PrecioCentimos", "Moneda", "PrecioExtraUsuarioCentimos", "PrecioExtraDispositivoCentimos", "PrecioExtraWebhookCentimos", "DuracionDias"
    INTO v_precio_base, v_moneda, v_precio_extra_usr, v_precio_extra_disp, v_precio_extra_webhook, v_duracion_dias_destino
    FROM public."Licencias"
   WHERE "IdLicencia" = p_id_licencia
     AND "Activo" = TRUE;

  IF v_precio_base IS NULL THEN
    RAISE EXCEPTION 'Licencia destino no encontrada o inactiva.';
  END IF;

  v_precio_total := v_precio_base + 
                    (COALESCE(v_precio_extra_usr, 0) * p_extra_usuarios) + 
                    (COALESCE(v_precio_extra_disp, 0) * p_extra_dispositivos) +
                    (COALESCE(v_precio_extra_webhook, 0) * p_extra_webhooks);

  SELECT c."CreditoDisponibleEnUnidadMinima"
    INTO v_cred_actual
    FROM public."CreditoXContratante" c
   WHERE c."IdContratante" = p_id_contratante;

  IF p_aplicar_ahora THEN
    SELECT lxc."IdLicencia", lxc."FechaExpiracion", l."PrecioCentimos", l."DuracionDias", l."Moneda",
           l."PrecioExtraUsuarioCentimos", l."PrecioExtraDispositivoCentimos", l."PrecioExtraWebhookCentimos",
           lxc."ExtraUsuarios", lxc."ExtraDispositivos", lxc."ExtraWebhooks"
      INTO v_activa
      FROM public."LicenciasXContratante" lxc
      JOIN public."Licencias" l ON l."IdLicencia" = lxc."IdLicencia"
     WHERE lxc."IdContratante" = p_id_contratante
       AND lxc."Activo" = TRUE
     LIMIT 1;

    -- Generar crédito si cambia de plan o cambian sus extras
    IF FOUND AND (v_activa."IdLicencia" <> p_id_licencia OR COALESCE(v_activa."ExtraUsuarios",0) <> p_extra_usuarios OR COALESCE(v_activa."ExtraDispositivos",0) <> p_extra_dispositivos OR COALESCE(v_activa."ExtraWebhooks",0) <> p_extra_webhooks) THEN
      IF v_activa."Moneda" <> v_moneda THEN
        RAISE EXCEPTION 'No se permite mezclar monedas en una misma operacion.';
      END IF;

      v_dias_restantes := GREATEST(0, EXTRACT(EPOCH FROM (v_activa."FechaExpiracion" - NOW())) / 86400.0);
      
      v_valor_activa_total := COALESCE(v_activa."PrecioCentimos", 0) + 
                              (COALESCE(v_activa."PrecioExtraUsuarioCentimos", 0) * COALESCE(v_activa."ExtraUsuarios", 0)) +
                              (COALESCE(v_activa."PrecioExtraDispositivoCentimos", 0) * COALESCE(v_activa."ExtraDispositivos", 0)) +
                              (COALESCE(v_activa."PrecioExtraWebhookCentimos", 0) * COALESCE(v_activa."ExtraWebhooks", 0));
                              
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 7. ACTUALIZAR RPC: ejecutar_compra_licencia_multiple (Soporte p_extra_webhooks)
-- ==============================================================================
DROP FUNCTION IF EXISTS public.ejecutar_compra_licencia_multiple(uuid, smallint, boolean, character varying, bigint, character, text, character varying, text, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.ejecutar_compra_licencia_multiple(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_clave_idempotencia VARCHAR(50),
  p_monto_cobrado_en_unidad_minima BIGINT DEFAULT 0,
  p_codigo_moneda CHAR(3) DEFAULT 'PEN',
  p_proveedor_pago TEXT DEFAULT NULL,
  p_id_operacion_pago VARCHAR(100) DEFAULT NULL,
  p_origen TEXT DEFAULT 'MIXTO',
  p_factor_unidad_entera INT DEFAULT 100,
  p_cantidad INT DEFAULT 1,
  p_extra_usuarios INT DEFAULT 0,
  p_extra_dispositivos INT DEFAULT 0,
  p_extra_webhooks INT DEFAULT 0
) RETURNS TABLE(
  id_transaccion_licencia BIGINT,
  monto_final_en_unidad_minima BIGINT,
  credito_aplicado_en_unidad_minima BIGINT,
  licencia_en_cola BOOLEAN,
  id_licencia_contratante INT,
  id_licencia_cola BIGINT
) AS $$
DECLARE
  v_prev RECORD;
  v_costo_unitario BIGINT;
  v_costo_total BIGINT;
  v_credito_aplicado BIGINT;
  v_monto_final BIGINT;
  v_tx_lic BIGINT;
  v_id_lic_contratante INT := NULL;
  v_id_lic_cola BIGINT := NULL;
  v_duracion INT;
  v_lic_activa RECORD;
  v_nueva_exp TIMESTAMPTZ;
  v_id_lic_origen SMALLINT := NULL;
  v_canal TEXT;
  v_dias_restantes_trial NUMERIC := 0;
  v_diferencial_vuelto BIGINT := 0;
BEGIN
  IF p_cantidad < 1 THEN
    RAISE EXCEPTION 'La cantidad de licencias debe ser al menos 1.';
  END IF;

  -- 1. Idempotencia
  IF EXISTS (SELECT 1 FROM public."TransaccionesXLicencia" WHERE "ClaveIdempotencia" = p_clave_idempotencia) THEN
    RAISE EXCEPTION 'Operacion duplicada detectada (Idempotencia activa).';
  END IF;

  -- 2. Previsualizar costo unitario con extras
  SELECT * INTO v_prev
    FROM public.previsualizar_compra_licencia(
      p_id_contratante,
      p_id_licencia,
      p_aplicar_ahora,
      p_factor_unidad_entera,
      p_extra_usuarios,
      p_extra_dispositivos,
      p_extra_webhooks
    );

  IF NOT FOUND THEN
    RAISE EXCEPTION 'No se pudo previsualizar la compra.';
  END IF;

  v_costo_unitario := v_prev.precio_lista_en_unidad_minima;
  v_costo_total := v_costo_unitario * p_cantidad;
  v_credito_aplicado := LEAST(v_costo_total, v_prev.credito_actual_en_unidad_minima + v_prev.credito_generado_en_unidad_minima);
  v_monto_final := GREATEST(0, v_costo_total - v_credito_aplicado);

  IF p_monto_cobrado_en_unidad_minima < v_monto_final THEN
    RAISE EXCEPTION 'El monto cobrado (%) es inferior al requerido (%).', p_monto_cobrado_en_unidad_minima, v_monto_final;
  END IF;

  -- 3. Modificar saldos de crédito
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

  -- Diferencial de vuelto pasarela
  v_diferencial_vuelto := p_monto_cobrado_en_unidad_minima - v_monto_final;
  IF v_diferencial_vuelto > 0 AND p_origen = 'PASARELA' THEN
    UPDATE public."CreditoXContratante"
       SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + v_diferencial_vuelto,
           "UpdatedAt" = NOW()
     WHERE "IdContratante" = p_id_contratante;

    PERFORM public.registrar_tx_credito(
      p_id_contratante,
      'ABONO',
      'TICKET_MINIMO_VUELTO',
      v_diferencial_vuelto,
      p_codigo_moneda,
      NULL,
      p_id_operacion_pago,
      p_clave_idempotencia || '-VUELTO',
      jsonb_build_object(
        'monto_original_debido', v_monto_final,
        'monto_cobrado_pasarela', p_monto_cobrado_en_unidad_minima,
        'diferencial_vuelto', v_diferencial_vuelto
      )
    );
  END IF;

  -- 4. Inserción de licencias
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
        "ExtraDispositivos",
        "ExtraWebhooks"
      ) VALUES (
        p_id_contratante,
        p_id_licencia,
        COALESCE(p_id_operacion_pago, 'CREDITO-' || EXTRACT(EPOCH FROM NOW())::BIGINT),
        NOW(),
        v_nueva_exp,
        TRUE,
        p_extra_usuarios,
        p_extra_dispositivos,
        p_extra_webhooks
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
        "ExtraDispositivos",
        "ExtraWebhooks"
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
        p_extra_dispositivos,
        p_extra_webhooks
      ) RETURNING "IdLicenciaCola" INTO v_id_lic_cola;
    END IF;
  END LOOP;

  PERFORM public.resecuenciar_prioridades(p_id_contratante);

  -- 5. Transacción de Auditoría
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
    jsonb_build_object(
      'origen', p_origen,
      'aplicar_ahora', p_aplicar_ahora,
      'cantidad', p_cantidad,
      'dias_trial_sumados', COALESCE(v_dias_restantes_trial, 0),
      'extra_usuarios', p_extra_usuarios,
      'extra_dispositivos', p_extra_dispositivos,
      'extra_webhooks', p_extra_webhooks,
      'diferencial_vuelto', v_diferencial_vuelto
    )
  ) RETURNING "IdTransaccionLicencia" INTO v_tx_lic;

  RETURN QUERY
  SELECT v_tx_lic, v_monto_final, v_credito_aplicado, (v_id_lic_cola IS NOT NULL), v_id_lic_contratante, v_id_lic_cola;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Wrappers para compatibilidad
CREATE OR REPLACE FUNCTION public.ejecutar_compra_licencia(
  p_id_contratante UUID,
  p_id_licencia SMALLINT,
  p_aplicar_ahora BOOLEAN,
  p_clave_idempotencia VARCHAR(50),
  p_monto_cobrado_en_unidad_minima BIGINT DEFAULT 0,
  p_codigo_moneda CHAR(3) DEFAULT 'PEN',
  p_proveedor_pago TEXT DEFAULT NULL,
  p_id_operacion_pago VARCHAR(100) DEFAULT NULL,
  p_origen TEXT DEFAULT 'MIXTO',
  p_factor_unidad_entera INT DEFAULT 100,
  p_extra_usuarios INT DEFAULT 0,
  p_extra_dispositivos INT DEFAULT 0,
  p_extra_webhooks INT DEFAULT 0
) RETURNS TABLE(
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
    1,
    p_extra_usuarios,
    p_extra_dispositivos,
    p_extra_webhooks
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 8. ACTUALIZAR ACTIVACIÓN JIT: activar_licencia_cola_si_aplica (Transfiere ExtraWebhooks)
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.activar_licencia_cola_si_aplica(
  p_id_contratante UUID
) RETURNS JSONB AS $$
DECLARE
  v_lic_cola RECORD;
  v_duracion INT;
  v_ult_exp TIMESTAMPTZ;
  v_fecha_inicio TIMESTAMPTZ;
  v_nueva_exp TIMESTAMPTZ;
  v_id_lic_contratante INT;
BEGIN
  -- Control de autorización
  IF auth.role() = 'authenticated' AND auth.uid() <> p_id_contratante THEN
    IF NOT EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()) THEN
      RAISE EXCEPTION 'No autorizado para activar la cola de otro contratante.';
    END IF;
  END IF;

  -- 1.1 Si el contratante ya tiene una licencia activa vigente, no hay nada que promover
  IF EXISTS (
    SELECT 1 
      FROM public."LicenciasXContratante"
     WHERE "IdContratante" = p_id_contratante
       AND "Activo" = TRUE
       AND "FechaExpiracion" > NOW()
  ) THEN
    RETURN jsonb_build_object('activada', FALSE, 'motivo', 'LICENCIA_ACTIVA_VIGENTE');
  END IF;

  -- 1.2 Marcar como inactivas licencias expiradas
  UPDATE public."LicenciasXContratante"
     SET "Activo" = FALSE
   WHERE "IdContratante" = p_id_contratante
     AND "Activo" = TRUE
     AND "FechaExpiracion" <= NOW();

  -- 1.3 Bloqueo pesimista sobre la licencia en cola prioritaria
  SELECT * INTO v_lic_cola
    FROM public."LicenciasCola"
   WHERE "IdContratante" = p_id_contratante
     AND "Estado" = 'PROGRAMADA'
   ORDER BY "Prioridad" ASC
   LIMIT 1
   FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('activada', FALSE, 'motivo', 'SIN_LICENCIAS_EN_COLA');
  END IF;

  -- 1.4 Obtener duración del plan
  SELECT "DuracionDias" INTO v_duracion
    FROM public."Licencias"
   WHERE "IdLicencia" = v_lic_cola."IdLicencia";

  -- 1.5 Determinar fecha de inicio continua
  SELECT MAX("FechaExpiracion") INTO v_ult_exp
    FROM public."LicenciasXContratante"
   WHERE "IdContratante" = p_id_contratante;

  IF v_ult_exp IS NOT NULL AND v_ult_exp > NOW() THEN
    v_fecha_inicio := v_ult_exp;
  ELSE
    v_fecha_inicio := NOW();
  END IF;

  v_nueva_exp := v_fecha_inicio + (v_duracion || ' days')::INTERVAL;

  -- 1.6 Inserción en LicenciasXContratante incluyendo ExtraWebhooks
  INSERT INTO public."LicenciasXContratante" (
    "IdContratante",
    "IdLicencia",
    "NumeroOrden",
    "FechaInicio",
    "FechaExpiracion",
    "Activo",
    "ExtraUsuarios",
    "ExtraDispositivos",
    "ExtraWebhooks"
  ) VALUES (
    p_id_contratante,
    v_lic_cola."IdLicencia",
    'COLA-' || v_lic_cola."IdLicenciaCola",
    v_fecha_inicio,
    v_nueva_exp,
    TRUE,
    COALESCE(v_lic_cola."ExtraUsuarios", 0),
    COALESCE(v_lic_cola."ExtraDispositivos", 0),
    COALESCE(v_lic_cola."ExtraWebhooks", 0)
  ) RETURNING "IdLicenciaContratante" INTO v_id_lic_contratante;

  -- 1.7 Marcar como APLICADA en la cola
  UPDATE public."LicenciasCola"
     SET "Estado" = 'APLICADA',
         "UpdatedAt" = NOW()
   WHERE "IdLicenciaCola" = v_lic_cola."IdLicenciaCola";

  -- 1.8 Re-secuenciar prioridades
  PERFORM public.resecuenciar_prioridades(p_id_contratante);

  RETURN jsonb_build_object(
    'activada', TRUE,
    'id_licencia_contratante', v_id_lic_contratante,
    'id_licencia_cola', v_lic_cola."IdLicenciaCola",
    'fecha_inicio', v_fecha_inicio,
    'fecha_expiracion', v_nueva_exp
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 9. FUNCIÓN DE PURGA DE LOGS ANTIGUOS (> 15 días)
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.purgar_logs_webhooks_antiguos()
RETURNS VOID AS $$
BEGIN
  DELETE FROM public."EntregasWebhooks"
   WHERE "FechaEntrega" < NOW() - INTERVAL '15 days';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 10. TRIGGER Y FUNCIÓN DISPATCHER DE NOTIFICACIONES A WEBHOOKS
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.fn_dispatch_webhooks_contratante()
RETURNS TRIGGER AS $$
DECLARE
  v_count INT;
  edge_url TEXT := 'https://ukwzdlrnengpdnnuvofo.supabase.co/functions/v1/dispatch-webhook';
  payload JSONB;
  auth_header JSONB := '{"Content-Type": "application/json", "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrd3pkbHJuZW5ncGRubnV2b2ZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MDE2NzgsImV4cCI6MjA5MTE3NzY3OH0.FJHI1KMmSMxB6bhALnBN-qspRlQ4_ippNvTusT6xesY"}'::jsonb;
  v_alias_dispositivo TEXT;
  v_billetera_nombre TEXT;
BEGIN
  IF NEW."Privada" = false AND NEW."MontoCentimos" > 0 AND NEW."EstadoProgreso" = 'PENDIENTE' THEN
    SELECT COUNT(*)::INT INTO v_count
      FROM public."WebhooksXContratante"
     WHERE "IdContratante" = NEW."IdContratante"
       AND "Activo" = TRUE
       AND "EstadoSalud" <> 'SUSPENDIDO';

    IF v_count > 0 THEN
      SELECT "AliasDispositivo" INTO v_alias_dispositivo
        FROM public."DispositivosXContratante"
       WHERE "IdDispositivo" = NEW."IdDispositivo";

      SELECT "Nombre" INTO v_billetera_nombre
        FROM public."Billeteras"
       WHERE "IdBilletera" = NEW."IdBilletera";

      payload := jsonb_build_object(
        'action', 'DISPATCH_PAYMENT',
        'id_contratante', NEW."IdContratante",
        'notificacion', jsonb_build_object(
          'IdSync', NEW."IdSync",
          'IdDispositivo', NEW."IdDispositivo",
          'DispositivoAlias', COALESCE(v_alias_dispositivo, 'Dispositivo sin alias'),
          'IdBilletera', NEW."IdBilletera",
          'Billetera', COALESCE(v_billetera_nombre, 'BILLETERA'),
          'MontoCentimos', NEW."MontoCentimos",
          'Moneda', NEW."Moneda",
          'Remitente', NEW."Remitente",
          'FechaOpera', NEW."FechaOpera",
          'Prueba', NEW."Prueba",
          'CodigoOperacion', NEW."CodigoOperacion"
        )
      );

      PERFORM net.http_post(
        url := edge_url,
        headers := auth_header,
        body := payload
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_webhooks_notificaciones ON public."NotificacionesXDispositivo";
CREATE TRIGGER trg_webhooks_notificaciones
AFTER INSERT ON public."NotificacionesXDispositivo"
FOR EACH ROW
EXECUTE FUNCTION public.fn_dispatch_webhooks_contratante();

COMMIT;
