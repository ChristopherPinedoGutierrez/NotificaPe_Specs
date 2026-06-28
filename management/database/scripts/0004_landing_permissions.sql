-- ==========================================================
-- 5. RLS: LICENCIAS (Catálogo Comercial)
-- Permite que lectores anónimos (visitantes del Landing Page)
-- puedan consultar los planes vigentes.
-- ==========================================================

-- Aseguramos que RLS está activo (por seguridad general)
ALTER TABLE public."Licencias" ENABLE ROW LEVEL SECURITY;

-- Permitimos que CUALQUIERA pueda hacer SELECT de los planes activos
CREATE POLICY "Permitir lectura publica de catalogo de Licencias" 
ON public."Licencias"
FOR SELECT 
USING (true);
