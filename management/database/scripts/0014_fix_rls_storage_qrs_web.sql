-- ==============================================================================
-- 19. FIX RLS: SEGURIDAD PARA STORAGE WEB (Bucket: billeteras_qrs)
-- Descripción: Modifica las políticas originales de subida y actualización
-- que estaban limitadas solo al rol 'anon'. Ahora se asignan a 'public' 
-- (que abarca tanto a 'anon' para la App como a 'authenticated' para la Web),
-- permitiendo que ambos ecosistemas compartan las mismas reglas.
-- ==============================================================================

-- 19.1 Reemplazar política de subida para abarcar a todos
DROP POLICY IF EXISTS "App Admin puede subir QRs" ON storage.objects;
CREATE POLICY "App Admin puede subir QRs"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'billeteras_qrs');

-- 19.2 Reemplazar política de actualización para abarcar a todos
DROP POLICY IF EXISTS "App Admin puede actualizar sus QRs" ON storage.objects;
CREATE POLICY "App Admin puede actualizar sus QRs"
ON storage.objects
FOR UPDATE
TO public
USING (bucket_id = 'billeteras_qrs');
