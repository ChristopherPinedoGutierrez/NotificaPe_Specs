-- Script: 0033_storage_select_fix.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE
-- Fecha: 2026-07-26
-- Justificación: Fix de RLS al subir imágenes. El flag upsert=true de Supabase requiere permisos SELECT sobre el propio archivo para verificar si existe antes de intentar insertarlo/actualizarlo. Al borrar la política general previa, se rompió este mecanismo. Se añade política restrictiva.

BEGIN;

CREATE POLICY "Perfil_Select_Own_Folder" ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'perfiles_usuarios' AND (storage.foldername(name))[1] = auth.uid()::text
);

COMMIT;
