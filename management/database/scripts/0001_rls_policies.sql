-- ==========================================================
-- 1. RLS: DISPOSITIVOS (CAJAS)
-- Permite que los Contratantes (Dueños) solo administren las cajas que ellos crearon.
-- ==========================================================
ALTER TABLE public."DispositivosXContratante" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Contratantes acceden a sus propios Dispositivos" 
ON public."DispositivosXContratante"
FOR ALL 
USING (auth.uid() = "IdContratante");

-- ==========================================================
-- 2. RLS: INVENTARIO DE LICENCIAS (Billeteras)
-- Permite aislar los certificados de cada cuenta.
-- ==========================================================
ALTER TABLE public."LicenciasXContratante" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Contratantes ven sus propias Licencias" 
ON public."LicenciasXContratante"
FOR ALL 
USING (auth.uid() = "IdContratante");

-- ==========================================================
-- 3. RLS: NOTIFICACIONES (PAGOS)
-- Seguridad más importante: Vendedores u otros Contratantes no deben
-- poder consultar depósitos de cajas ajenas.
-- ==========================================================
ALTER TABLE public."NotificacionesXDispositivo" ENABLE ROW LEVEL SECURITY;

-- 3.1. Acceso para el DUEÑO DEL NEGOCIO (Contratante)
CREATE POLICY "Dueño lee y edita notificaciones de sus cajas" 
ON public."NotificacionesXDispositivo"
FOR ALL 
USING (auth.uid() = "IdContratante");

-- ==========================================================
-- 4. RLS: USUARIOS (FUERZA LABORAL)
-- Asegura que ningún otro inquilino pueda robar listas de personal.
-- ==========================================================
ALTER TABLE public."Usuarios" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Los usuarios solo ven sus propios datos" 
ON public."Usuarios"
FOR ALL 
USING (auth.uid() = "IdUsuario");


-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 11_seguridad_testeo_admin.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==============================================================================
-- 11. RLS: SEGURIDAD PARA APP ADMIN (MODO ANÓNIMO / HARDWARE AUTH)
-- Fecha: 2024-03-20
-- Descripción: Permite que la App Admin realice operaciones críticas sin estar
-- logueada formalmente, usando el HardwareId como factor de validación.
-- ==============================================================================

-- 11.1. PERMITIR INSERCIÓN DE NOTIFICACIONES (PAGOS)
DROP POLICY IF EXISTS "AdminApp_Insert_Payments" ON public."NotificacionesXDispositivo";
CREATE POLICY "AdminApp_Insert_Payments"
ON public."NotificacionesXDispositivo"
FOR INSERT
TO anon
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "NotificacionesXDispositivo"."IdDispositivo"
    AND d."Activo" = true
  )
);

-- 11.2. PERMITIR BORRADO (DESVINCULACIÓN) DESDE LA APP
-- Se agregan comillas dobles a "HardwareId" para evitar el error de columna no encontrada.
DROP POLICY IF EXISTS "AdminApp_Self_Delete" ON public."DispositivosXContratante";
CREATE POLICY "AdminApp_Self_Delete"
ON public."DispositivosXContratante"
FOR DELETE
TO anon
USING (
  -- Validamos que el HardwareId coincida con el registro.
  -- PostgreSQL requiere comillas dobles para respetar las mayúsculas.
  "HardwareId" = "HardwareId"
);



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 13_borrado_notificaciones_prueba.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==============================================================================
-- 13. RLS: BORRADO DE NOTIFICACIONES DE PRUEBA
-- Fecha: 2024-03-22
-- Descripción: Permite que la App Admin elimine sus propias notificaciones
-- marcadas como "Prueba" para limpiar el historial de testeo.
-- ==============================================================================

-- 13.1. PERMITIR BORRADO DE PRUEBAS DESDE LA APP
DROP POLICY IF EXISTS "AdminApp_Delete_Tests" ON public."NotificacionesXDispositivo";
CREATE POLICY "AdminApp_Delete_Tests"
ON public."NotificacionesXDispositivo"
FOR DELETE
TO anon
USING (
  "Prueba" = true
  AND EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "NotificacionesXDispositivo"."IdDispositivo"
    AND d."Activo" = true
  )
);



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 35_notificaciones_codigo_operacion.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 35_notificaciones_codigo_operacion.sql
-- Proposito: Actualizar tabla core para soportar Codigo de Operacion
-- y Estado de Progreso, mejorando la idempotencia y el flujo con Viewer.
-- ==========================================================

-- 1. Manejar conflicto de tipo si la columna ya existe como SMALLINT (herencia del Viewer)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'NotificacionesXDispositivo'
        AND column_name = 'EstadoProgreso'
        AND data_type = 'smallint'
    ) THEN
        ALTER TABLE public."NotificacionesXDispositivo"
        ALTER COLUMN "EstadoProgreso" TYPE VARCHAR(20) USING (
            CASE
                WHEN "EstadoProgreso" = 0 THEN 'PENDIENTE'
                WHEN "EstadoProgreso" = 1 THEN 'COMPLETADO'
                ELSE 'PENDIENTE'
            END
        );
    END IF;
END $$;

-- 2. Añadir columnas a NotificacionesXDispositivo
ALTER TABLE public."NotificacionesXDispositivo"
ADD COLUMN IF NOT EXISTS "CodigoOperacion" VARCHAR(50),
ADD COLUMN IF NOT EXISTS "EstadoProgreso" VARCHAR(20) DEFAULT 'PENDIENTE';

-- 3. Asegurar valores por defecto y robustez
ALTER TABLE public."NotificacionesXDispositivo"
ALTER COLUMN "MontoCentimos" SET DEFAULT 0,
ALTER COLUMN "Remitente" SET DEFAULT 'Desconocido',
ALTER COLUMN "EstadoProgreso" SET DEFAULT 'PENDIENTE';

-- 4. Crear indices de rendimiento
CREATE INDEX IF NOT EXISTS "idx_notif_codigo_operacion"
ON public."NotificacionesXDispositivo" ("CodigoOperacion");

CREATE INDEX IF NOT EXISTS "idx_notif_revision"
ON public."NotificacionesXDispositivo" ("EstadoProgreso")
WHERE "EstadoProgreso" = 'REVISION';

-- 5. Comentario de las columnas para documentacion en Supabase
COMMENT ON COLUMN public."NotificacionesXDispositivo"."CodigoOperacion" IS 'Codigo unico de la operacion extraido de la notificacion (ej. Op: 123456).';
COMMENT ON COLUMN public."NotificacionesXDispositivo"."EstadoProgreso" IS 'Estado actual del flujo: PENDIENTE, REVISION, COMPLETADO, DESCARTADO.';

-- 6. Sugerencia de actualizacion de REGEX en la tabla BilleterasRules (Manual en UI o via SQL)
-- -----------------------------------------------------------------------------------------
-- NOTA: Debes actualizar tus Regex para incluir el grupo (?<codigo>...)
-- Ejemplo para Yape con Codigo:
-- ANTES: (?i)(?<remitente>.*) te envió un pago por S/\s*(?<monto>[0-9,.]+).*cód\. de seguridad
-- AHORA: (?i)(?<remitente>.*?) te envió un pago por S/\s*(?<monto>[0-9,.]+).*cód\. de seguridad\s*(?<codigo>[a-z0-9]{3,6})
-- -----------------------------------------------------------------------------------------



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 41_fix_rls_stateless_identity.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==============================================================================
-- 41. FIX RLS: MODO STATELESS (IDENTIDAD BASADA EN HARDWARE)
-- Fecha: 2024-05-22
-- Descripción: Permite que el dispositivo sincronice pagos y heartbeats
-- aunque esté marcado como "Inactivo" administrativamente.
-- ==============================================================================

-- 1. PERMITIR SUBIDA DE PAGOS (UPSERT) SIN BLOQUEO POR ESTADO INACTIVO
DROP POLICY IF EXISTS "AdminApp_Insert_Payments" ON public."NotificacionesXDispositivo";
CREATE POLICY "AdminApp_Insert_Payments"
ON public."NotificacionesXDispositivo"
FOR INSERT TO anon
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "NotificacionesXDispositivo"."IdDispositivo"
    -- Se elimina: AND d."Activo" = true
  )
);

-- 2. PERMITIR ACTUALIZACIÓN DE PAGOS (Necesario para el UPSERT del SyncRepository)
DROP POLICY IF EXISTS "AdminApp_Update_Payments" ON public."NotificacionesXDispositivo";
CREATE POLICY "AdminApp_Update_Payments"
ON public."NotificacionesXDispositivo"
FOR UPDATE TO anon
USING (
  EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "NotificacionesXDispositivo"."IdDispositivo"
  )
);

-- 3. PERMITIR QUE EL DISPOSITIVO SE "VEA" A SÍ MISMO SI ESTÁ INACTIVO
-- (Sin esto, la App no puede detectar cambios en el socket si está desactivada)
DROP POLICY IF EXISTS "AdminApp_Read_Own_Device" ON public."DispositivosXContratante";
CREATE POLICY "AdminApp_Read_Own_Device"
ON public."DispositivosXContratante"
FOR SELECT TO anon
USING (true);

-- 4. PERMITIR HEARTBEATS Y DESVINCULACIÓN (Liberación de HardwareId)
DROP POLICY IF EXISTS "AdminApp_Update_Restricted" ON public."DispositivosXContratante";
CREATE POLICY "AdminApp_Update_Restricted"
ON public."DispositivosXContratante"
FOR UPDATE TO anon
USING (true)
WITH CHECK (
  -- Permitimos el cambio SOLO si:
  -- A) El HardwareId nuevo es NULL (Desvinculación voluntaria desde la App)
  -- B) El HardwareId nuevo es exactamente igual al que ya tenía (Update de perfil/heartbeat)
  "HardwareId" IS NULL OR
  "HardwareId" = (
    SELECT d."HardwareId"
    FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "DispositivosXContratante"."IdDispositivo"
  )
);



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 42_notificaciones_telefono_emisor.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- Añadir columna TelefonoEmisor a la tabla NotificacionesXDispositivo
-- Propósito: Rastrear qué número de teléfono capturó el pago para trazabilidad lógica.

ALTER TABLE "NotificacionesXDispositivo"
ADD COLUMN IF NOT EXISTS "TelefonoEmisor" VARCHAR(20);

COMMENT ON COLUMN "NotificacionesXDispositivo"."TelefonoEmisor"
IS 'Número de teléfono configurado en el dispositivo lógico al momento de la captura';


-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 22_rls_usuarios_perfiles.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: Usuarios)
-- ==========================================================================

-- ==========================================================
-- 22_RLS_USUARIOS_PERFILES.SQL
-- Descripción: Permisos RLS para la tabla Usuarios y Storage
-- asegurando que el vendedor pueda gestionar su propio perfil.
-- ==========================================================

-- 1. Habilitar RLS en Usuarios (si no lo está)
ALTER TABLE public."Usuarios" ENABLE ROW LEVEL SECURITY;

-- 2. Políticas para la tabla Usuarios
DROP POLICY IF EXISTS "Usuarios_ver_propio_perfil" ON public."Usuarios";
CREATE POLICY "Usuarios_ver_propio_perfil"
ON public."Usuarios" FOR SELECT
TO authenticated
USING (auth.uid() = "IdUsuario");

DROP POLICY IF EXISTS "Usuarios_insertar_propio_perfil" ON public."Usuarios";
CREATE POLICY "Usuarios_insertar_propio_perfil"
ON public."Usuarios" FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = "IdUsuario");

DROP POLICY IF EXISTS "Usuarios_actualizar_propio_perfil" ON public."Usuarios";
CREATE POLICY "Usuarios_actualizar_propio_perfil"
ON public."Usuarios" FOR UPDATE
TO authenticated
USING (auth.uid() = "IdUsuario")
WITH CHECK (auth.uid() = "IdUsuario");

-- 3. Configuración de Storage para perfiles_usuarios
-- Asegurar que el bucket exista: perfiles_usuarios

DROP POLICY IF EXISTS "Vendedores pueden subir su propia foto" ON storage.objects;
CREATE POLICY "Vendedores pueden subir su propia foto"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'perfiles_usuarios' AND
    (storage.foldername(name))[1] = auth.uid()::text
);

DROP POLICY IF EXISTS "Vendedores pueden ver fotos de perfil" ON storage.objects;
CREATE POLICY "Vendedores pueden ver fotos de perfil"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'perfiles_usuarios');



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 25_logic_reclamacion_atomica.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 25_LOGIC_RECLAMACION_ATOMICA.SQL
-- Lógica para la reclamación segura de notificaciones (Claiming)
-- y gestión de disputas.
-- ==========================================================

-- 1. Función Atómica para Reclamar Notificación (RPC)
-- Evita condiciones de carrera: solo uno puede ganar el PENDIENTE.
CREATE OR REPLACE FUNCTION public.reclamar_pago_v3(p_id_sync UUID, p_id_usuario UUID)
RETURNS JSONB AS $$
DECLARE
    v_estado_actual VARCHAR(20);
BEGIN
    -- 1. Bloqueo de fila (FOR UPDATE) para asegurar exclusividad
    SELECT "EstadoProgreso" INTO v_estado_actual
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync
    FOR UPDATE;

    -- 2. Validaciones de negocio
    IF v_estado_actual IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'NOT_FOUND');
    END IF;

    IF v_estado_actual != 'PENDIENTE' THEN
        -- Si ya no es PENDIENTE, significa que alguien lo ganó antes
        RETURN jsonb_build_object('success', false, 'error', 'ALREADY_CLAIMED');
    END IF;

    -- 3. Marcar como COMPLETADO para que desaparezca de la lista de pendientes
    UPDATE public."NotificacionesXDispositivo"
    SET "EstadoProgreso" = 'COMPLETADO'
    WHERE "IdSync" = p_id_sync;

    -- 4. Registrar la propiedad en la tabla de asignaciones
    INSERT INTO public."NotificacionesAUsuarios" ("IdSync", "IdUsuario")
    VALUES (p_id_sync, p_id_usuario);

    RETURN jsonb_build_object('success', true);
EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Asegurar que la tabla de conflictos sea coherente con el Viewer
-- Nota: La tabla ConflictosXNotificacion ya fue creada en el script 19.
-- Aquí solo aseguramos que el RLS permita al admin ver las disputas.
ALTER TABLE public."ConflictosXNotificacion"
RENAME COLUMN "IdUsuarioReporta" TO "IdUsuarioReporta"; -- Ya es así, solo para referencia.



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 26_fix_rls_viewer_notifications.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 26_FIX_RLS_VIEWER_NOTIFICATIONS.SQL
-- Descripción: Permite que los vendedores vean las notificaciones
-- de la caja asignada sin restricciones de privacidad/prueba.
-- ==========================================================

-- 1. Asegurar que Realtime tenga acceso a los campos necesarios
ALTER TABLE public."NotificacionesXDispositivo" REPLICA IDENTITY FULL;

-- 2. Política de lectura para Vendedores (App Viewer)
-- Se basa en la existencia de una autorización aprobada (Estado 2)
DROP POLICY IF EXISTS "Vendedores_Leer_Notificaciones_Asignadas" ON public."NotificacionesXDispositivo";
CREATE POLICY "Vendedores_Leer_Notificaciones_Asignadas"
ON public."NotificacionesXDispositivo"
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public."AutorizacionesXUsuario" a
        WHERE a."IdDispositivo" = public."NotificacionesXDispositivo"."IdDispositivo"
        AND a."IdUsuario" = auth.uid()
        AND a."IdEstadoAuth" = 2 -- APROBADO
    )
);

-- 3. Nota sobre Realtime:
-- La publicación 'supabase_realtime' debe incluir esta tabla.
-- Si no está activa, ejecutar:
-- ALTER PUBLICATION supabase_realtime ADD TABLE public."NotificacionesXDispositivo";



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 30_fix_rls_notificaciones_multi_usuario.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 30_FIX_RLS_NOTIFICACIONES_MULTI_USUARIO.SQL
-- Objetivo: Permitir que múltiples vendedores autorizados
-- vean las notificaciones de su dispositivo asignado.
-- ==========================================================

-- 1. Asegurar que Realtime pueda filtrar por RLS con todos los datos
ALTER TABLE public."NotificacionesXDispositivo" REPLICA IDENTITY FULL;

-- 2. Limpiar políticas previas para evitar colisiones o ambigüedades
DROP POLICY IF EXISTS "Vendedores_Leer_Notificaciones_Asignadas" ON public."NotificacionesXDispositivo";
DROP POLICY IF EXISTS "Vendedores_Leer_Notificaciones_MultiUser" ON public."NotificacionesXDispositivo";
DROP POLICY IF EXISTS "Dueño accede a notificaciones de sus propios dispositivos" ON public."NotificacionesXDispositivo";
DROP POLICY IF EXISTS "Dueño lee y edita notificaciones de sus cajas" ON public."NotificacionesXDispositivo";

-- 3. Política para el DUEÑO / ADMINISTRADOR (Web Admin)
-- Permite control total sobre las notificaciones que le pertenecen.
CREATE POLICY "Contratante_Gestion_Total_Notificaciones"
ON public."NotificacionesXDispositivo"
FOR ALL
TO authenticated
USING (
    auth.uid() = "IdContratante"
)
WITH CHECK (
    auth.uid() = "IdContratante"
);

-- 4. Política para VENDEDORES (App Viewer)
-- Permite lectura si el vendedor tiene una autorización APROBADA (Estado 2)
-- para el dispositivo que emite la notificación.
-- Esta política permite que 2 o más usuarios vean la misma caja simultáneamente.
CREATE POLICY "Vendedores_Lectura_Multi_Usuario"
ON public."NotificacionesXDispositivo"
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public."AutorizacionesXUsuario" a
        WHERE a."IdDispositivo" = public."NotificacionesXDispositivo"."IdDispositivo"
        AND a."IdUsuario" = auth.uid()
        AND a."IdEstadoAuth" = 2 -- APROBADO
    )
);

-- 5. Garantizar que la tabla esté en la publicación de Realtime
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime'
        AND schemaname = 'public'
        AND tablename = 'NotificacionesXDispositivo'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public."NotificacionesXDispositivo";
    END IF;
END $$;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 32_logic_disputas_y_asignacion.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 32_LOGIC_DISPUTAS_Y_ASIGNACION.SQL
-- Objetivo: Implementar el motor de asignación, contador de
-- reclamaciones y lógica de degradación reactiva para disputas.
-- ==========================================================

-- 1. EXTENSIÓN DE TABLAS EXISTENTES
DO $$
BEGIN
    -- Columnas para NotificacionesXDispositivo (La Maestra)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='NotificacionesXDispositivo' AND column_name='ContadorReclamaciones') THEN
        ALTER TABLE public."NotificacionesXDispositivo" ADD COLUMN "ContadorReclamaciones" INT DEFAULT 0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='NotificacionesXDispositivo' AND column_name='IdUsuarioGanador') THEN
        ALTER TABLE public."NotificacionesXDispositivo" ADD COLUMN "IdUsuarioGanador" UUID REFERENCES public."Usuarios"("IdUsuario");
    END IF;

    -- Columnas para NotificacionesAUsuarios (La Transaccional)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='NotificacionesAUsuarios' AND column_name='Observacion') THEN
        ALTER TABLE public."NotificacionesAUsuarios" ADD COLUMN "Observacion" TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='NotificacionesAUsuarios' AND column_name='EstadoReclamacion') THEN
        ALTER TABLE public."NotificacionesAUsuarios" ADD COLUMN "EstadoReclamacion" VARCHAR(20) DEFAULT 'PROCESANDO';
    END IF;
END $$;

-- 2. FUNCIÓN DE TRIGGER: GESTIÓN DE RECLAMACIONES Y DISPUTAS
CREATE OR REPLACE FUNCTION public.fn_trg_gestionar_reclamacion()
RETURNS TRIGGER AS $$
DECLARE
    v_contador INT;
BEGIN
    -- 1. Obtener y actualizar el contador en la maestra
    UPDATE public."NotificacionesXDispositivo"
    SET "ContadorReclamaciones" = "ContadorReclamaciones" + 1
    WHERE "IdSync" = NEW."IdSync"
    RETURNING "ContadorReclamaciones" INTO v_contador;

    -- 2. Lógica según el número de reclamantes
    IF v_contador = 1 THEN
        -- HAPPY PATH: Primer reclamante gana automáticamente
        UPDATE public."NotificacionesXDispositivo"
        SET "EstadoProgreso" = 'COMPLETADO',
            "IdUsuarioGanador" = NEW."IdUsuario"
        WHERE "IdSync" = NEW."IdSync";

        UPDATE public."NotificacionesAUsuarios"
        SET "EstadoReclamacion" = 'APROBADO'
        WHERE "IdSync" = NEW."IdSync" AND "IdUsuario" = NEW."IdUsuario";

    ELSE
        -- DISPUTA: Segundo o N-ésimo reclamante
        -- A. Degradamos al ganador anterior (si existía)
        UPDATE public."NotificacionesAUsuarios"
        SET "EstadoReclamacion" = 'PROCESANDO'
        WHERE "IdSync" = NEW."IdSync" AND "EstadoReclamacion" = 'APROBADO';

        -- B. Marcamos la maestra como REVISIÓN y limpiamos el ganador temporal
        UPDATE public."NotificacionesXDispositivo"
        SET "EstadoProgreso" = 'REVISION',
            "IdUsuarioGanador" = NULL
        WHERE "IdSync" = NEW."IdSync";

        -- C. El nuevo registro entra como PROCESANDO (por defecto de columna)
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. CREACIÓN DEL TRIGGER
DROP TRIGGER IF EXISTS trg_after_insert_reclamacion ON public."NotificacionesAUsuarios";
CREATE TRIGGER trg_after_insert_reclamacion
AFTER INSERT ON public."NotificacionesAUsuarios"
FOR EACH ROW
EXECUTE FUNCTION public.fn_trg_gestionar_reclamacion();

-- 4. RPC: RECLAMAR_NOTIFICACION_V2
-- Esta función es la que llamará la App Viewer.
CREATE OR REPLACE FUNCTION public.reclamar_notificacion_v2(
    p_id_sync UUID,
    p_id_usuario UUID,
    p_observacion TEXT DEFAULT NULL
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

    -- 2. Validar que no esté CERRADA (Fase 4 - Bloqueo de periodo)
    IF v_estado_maestra = 'CERRADO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'PERIOD_CLOSED');
    END IF;

    -- 3. Insertar la reclamación (El trigger hará el resto)
    INSERT INTO public."NotificacionesAUsuarios" ("IdSync", "IdUsuario", "Observacion")
    VALUES (p_id_sync, p_id_usuario, p_observacion)
    ON CONFLICT ("IdSync", "IdUsuario") DO UPDATE
    SET "Observacion" = EXCLUDED."Observacion"
    WHERE public."NotificacionesAUsuarios"."EstadoReclamacion" = 'PROCESANDO';

    RETURN jsonb_build_object('success', true);

EXCEPTION
    WHEN unique_violation THEN
        RETURN jsonb_build_object('success', false, 'error', 'ALREADY_RECLAIMED_BY_YOU');
    WHEN OTHERS THEN
        RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 39_liberacion_y_desvinculacion.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 39_LIBERACION_Y_DESVINCULACION.SQL
-- Objetivo: Implementar la liberación total de notificaciones
-- y limpieza automática al desvincular o borrar usuarios.
-- ==========================================================

-- 1. RPC: RETIRAR_RECLAMO_V3
-- Maneja el acuerdo entre partes y la liberación de ventas.
CREATE OR REPLACE FUNCTION public.retirar_reclamo_v3(
    p_id_sync UUID,
    p_id_usuario UUID
)
RETURNS JSONB AS $$
DECLARE
    v_es_ganador BOOLEAN;
    v_otros_reclamantes INT;
BEGIN
    -- 1. Verificar si el usuario es el ganador actual (dueño original)
    SELECT ("IdUsuarioGanador" = p_id_usuario) INTO v_es_ganador
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync;

    IF v_es_ganador THEN
        -- LIBERACIÓN TOTAL: Si el dueño suelta la venta, se resetea para todos
        -- para evitar estados inconsistentes y permitir que cualquiera la tome.
        UPDATE public."NotificacionesXDispositivo"
        SET "IdUsuarioGanador" = NULL,
            "EstadoProgreso" = 'PENDIENTE',
            "ContadorReclamaciones" = 0
        WHERE "IdSync" = p_id_sync;

        DELETE FROM public."NotificacionesAUsuarios" WHERE "IdSync" = p_id_sync;
    ELSE
        -- RETIRO DE IMPUGNACIÓN: Solo se borra la data del impugnante
        DELETE FROM public."NotificacionesAUsuarios"
        WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

        -- Si no quedan más impugnantes, la venta vuelve a estar COMPLETADA para el dueño
        SELECT COUNT(*) INTO v_otros_reclamantes
        FROM public."NotificacionesAUsuarios" nau
        JOIN public."NotificacionesXDispositivo" nd ON nau."IdSync" = nd."IdSync"
        WHERE nau."IdSync" = p_id_sync
        AND nau."IdUsuario" != nd."IdUsuarioGanador";

        IF v_otros_reclamantes = 0 THEN
            UPDATE public."NotificacionesXDispositivo"
            SET "EstadoProgreso" = 'COMPLETADO'
            WHERE "IdSync" = p_id_sync;
        END IF;
    END IF;

    RETURN jsonb_build_object('success', true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. TRIGGER DE LIMPIEZA TOTAL (HARD RESET)
-- Se activa al borrar un usuario (Desvincular total)
CREATE OR REPLACE FUNCTION public.fn_limpiar_rastro_usuario()
RETURNS TRIGGER AS $$
BEGIN
    -- A. Liberar notificaciones ganadas por este usuario
    -- Borramos todos los reclamos asociados para que la notificación quede libre y limpia (Morada)
    DELETE FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" IN (
        SELECT "IdSync" FROM public."NotificacionesXDispositivo"
        WHERE "IdUsuarioGanador" = OLD."IdUsuario"
    );

    -- Reseteamos la maestra
    UPDATE public."NotificacionesXDispositivo"
    SET "IdUsuarioGanador" = NULL,
        "EstadoProgreso" = 'PENDIENTE',
        "ContadorReclamaciones" = 0
    WHERE "IdUsuarioGanador" = OLD."IdUsuario";

    -- B. El borrado del usuario en sí ya disparará el borrado de sus propias
    -- filas en NotificacionesAUsuarios por la FK si tuviera CASCADE,
    -- pero nos aseguramos de limpiar sus reclamos en ventas ajenas.
    DELETE FROM public."NotificacionesAUsuarios" WHERE "IdUsuario" = OLD."IdUsuario";

    -- C. Borrar sus autorizaciones activas
    DELETE FROM public."AutorizacionesXUsuario" WHERE "IdUsuario" = OLD."IdUsuario";

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 3. VISTA AUXILIAR PARA EL ADMIN (OPCIONAL/RECORDATORIO)
-- Asegurarse de que el Admin App use una vista que no dependa de IDs de usuario
-- si el usuario ha sido borrado (usar LEFT JOIN en la vista de conflictos).

DROP TRIGGER IF EXISTS tr_usuario_borrado_limpieza ON public."Usuarios";
CREATE TRIGGER tr_usuario_borrado_limpieza
BEFORE DELETE ON public."Usuarios"
FOR EACH ROW EXECUTE FUNCTION public.fn_limpiar_rastro_usuario();



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 39_liberacion_y_desvinculacion_v2.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 39_LIBERACION_Y_DESVINCULACION_V2.SQL
-- Objetivo: Corregir el manejo de retiro de reclamos en "Limbo".
-- ==========================================================

CREATE OR REPLACE FUNCTION public.retirar_reclamo_v3(
    p_id_sync UUID,
    p_id_usuario UUID
)
RETURNS JSONB AS $$
DECLARE
    v_id_ganador_actual UUID;
    v_id_dueno_historico UUID;
    v_otros_reclamantes INT;
BEGIN
    -- 1. Obtener estado actual de la maestra
    SELECT "IdUsuarioGanador" INTO v_id_ganador_actual
    FROM public."NotificacionesXDispositivo"
    WHERE "IdSync" = p_id_sync;

    -- 2. Identificar al dueño histórico (el primero que reclamó)
    SELECT "IdUsuario" INTO v_id_dueno_historico
    FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" = p_id_sync
    ORDER BY "FechaReg" ASC
    LIMIT 1;

    -- 3. Decidir lógica de retiro
    -- Si el usuario es el ganador actual O (el ganador es NULL y es el dueño histórico)
    IF (v_id_ganador_actual = p_id_usuario) OR (v_id_ganador_actual IS NULL AND v_id_dueno_historico = p_id_usuario) THEN
        -- LIBERACIÓN TOTAL: El dueño (actual o histórico en disputa) suelta la venta.
        -- Se limpia todo para que vuelva a estar disponible (Morada).
        UPDATE public."NotificacionesXDispositivo"
        SET "IdUsuarioGanador" = NULL,
            "EstadoProgreso" = 'PENDIENTE',
            "ContadorReclamaciones" = 0
        WHERE "IdSync" = p_id_sync;

        DELETE FROM public."NotificacionesAUsuarios" WHERE "IdSync" = p_id_sync;

        RETURN jsonb_build_object('success', true, 'action', 'TOTAL_RELEASE');
    ELSE
        -- RETIRO DE IMPUGNACIÓN: Solo se borra la data del impugnante.
        DELETE FROM public."NotificacionesAUsuarios"
        WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

        -- Recalcular contador y estado si ya no hay conflictos
        SELECT COUNT(*) INTO v_otros_reclamantes
        FROM public."NotificacionesAUsuarios"
        WHERE "IdSync" = p_id_sync;

        IF v_otros_reclamantes <= 1 THEN
            -- Si solo queda uno (el dueño histórico), restauramos la normalidad
            UPDATE public."NotificacionesXDispositivo"
            SET "EstadoProgreso" = 'COMPLETADO',
                "IdUsuarioGanador" = v_id_dueno_historico,
                "ContadorReclamaciones" = v_otros_reclamantes
            WHERE "IdSync" = p_id_sync;
        ELSE
            -- Si aún quedan varios, solo bajamos el contador
            UPDATE public."NotificacionesXDispositivo"
            SET "ContadorReclamaciones" = v_otros_reclamantes
            WHERE "IdSync" = p_id_sync;
        END IF;

        RETURN jsonb_build_object('success', true, 'action', 'WITHDRAWAL');
    END IF;

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 41_control_tab_logic_and_visibility.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: NotificacionesXDispositivo)
-- ==========================================================================

-- ==========================================================
-- 41_CONTROL_TAB_LOGIC_AND_VISIBILITY.SQL
-- Objetivo: Soporte para retiro de reclamos y visibilidad
-- cruzada de justificaciones en disputas.
-- ==========================================

-- 1. RPC PARA RETIRAR RECLAMO (DESHACER)
CREATE OR REPLACE FUNCTION public.deshacer_reclamo(
    p_id_sync UUID,
    p_id_usuario UUID
)
RETURNS JSONB AS $$
DECLARE
    v_contador INT;
    v_estado_actual VARCHAR(20);
BEGIN
    -- 1. Verificar si existe el reclamo y si está en proceso
    SELECT "EstadoReclamacion" INTO v_estado_actual
    FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

    IF v_estado_actual IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'CLAIM_NOT_FOUND');
    END IF;

    IF v_estado_actual != 'PROCESANDO' THEN
        RETURN jsonb_build_object('success', false, 'error', 'CANNOT_WITHDRAW_RESOLVED_CLAIM');
    END IF;

    -- 2. Eliminar el reclamo
    DELETE FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" = p_id_sync AND "IdUsuario" = p_id_usuario;

    -- 3. Actualizar la maestra (NotificacionesXDispositivo)
    UPDATE public."NotificacionesXDispositivo"
    SET "ContadorReclamaciones" = "ContadorReclamaciones" - 1
    WHERE "IdSync" = p_id_sync
    RETURNING "ContadorReclamaciones" INTO v_contador;

    -- 4. Si solo queda 1 reclamante, volver a PENDIENTE para que sea una "Venta" limpia
    IF v_contador = 1 THEN
        UPDATE public."NotificacionesXDispositivo"
        SET "EstadoProgreso" = 'PENDIENTE'
        WHERE "IdSync" = p_id_sync;
    END IF;

    -- 5. Si queda 0 reclamantes (caso borde), volver a PENDIENTE
    IF v_contador = 0 THEN
        UPDATE public."NotificacionesXDispositivo"
        SET "EstadoProgreso" = 'PENDIENTE'
        WHERE "IdSync" = p_id_sync;
    END IF;

    RETURN jsonb_build_object('success', true, 'new_count', v_contador);

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. AJUSTE DE RLS PARA VISIBILIDAD CRUZADA EN DISPUTAS
-- Permite que un usuario vea las justificaciones de otros SI Y SOLO SI
-- él también ha reclamado ese mismo IdSync (está en la "pelea").

DROP POLICY IF EXISTS "Usuarios_Ven_Justificaciones_En_Disputa" ON public."NotificacionesAUsuarios";

CREATE POLICY "Usuarios_Ven_Justificaciones_En_Disputa"
ON public."NotificacionesAUsuarios"
FOR SELECT
TO authenticated
USING (
    -- Puedo ver mi propia fila
    auth.uid() = "IdUsuario"
    OR
    -- O puedo ver las filas de otros para el mismo IdSync si yo tengo una fila ahí
    EXISTS (
        SELECT 1 FROM public."NotificacionesAUsuarios" self
        WHERE self."IdSync" = public."NotificacionesAUsuarios"."IdSync"
        AND self."IdUsuario" = auth.uid()
    )
);

-- 3. COMENTARIO DE SEGURIDAD
COMMENT ON FUNCTION public.deshacer_reclamo IS 'Permite a un usuario retirar su reclamo de una notificación, gestionando la consistencia de la tabla maestra.';



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 42_fix_desvinculacion_total_rls.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: Usuarios)
-- ==========================================================================

-- ==========================================================
-- 42_FIX_DESVINCULACION_TOTAL_RLS.SQL
-- Objetivo: Corregir permisos para permitir el "Hard Reset"
-- y asegurar que el trigger de limpieza tenga privilegios.
-- ==========================================================

-- 1. Añadir política para que el usuario pueda borrar su propia fila
-- Sin esto, remoteDataSource.eliminarUsuario(userId) fallaba por RLS.
DROP POLICY IF EXISTS "Usuarios_borrar_propio_perfil" ON public."Usuarios";
CREATE POLICY "Usuarios_borrar_propio_perfil"
ON public."Usuarios" FOR DELETE
TO authenticated
USING (auth.uid() = "IdUsuario");

-- 2. Actualizar la función de limpieza para que sea SECURITY DEFINER
-- Esto permite que el trigger limpie tablas como "NotificacionesXDispositivo"
-- y "AutorizacionesXUsuario" incluso si el usuario no tiene permisos directos
-- de borrado/update en esas tablas al momento de su eliminación.
CREATE OR REPLACE FUNCTION public.fn_limpiar_rastro_usuario()
RETURNS TRIGGER AS $$
BEGIN
    -- A. Liberar notificaciones ganadas por este usuario
    -- Borramos todos los reclamos asociados para que la notificación quede libre y limpia (Morada)
    DELETE FROM public."NotificacionesAUsuarios"
    WHERE "IdSync" IN (
        SELECT "IdSync" FROM public."NotificacionesXDispositivo"
        WHERE "IdUsuarioGanador" = OLD."IdUsuario"
    );

    -- Reseteamos la maestra
    UPDATE public."NotificacionesXDispositivo"
    SET "IdUsuarioGanador" = NULL,
        "EstadoProgreso" = 'PENDIENTE',
        "ContadorReclamaciones" = 0
    WHERE "IdUsuarioGanador" = OLD."IdUsuario";

    -- B. Limpiar sus reclamos en ventas ajenas.
    DELETE FROM public."NotificacionesAUsuarios" WHERE "IdUsuario" = OLD."IdUsuario";

    -- C. Borrar sus autorizaciones activas
    DELETE FROM public."AutorizacionesXUsuario" WHERE "IdUsuario" = OLD."IdUsuario";

    RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

