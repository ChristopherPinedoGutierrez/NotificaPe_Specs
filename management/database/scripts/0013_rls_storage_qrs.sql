-- ==============================================================================
-- 18. RLS: SEGURIDAD PARA STORAGE (Bucket: billeteras_qrs)
-- Fecha: 2024-05-24
-- Descripción: Permite la subida, actualización y lectura de códigos QR.
-- ==============================================================================

-- 18.1. Permitir que cualquier usuario (anon/App Admin) suba su QR
-- Nota: La seguridad real reside en que el nombre del archivo incluya el DeviceId.
DROP POLICY IF EXISTS "App Admin puede subir QRs" ON storage.objects;
CREATE POLICY "App Admin puede subir QRs"
ON storage.objects
FOR INSERT
TO anon
WITH CHECK (bucket_id = 'billeteras_qrs');

-- 18.2. Permitir actualización (Upsert)
DROP POLICY IF EXISTS "App Admin puede actualizar sus QRs" ON storage.objects;
CREATE POLICY "App Admin puede actualizar sus QRs"
ON storage.objects
FOR UPDATE
TO anon
USING (bucket_id = 'billeteras_qrs');

-- 18.3. Permitir lectura pública de los QRs
-- Esto es vital para que la App Viewer y el Panel Web vean la imagen sin tokens.
DROP POLICY IF EXISTS "QRs son publicos para lectura" ON storage.objects;
CREATE POLICY "QRs son publicos para lectura"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'billeteras_qrs');

-- 18.4. Permitir borrado (Cleanup)
DROP POLICY IF EXISTS "App Admin puede borrar sus QRs" ON storage.objects;
CREATE POLICY "App Admin puede borrar sus QRs"
ON storage.objects
FOR DELETE
TO public
USING (bucket_id = 'billeteras_qrs');


-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 29_storage_perfiles_usuarios.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: storage)
-- ==========================================================================

-- ==========================================
-- BUCKET: perfiles_usuarios
-- Propósito: Almacenar fotos de perfil de los vendedores (Viewer App)
-- Estructura: /id_usuario/id_usuario_profile.jpg
-- ==========================================

-- 1. Crear el bucket si no existe
INSERT INTO storage.buckets (id, name, public)
VALUES ('perfiles_usuarios', 'perfiles_usuarios', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Habilitar RLS en la tabla de objetos (si no estuviera ya)
-- ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- 3. POLÍTICA: Lectura Pública
-- Permite que cualquier persona (o al menos otros usuarios del ecosistema) vean las fotos
CREATE POLICY "Perfil_Public_Read"
ON storage.objects FOR SELECT
USING (bucket_id = 'perfiles_usuarios');

-- 4. POLÍTICA: Inserción Propia
-- Permite que un usuario autenticado suba archivos SOLO a su propia carpeta
CREATE POLICY "Perfil_Insert_Own_Folder"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'perfiles_usuarios' AND
    (storage.foldername(name))[1] = auth.uid()::text
);

-- 5. POLÍTICA: Actualización Propia
-- Permite que un usuario autenticado reemplace archivos SOLO en su propia carpeta
CREATE POLICY "Perfil_Update_Own_Folder"
ON storage.objects FOR UPDATE
TO authenticated
USING (
    bucket_id = 'perfiles_usuarios' AND
    (storage.foldername(name))[1] = auth.uid()::text
)
WITH CHECK (
    bucket_id = 'perfiles_usuarios' AND
    (storage.foldername(name))[1] = auth.uid()::text
);

-- 6. POLÍTICA: Borrado Propio
CREATE POLICY "Perfil_Delete_Own_Folder"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'perfiles_usuarios' AND
    (storage.foldername(name))[1] = auth.uid()::text
);

