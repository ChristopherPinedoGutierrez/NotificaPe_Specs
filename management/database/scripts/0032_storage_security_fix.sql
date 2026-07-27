-- Script: 0032_storage_security_fix.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE
-- Fecha: 2026-07-26
-- Justificación: Fix de vulnerabilidad en bucket público (listado de archivos). Se elimina política genérica SELECT y se añade RPC de limpieza de huérfanos.

BEGIN;

-- 1. Eliminar políticas SELECT peligrosas del bucket perfiles_usuarios
DROP POLICY IF EXISTS "Vendedores pueden ver fotos de perfil" ON storage.objects;
DROP POLICY IF EXISTS "Perfil_Public_Read" ON storage.objects;

-- 2. Crear función RPC para limpiar archivos huérfanos antes de subir nueva foto
CREATE OR REPLACE FUNCTION public.limpiar_storage_perfil(p_user_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    DELETE FROM storage.objects 
    WHERE bucket_id = 'perfiles_usuarios' 
    AND (storage.foldername(name))[1] = p_user_id::text;
END;
$$;

GRANT EXECUTE ON FUNCTION public.limpiar_storage_perfil(UUID) TO authenticated;

COMMIT;
