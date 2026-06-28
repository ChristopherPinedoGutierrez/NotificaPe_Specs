-- ==========================================================
-- 40_fix_rls_notificaciones_usuarios_web.sql
-- Descripción: Permitir que el Contratante (Admin Web) lea
-- las reclamaciones de sus vendedores en la tabla NotificacionesAUsuarios.
-- ==========================================================

-- 1. Política para que el Contratante pueda leer los reclamos de sus propios cobros
-- Esto permite que la vista view_notificaciones_disputadas (con security_invoker = true)
-- pueda devolver los reclamantes de un cobro al consultar desde el panel web.
DROP POLICY IF EXISTS "Contratantes_Leen_Reclamaciones_De_Sus_Cajas" ON public."NotificacionesAUsuarios";

CREATE POLICY "Contratantes_Leen_Reclamaciones_De_Sus_Cajas"
ON public."NotificacionesAUsuarios"
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public."NotificacionesXDispositivo" nd
        WHERE nd."IdSync" = public."NotificacionesAUsuarios"."IdSync"
        AND nd."IdContratante" = auth.uid()
    )
);


-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 38_justificacion_disputas.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesAUsuarios)
-- ==========================================================================

-- ==========================================================
-- 38_JUSTIFICACION_DISPUTAS.SQL
-- Objetivo: Añadir soporte para justificaciones de conflictos
-- separadas de la observación de venta original.
-- ==========================================================

-- 1. AÑADIR COLUMNA A NOTIFICACIONES_A_USUARIOS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='NotificacionesAUsuarios' AND column_name='JustificacionConflicto') THEN
        ALTER TABLE public."NotificacionesAUsuarios" ADD COLUMN "JustificacionConflicto" TEXT;
    END IF;
END $$;

-- 2. ACTUALIZACIÓN DEL RPC: RECLAMAR_NOTIFICACION_V2
-- ELIMINAMOS LA VERSIÓN ANTIGUA (3 parámetros) para evitar ambigüedad en Supabase
DROP FUNCTION IF EXISTS public.reclamar_notificacion_v2(uuid, uuid, text);

-- Se añade el parámetro p_justificacion y se permite actualizarla en conflictos.
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
    -- 1. Bloqueo preventivo y validación de existencia
    SELECT "EstadoProgreso" INTO v_estado_maestra
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync
    FOR UPDATE;

    IF v_estado_maestra IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    -- 2. Validar que no esté CERRADA
    IF v_estado_maestra = 'CERRADO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PERIOD_CLOSED');
    END IF;

    -- 3. Insertar o actualizar la reclamación
    -- Si ya existe, permitimos actualizar la justificación si está en revisión.
    INSERT INTO public."NotificacionesAUsuarios" ("IdSync", "IdUsuario", "Observacion", "JustificacionConflicto")
    VALUES (p_id_sync, p_id_usuario, p_observacion, p_justificacion)
    ON CONFLICT ("IdSync", "IdUsuario") DO UPDATE
    SET
        "JustificacionConflicto" = COALESCE(EXCLUDED."JustificacionConflicto", public."NotificacionesAUsuarios"."JustificacionConflicto"),
        "Observacion" = COALESCE(EXCLUDED."Observacion", public."NotificacionesAUsuarios"."Observacion")
    WHERE public."NotificacionesAUsuarios"."EstadoReclamacion" = 'PROCESANDO';

    RETURN jsonb_build_object('success', true);

EXCEPTION
    WHEN unique_violation THEN
        RETURN jsonb_build_object('success', false, 'error', 'ALREADY_RECLAIMED_BY_YOU');
    WHEN OTHERS THEN
        RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. ACTUALIZACIÓN DE LA VISTA PARA EL ADMIN WEB
CREATE OR REPLACE VIEW public.view_notificaciones_disputadas AS
SELECT
    nd."IdSync",
    nd."MontoCentimos",
    (SELECT column_name FROM information_schema.columns
     WHERE table_name='NotificacionesXDispositivo' AND column_name='CodigoOperacion' LIMIT 1) as "HasCol",
    nd."FechaOpera",
    b."Nombre" AS "App",
    nd."IdContratante",
    COALESCE(
        jsonb_agg(
            jsonb_build_object(
                'IdUsuario', nau."IdUsuario",
                'Nombre', u."NombreCompleto",
                'Observacion', nau."Observacion",
                'JustificacionConflicto', nau."JustificacionConflicto",
                'FechaReclamacion', nau."FechaReg"
            )
        ) FILTER (WHERE nau."IdUsuario" IS NOT NULL),
        '[]'::jsonb
    ) AS "Reclamantes"
FROM public."NotificacionesXDispositivo" nd
LEFT JOIN public."Billeteras" b ON nd."IdBilletera" = b."IdBilletera"
LEFT JOIN public."NotificacionesAUsuarios" nau ON nd."IdSync" = nau."IdSync"
LEFT JOIN public."Usuarios" u ON nau."IdUsuario" = u."IdUsuario"
WHERE nd."EstadoProgreso" = 'REVISION'
GROUP BY nd."IdSync", nd."MontoCentimos", nd."FechaOpera", b."Nombre", nd."IdContratante";



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 40_disable_cierre_jornada_blocking.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesAUsuarios)
-- ==========================================================================

-- ==========================================================
-- 40_DISABLE_CIERRE_JORNADA_BLOCKING.SQL
-- Objetivo: Deshabilitar el bloqueo automático de reclamos
-- por cierre de caja para centralizar la aprobación en el Admin.
-- ==========================================================

-- 1. ELIMINAR EL TRIGGER QUE BLOQUEA RECLAMACIONES
-- Esto permite que los usuarios sigan reclamando aunque haya un cierre registrado.
DROP TRIGGER IF EXISTS trg_before_insert_reclamacion_cierre ON public."NotificacionesAUsuarios";

-- 2. ELIMINAR LA FUNCIÓN DEL TRIGGER (Limpieza)
DROP FUNCTION IF EXISTS public.fn_trg_validar_cierre_caja();

-- 3. NOTA: Mantenemos la tabla "CierresDeCaja" y el RPC "cerrar_caja"
-- solo por compatibilidad de esquemas, pero ya no tienen efecto restrictivo.



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 42_fix_rls_mochila_identidad.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesAUsuarios)
-- ==========================================================================

-- ==========================================================
-- 42_FIX_RLS_MOCHILA_IDENTIDAD.SQL
-- Objetivo: Asegurar que los vendedores puedan leer sus propios
-- reclamos y que la "Mochila de Identidad" se llene correctamente.
-- ==========================================================

-- 1. Habilitar RLS (Si no estaba habilitado)
ALTER TABLE public."NotificacionesAUsuarios" ENABLE ROW LEVEL SECURITY;

-- 2. Política de Lectura: El usuario solo puede ver sus propias participaciones
DROP POLICY IF EXISTS "Usuarios_Leen_Sus_Propias_Participaciones" ON public."NotificacionesAUsuarios";
CREATE POLICY "Usuarios_Leen_Sus_Propias_Participaciones"
ON public."NotificacionesAUsuarios"
FOR SELECT
TO authenticated
USING (
    auth.uid() = "IdUsuario"
);

-- 3. Configuración para Realtime (Indispensable para el Radar de Identidad)
-- Esto permite que cuando la tabla cambie, Supabase envíe el registro completo al cliente.
ALTER TABLE public."NotificacionesAUsuarios" REPLICA IDENTITY FULL;

-- 4. Asegurar que la tabla está en la publicación de Realtime
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = 'NotificacionesAUsuarios'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public."NotificacionesAUsuarios";
    END IF;
END $$;

COMMENT ON TABLE public."NotificacionesAUsuarios" IS 'Almacena las participaciones/reclamos de los usuarios sobre las notificaciones. RLS habilitado para proteger la identidad del reclamante.';

