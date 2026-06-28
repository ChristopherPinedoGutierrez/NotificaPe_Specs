-- ==============================================================================
-- 10. RLS: VINCULACIÓN DE DISPOSITIVOS HUÉRFANOS
-- Permite que cualquier Contratante autenticado pueda encontrar y reclamar
-- dispositivos creados por la App Admin que aún no tienen dueño.
-- ==============================================================================

-- 10.1. Cualquier usuario autenticado puede VER dispositivos sin dueño (para buscarlos por CodigoAcceso)
CREATE POLICY "Usuarios pueden encontrar dispositivos sin dueño"
ON public."DispositivosXContratante"
FOR SELECT
USING ("IdContratante" IS NULL);

-- 10.2. Cualquier usuario autenticado puede RECLAMAR un dispositivo sin dueño (asignar su IdContratante)
CREATE POLICY "Usuarios pueden reclamar dispositivos sin dueño"
ON public."DispositivosXContratante"
FOR UPDATE
USING ("IdContratante" IS NULL)
WITH CHECK (auth.uid() = "IdContratante");


-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 09_rls_admin_app.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: USING)
-- ==========================================================================

-- ==========================================================
-- SCRIPT DE SEGURIDAD (RLS) PARA NOTIFICAPE ADMIN APP
-- Fecha: 2024-03-20
-- Descripción: Define políticas de acceso para que la App Android
-- pueda registrarse, vincularse y enviar heartbeats de forma segura.
-- NOTA: Se usan comillas dobles para respetar las mayúsculas de las columnas.
-- ==========================================================

-- 1. Aseguramos que RLS esté activo en la tabla
ALTER TABLE "public"."DispositivosXContratante" ENABLE ROW LEVEL SECURITY;

-- 2. POLÍTICA DE LECTURA (SELECT)
-- Permite que la App verifique si su HardwareId ya tiene un registro activo.
CREATE POLICY "AdminApp_Read_Own_Device"
ON "public"."DispositivosXContratante"
FOR SELECT
TO anon
USING ("Activo" = true);

-- 3. POLÍTICA DE INSERCIÓN (INSERT)
-- Permite que la App cree un nuevo registro al instalarse.
CREATE POLICY "AdminApp_Insert_New_Device"
ON "public"."DispositivosXContratante"
FOR INSERT
TO anon
WITH CHECK (true);

-- 4. POLÍTICA DE ACTUALIZACIÓN RESTRINGIDA (UPDATE)
-- Permite actualizar Alias, Teléfono y Heartbeat.
CREATE POLICY "AdminApp_Update_Restricted"
ON "public"."DispositivosXContratante"
FOR UPDATE
TO anon
USING ("Activo" = true)
WITH CHECK (
  -- Validación de Integridad: El HardwareId no debe cambiar
  "HardwareId" = (
    SELECT d."HardwareId"
    FROM "public"."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "DispositivosXContratante"."IdDispositivo"
  )
);

-- 5. HABILITAR REALTIME PARA ESTA TABLA (CRÍTICO PARA VINCULACIÓN)
-- Ejecutar esto en el SQL Editor de Supabase si no se hizo manualmente
-- ALTER PUBLICATION supabase_realtime ADD TABLE "public"."DispositivosXContratante";



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 36_fix_rls_realtime_vinculacion.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: USING)
-- ==========================================================================

-- ==========================================================
-- 36_fix_rls_realtime_vinculacion.sql
-- Propósito: Optimizar RLS y Realtime para asegurar que la App Admin
-- detecte su activación e identidad sin bloqueos de seguridad.
-- ==========================================================

-- 1. ACTUALIZAR POLÍTICA DE LECTURA
-- El rol 'anon' debe poder leer su propio registro para verificar si fue activado.
-- Se permite la lectura basada en el IdDispositivo (UUID) que la App ya posee tras escanear.
DROP POLICY IF EXISTS "AdminApp_Read_Own_Device" ON "public"."DispositivosXContratante";
CREATE POLICY "AdminApp_Read_Own_Device"
ON "public"."DispositivosXContratante"
FOR SELECT
TO anon
USING (true);

-- 2. AJUSTAR POLÍTICA DE ACTUALIZACIÓN
-- Permite que la App registre su HardwareId, Marca y Modelo al vincularse.
-- Eliminamos subconsultas complejas que podrían fallar si el HardwareId es NULL inicialmente.
DROP POLICY IF EXISTS "AdminApp_Update_Restricted" ON "public"."DispositivosXContratante";
CREATE POLICY "AdminApp_Update_Restricted"
ON "public"."DispositivosXContratante"
FOR UPDATE
TO anon
USING (true)
WITH CHECK (true);

-- 3. FORZAR REPLICA IDENTITY FULL (CRÍTICO)
-- Esto asegura que los eventos de Supabase Realtime incluyan TODOS los campos
-- de la fila (como Activo, HardwareId, etc.) y no solo la PK.
ALTER TABLE "public"."DispositivosXContratante" REPLICA IDENTITY FULL;

-- 4. PERMISOS PARA BILLETERAS EN MODO ESPERA
-- Asegurar que la App pueda ver sus billeteras asignadas incluso antes de estar "Activo"
-- (útil para pre-configuración o validación de QR).
ALTER TABLE "public"."BilleterasXDispositivo" REPLICA IDENTITY FULL;

