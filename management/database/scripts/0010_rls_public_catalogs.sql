-- ==============================================================================
-- 12. RLS: ACCESO PÚBLICO A CATÁLOGOS (BILLETERAS Y REGLAS)
-- Fecha: 2024-04-14
-- Descripción: Permite que la App Admin descargue las configuraciones de
-- billeteras y reglas de filtrado sin necesidad de autenticación previa.
-- ==============================================================================

-- 12.1. TABLA: Billeteras
ALTER TABLE public."Billeteras" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Lectura pública Billeteras" ON public."Billeteras";
CREATE POLICY "Lectura pública Billeteras"
ON public."Billeteras"
FOR SELECT
TO anon
USING (true);

-- 12.2. TABLA: FiltrosXBilletera
ALTER TABLE public."FiltrosXBilletera" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Lectura pública Filtros" ON public."FiltrosXBilletera";
CREATE POLICY "Lectura pública Filtros"
ON public."FiltrosXBilletera"
FOR SELECT
TO anon
USING (true);
