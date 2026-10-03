-- 0045_motor_promociones.sql

-- 1. Tabla CampanasPromocionales
CREATE TABLE public."CampanasPromocionales" (
    "IdCampana" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "TipoEvento" TEXT NOT NULL CHECK ("TipoEvento" IN ('WELCOME', 'REFERRAL', 'RETURN', 'MANUAL')),
    "Nombre" TEXT NOT NULL,
    "MontoAnfitrion" BIGINT NOT NULL DEFAULT 0,
    "MontoInvitado" BIGINT NOT NULL,
    "FechaInicio" TIMESTAMPTZ,
    "FechaFin" TIMESTAMPTZ,
    "UsosMaximos" INT,
    "UsosActuales" INT NOT NULL DEFAULT 0,
    "CodigoTexto" VARCHAR(20) UNIQUE, -- Para canje manual (PROMO2026)
    "Estado" TEXT NOT NULL DEFAULT 'ACTIVA' CHECK ("Estado" IN ('ACTIVA', 'INACTIVA')),
    "CreatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS para CampanasPromocionales
ALTER TABLE public."CampanasPromocionales" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública de campañas activas" ON public."CampanasPromocionales"
    FOR SELECT USING ("Estado" = 'ACTIVA');

CREATE POLICY "Superadmins gestionan campanas" ON public."CampanasPromocionales"
    FOR ALL USING (
        EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid())
    );

-- 2. Modificar Contratantes para Referidos
ALTER TABLE public."Contratantes" ADD COLUMN "CodigoReferido" VARCHAR(6) UNIQUE;

-- 3. Tabla CanjesPromocionales (Para evitar doble canje)
CREATE TABLE public."CanjesPromocionales" (
    "IdCanje" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "IdCampana" UUID NOT NULL REFERENCES public."CampanasPromocionales"("IdCampana") ON DELETE RESTRICT,
    "IdContratante" UUID NOT NULL REFERENCES public."Contratantes"("IdContratante") ON DELETE CASCADE,
    "CreatedAt" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE ("IdCampana", "IdContratante")
);
ALTER TABLE public."CanjesPromocionales" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Contratante lee sus canjes" ON public."CanjesPromocionales"
    FOR SELECT USING ("IdContratante" = auth.uid()); 

-- 4. Modificar TransaccionesXCredito (El flag para el Spotlight)
ALTER TABLE public."TransaccionesXCredito" ADD COLUMN "VistoPorUsuario" BOOLEAN NOT NULL DEFAULT TRUE;

-- 5. Seed Data Inicial
INSERT INTO public."CampanasPromocionales" ("TipoEvento", "Nombre", "MontoInvitado", "MontoAnfitrion", "Estado")
VALUES 
('WELCOME', 'Bono de Bienvenida Base', 20, 0, 'ACTIVA'),
('REFERRAL', 'Programa de Referidos', 10, 10, 'ACTIVA'),
('RETURN', 'Bono de Retorno (Win-back)', 20, 0, 'ACTIVA');

INSERT INTO public."CampanasPromocionales" ("TipoEvento", "Nombre", "MontoInvitado", "MontoAnfitrion", "UsosMaximos", "CodigoTexto", "FechaFin", "Estado")
VALUES 
('MANUAL', 'Promo Especial 2026', 20, 0, 100, 'PROMO2026', '2026-12-31 23:59:59-05', 'ACTIVA');

-- 6. Función Auxiliar: Evaluar Mejor Campaña por Tipo (La lógica inteligente)
CREATE OR REPLACE FUNCTION public.evaluar_mejor_campana(p_tipo_evento TEXT)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_id_campana UUID;
BEGIN
    SELECT "IdCampana" INTO v_id_campana
    FROM public."CampanasPromocionales"
    WHERE "TipoEvento" = p_tipo_evento
      AND "Estado" = 'ACTIVA'
      AND ("FechaInicio" IS NULL OR "FechaInicio" <= NOW())
      AND ("FechaFin" IS NULL OR "FechaFin" >= NOW())
      AND ("UsosMaximos" IS NULL OR "UsosActuales" < "UsosMaximos")
    ORDER BY 
      ("FechaFin" IS NOT NULL) DESC, -- Prioriza las que tienen fecha de fin (temporales)
      "MontoInvitado" DESC           -- Desempate por mayor monto
    LIMIT 1;
    
    RETURN v_id_campana;
END;
$$;

-- 7. Trigger para autogenerar CodigoReferido en nuevos Contratantes
CREATE OR REPLACE FUNCTION public.generar_codigo_referido()
RETURNS trigger AS $$
BEGIN
  IF NEW."CodigoReferido" IS NULL THEN
    NEW."CodigoReferido" := UPPER(substring(md5(random()::text), 1, 6));
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_generar_codigo_referido
BEFORE INSERT ON public."Contratantes"
FOR EACH ROW
EXECUTE FUNCTION public.generar_codigo_referido();

-- 8. RPC para procesar canje manual seguro
CREATE OR REPLACE FUNCTION public.procesar_canje_manual(p_id_contratante UUID, p_codigo TEXT)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_campana RECORD;
    v_ya_canjeado BOOLEAN;
BEGIN
    SELECT * INTO v_campana
    FROM public."CampanasPromocionales"
    WHERE "TipoEvento" = 'MANUAL'
      AND "CodigoTexto" = p_codigo
      AND "Estado" = 'ACTIVA'
    FOR UPDATE;

    IF v_campana IS NULL THEN
        RAISE EXCEPTION 'Código inválido o inactivo.';
    END IF;

    IF v_campana."FechaInicio" IS NOT NULL AND v_campana."FechaInicio" > NOW() THEN
        RAISE EXCEPTION 'Este código aún no está activo.';
    END IF;

    IF v_campana."FechaFin" IS NOT NULL AND v_campana."FechaFin" < NOW() THEN
        RAISE EXCEPTION 'Este código ya expiró.';
    END IF;

    IF v_campana."UsosMaximos" IS NOT NULL AND v_campana."UsosActuales" >= v_campana."UsosMaximos" THEN
        RAISE EXCEPTION 'Este código ha alcanzado su límite de usos.';
    END IF;

    -- Verificar si el usuario ya canjeó esta promoción
    SELECT EXISTS (
        SELECT 1 FROM public."CanjesPromocionales" 
        WHERE "IdCampana" = v_campana."IdCampana" AND "IdContratante" = p_id_contratante
    ) INTO v_ya_canjeado;

    IF v_ya_canjeado THEN
        RAISE EXCEPTION 'Ya has canjeado este código promocional anteriormente.';
    END IF;

    INSERT INTO public."CanjesPromocionales" ("IdCampana", "IdContratante")
    VALUES (v_campana."IdCampana", p_id_contratante);

    UPDATE public."CampanasPromocionales"
    SET "UsosActuales" = "UsosActuales" + 1
    WHERE "IdCampana" = v_campana."IdCampana";

    PERFORM public.ensure_credito_contratante(p_id_contratante, 'PEN');
    UPDATE public."CreditoXContratante"
    SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + (v_campana."MontoInvitado" * 100),
        "UpdatedAt" = NOW()
    WHERE "IdContratante" = p_id_contratante;

    PERFORM public.registrar_tx_credito(
        p_id_contratante,
        'ABONO',
        'SISTEMA',
        (v_campana."MontoInvitado" * 100),
        'PEN',
        NULL,
        'MANUAL_BONUS_' || v_campana."IdCampana"::TEXT,
        'Campaña Promocional (' || p_codigo || ')',
        jsonb_build_object('campana_id', v_campana."IdCampana", 'codigo', p_codigo)
    );

    UPDATE public."TransaccionesXCredito"
    SET "VistoPorUsuario" = FALSE
    WHERE "IdContratante" = p_id_contratante AND "ReferenciaExterna" = 'MANUAL_BONUS_' || v_campana."IdCampana"::TEXT;
END;
$$;

-- 9. RPC para procesar bienvenida y referidos al registro
CREATE OR REPLACE FUNCTION public.procesar_campanas_registro(p_id_contratante UUID, p_codigo_invitacion TEXT DEFAULT NULL)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_campana_welcome_id UUID;
    v_campana_referral_id UUID;
    v_monto_welcome BIGINT;
    
    v_anfitrion_id UUID;
    v_monto_invitado BIGINT;
    v_monto_anfitrion BIGINT;
BEGIN
    PERFORM public.ensure_credito_contratante(p_id_contratante, 'PEN');

    -- 1. Procesar WELCOME
    v_campana_welcome_id := public.evaluar_mejor_campana('WELCOME');
    IF v_campana_welcome_id IS NOT NULL THEN
        -- Obtener montos y actualizar usos
        SELECT "MontoInvitado" INTO v_monto_welcome
        FROM public."CampanasPromocionales"
        WHERE "IdCampana" = v_campana_welcome_id;
        
        UPDATE public."CampanasPromocionales"
        SET "UsosActuales" = "UsosActuales" + 1
        WHERE "IdCampana" = v_campana_welcome_id;
        
        -- Actualizar saldo real
        UPDATE public."CreditoXContratante"
        SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + (v_monto_welcome * 100),
            "UpdatedAt" = NOW()
        WHERE "IdContratante" = p_id_contratante;

                INSERT INTO public."CanjesPromocionales" ("IdCampana", "IdContratante")
        VALUES (v_campana_welcome_id, p_id_contratante)
        ON CONFLICT DO NOTHING;

        -- Abonar al usuario
        PERFORM public.registrar_tx_credito(
            p_id_contratante,
            'ABONO',
            'SISTEMA',
            (v_monto_welcome * 100),
            'PEN',
            NULL,
            'WELCOME_BONUS_' || v_campana_welcome_id::TEXT,
            'Bono de Bienvenida',
            jsonb_build_object('campana_id', v_campana_welcome_id)
        );
        
        -- Marcar como NO VISTO para el Spotlight
        UPDATE public."TransaccionesXCredito"
        SET "VistoPorUsuario" = FALSE
        WHERE "IdContratante" = p_id_contratante AND "ReferenciaExterna" = 'WELCOME_BONUS_' || v_campana_welcome_id::TEXT;
    END IF;

    -- 2. Procesar REFERRAL
    IF p_codigo_invitacion IS NOT NULL AND p_codigo_invitacion != '' THEN
        -- Buscar anfitrión
        SELECT "IdContratante" INTO v_anfitrion_id
        FROM public."Contratantes"
        WHERE "CodigoReferido" = UPPER(p_codigo_invitacion);
        
        IF v_anfitrion_id IS NOT NULL AND v_anfitrion_id != p_id_contratante THEN
            v_campana_referral_id := public.evaluar_mejor_campana('REFERRAL');
            IF v_campana_referral_id IS NOT NULL THEN
                SELECT "MontoInvitado", "MontoAnfitrion" INTO v_monto_invitado, v_monto_anfitrion
                FROM public."CampanasPromocionales"
                WHERE "IdCampana" = v_campana_referral_id;
                
                UPDATE public."CampanasPromocionales"
                SET "UsosActuales" = "UsosActuales" + 1
                WHERE "IdCampana" = v_campana_referral_id;
                
                -- Actualizar saldo real (Invitado)
                UPDATE public."CreditoXContratante"
                SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + (v_monto_invitado * 100),
                    "UpdatedAt" = NOW()
                WHERE "IdContratante" = p_id_contratante;

                                INSERT INTO public."CanjesPromocionales" ("IdCampana", "IdContratante")
                VALUES (v_campana_referral_id, p_id_contratante)
                ON CONFLICT DO NOTHING;

                -- Abonar al Invitado \(nuevo usuario\)
                PERFORM public.registrar_tx_credito(
                    p_id_contratante,
                    'ABONO',
                    'SISTEMA',
                    (v_monto_invitado * 100),
                    'PEN',
                    NULL,
                    'REF_GUEST_' || v_campana_referral_id::TEXT,
                    'Bono de Invitación',
                    jsonb_build_object('campana_id', v_campana_referral_id, 'referido_por', v_anfitrion_id)
                );
                
                UPDATE public."TransaccionesXCredito"
                SET "VistoPorUsuario" = FALSE
                WHERE "IdContratante" = p_id_contratante AND "ReferenciaExterna" = 'REF_GUEST_' || v_campana_referral_id::TEXT;
                
                -- Abonar al Anfitrión
                IF v_monto_anfitrion > 0 THEN
                    PERFORM public.ensure_credito_contratante(v_anfitrion_id, 'PEN');

                    -- Actualizar saldo real (Anfitrión)
                    UPDATE public."CreditoXContratante"
                    SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + (v_monto_anfitrion * 100),
                        "UpdatedAt" = NOW()
                    WHERE "IdContratante" = v_anfitrion_id;

                    PERFORM public.registrar_tx_credito(
                        v_anfitrion_id,
                        'ABONO',
                        'SISTEMA',
                        (v_monto_anfitrion * 100),
                        'PEN',
                        NULL,
                        'REF_HOST_' || p_id_contratante::TEXT,
                        'Bono por Referir - ' || p_id_contratante::TEXT,
                        jsonb_build_object('campana_id', v_campana_referral_id, 'nuevo_usuario', p_id_contratante)
                    );
                    
                    UPDATE public."TransaccionesXCredito"
                    SET "VistoPorUsuario" = FALSE
                    WHERE "IdContratante" = v_anfitrion_id AND "ReferenciaExterna" = 'REF_HOST_' || p_id_contratante::TEXT;
                END IF;
            END IF;
        END IF;
    END IF;
END;
$$;

-- 10. RPC para procesar bono de retorno (Win-back)
CREATE OR REPLACE FUNCTION public.procesar_campana_retorno(p_id_contratante UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_campana_return_id UUID;
    v_monto_return BIGINT;
    v_dias_expirada INT;
    v_ya_reclamo BOOLEAN;
BEGIN
    SELECT EXTRACT(DAY FROM NOW() - MAX("FechaFin")) INTO v_dias_expirada
    FROM public."LicenciasXContratante"
    WHERE "IdContratante" = p_id_contratante;
    
    IF v_dias_expirada IS NOT NULL AND v_dias_expirada >= 30 THEN
        SELECT EXISTS (
            SELECT 1 
            FROM public."TransaccionesXCredito"
            WHERE "IdContratante" = p_id_contratante
              AND "ReferenciaExterna" LIKE 'RETURN_BONUS_%'
              AND "CreatedAt" > NOW() - INTERVAL '1 year'
        ) INTO v_ya_reclamo;
        
        IF NOT v_ya_reclamo THEN
            v_campana_return_id := public.evaluar_mejor_campana('RETURN');
            IF v_campana_return_id IS NOT NULL THEN
                SELECT "MontoInvitado" INTO v_monto_return
                FROM public."CampanasPromocionales"
                WHERE "IdCampana" = v_campana_return_id;
                
                UPDATE public."CampanasPromocionales"
                SET "UsosActuales" = "UsosActuales" + 1
                WHERE "IdCampana" = v_campana_return_id;
                
                PERFORM public.ensure_credito_contratante(p_id_contratante, 'PEN');
                UPDATE public."CreditoXContratante"
                SET "CreditoDisponibleEnUnidadMinima" = "CreditoDisponibleEnUnidadMinima" + (v_monto_return * 100),
                    "UpdatedAt" = NOW()
                WHERE "IdContratante" = p_id_contratante;

                PERFORM public.registrar_tx_credito(
                    p_id_contratante,
                    'ABONO',
                    'SISTEMA',
                    (v_monto_return * 100),
                    'PEN',
                    NULL,
                    'RETURN_BONUS_' || v_campana_return_id::TEXT,
                    'Bono de Retorno (Win-back)',
                    jsonb_build_object('campana_id', v_campana_return_id)
                );
                
                UPDATE public."TransaccionesXCredito"
                SET "VistoPorUsuario" = FALSE
                WHERE "IdContratante" = p_id_contratante AND "ReferenciaExterna" = 'RETURN_BONUS_' || v_campana_return_id::TEXT;
            END IF;
        END IF;
    END IF;
END;
$$;


