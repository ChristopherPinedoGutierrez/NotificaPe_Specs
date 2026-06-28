-- ==============================================================================
-- 32_deprecate_ordenes_compra.sql
-- Script para eliminar la tabla legacy OrdenesCompra y actualizar Onboarding
-- ==============================================================================

BEGIN;

-- 1. Eliminar la relación de la tabla LicenciasXContratante
-- Nota: Si el nombre de la constraint difiere en tu base de datos, cámbialo aquí.
-- 'LicenciasXContratante_NumeroOrden_fkey' es el nombre por defecto generado por Postgres.
ALTER TABLE public."LicenciasXContratante" 
  DROP CONSTRAINT IF EXISTS "LicenciasXContratante_NumeroOrden_fkey";

-- 2. Eliminar la función vieja de asignación
DROP FUNCTION IF EXISTS public.asignar_licencia_contratante(UUID, SMALLINT, VARCHAR);

-- 3. Eliminar políticas RLS de la tabla
DROP POLICY IF EXISTS "Contratantes dueños de sus propias Ordenes" ON public."OrdenesCompra";

-- 4. Eliminar la tabla OrdenesCompra completamente
DROP TABLE IF EXISTS public."OrdenesCompra" CASCADE;

COMMIT;
