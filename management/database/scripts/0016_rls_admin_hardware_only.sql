-- =============================================================================
-- 23_rls_admin_hardware_only.sql
-- SQL actual para la app web (versión simple):
-- 1) Lectura de catálogo Billeteras/FiltrosXBilletera para authenticated.
-- 2) Insert/Select/Update en BilleterasXDispositivo para el dueño del dispositivo.
-- =============================================================================

BEGIN;

-- -----------------------------------------------------------------------------
-- A) BILLETERAS DISPONIBLES EN WEB (ROL AUTHENTICATED)
-- -----------------------------------------------------------------------------
-- Fuerza RLS activo en Billeteras (si ya estaba activo, no cambia nada).
ALTER TABLE public."Billeteras" ENABLE ROW LEVEL SECURITY;
-- Fuerza RLS activo en FiltrosXBilletera (si ya estaba activo, no cambia nada).
ALTER TABLE public."FiltrosXBilletera" ENABLE ROW LEVEL SECURITY;
-- Fuerza RLS activo en relación de billeteras por dispositivo.
ALTER TABLE public."BilleterasXDispositivo" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "WebAuth lee filtros de billeteras" ON public."FiltrosXBilletera";
CREATE POLICY "WebAuth lee filtros de billeteras"
ON public."FiltrosXBilletera"
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "WebAuth lee billeteras con filtros" ON public."Billeteras";
CREATE POLICY "WebAuth lee billeteras con filtros"
ON public."Billeteras"
FOR SELECT
TO authenticated
USING (
	EXISTS (
		SELECT 1
		FROM public."FiltrosXBilletera" f
		WHERE f."IdBilletera" = public."Billeteras"."IdBilletera"
	)
);

-- -----------------------------------------------------------------------------
-- B) CONFIGURACION DE BILLETERAS POR DISPOSITIVO EN WEB (ROL AUTHENTICATED)
-- -----------------------------------------------------------------------------
DROP POLICY IF EXISTS "WebAuth inserta billeteras de sus dispositivos" ON public."BilleterasXDispositivo";
CREATE POLICY "WebAuth inserta billeteras de sus dispositivos"
ON public."BilleterasXDispositivo"
FOR INSERT
TO authenticated
WITH CHECK (
	EXISTS (
		SELECT 1
		FROM public."DispositivosXContratante" d
		WHERE d."IdDispositivo"::text = public."BilleterasXDispositivo"."IdDispositivo"::text
			AND d."IdContratante"::text = auth.uid()::text
	)
);

DROP POLICY IF EXISTS "WebAuth lee billeteras de sus dispositivos" ON public."BilleterasXDispositivo";
CREATE POLICY "WebAuth lee billeteras de sus dispositivos"
ON public."BilleterasXDispositivo"
FOR SELECT
TO authenticated
USING (
	EXISTS (
		SELECT 1
		FROM public."DispositivosXContratante" d
		WHERE d."IdDispositivo"::text = public."BilleterasXDispositivo"."IdDispositivo"::text
			AND d."IdContratante"::text = auth.uid()::text
	)
);

DROP POLICY IF EXISTS "WebAuth edita billeteras de sus dispositivos" ON public."BilleterasXDispositivo";
CREATE POLICY "WebAuth edita billeteras de sus dispositivos"
ON public."BilleterasXDispositivo"
FOR UPDATE
TO authenticated
USING (
	EXISTS (
		SELECT 1
		FROM public."DispositivosXContratante" d
		WHERE d."IdDispositivo"::text = public."BilleterasXDispositivo"."IdDispositivo"::text
			AND d."IdContratante"::text = auth.uid()::text
	)
)
WITH CHECK (
	EXISTS (
		SELECT 1
		FROM public."DispositivosXContratante" d
		WHERE d."IdDispositivo"::text = public."BilleterasXDispositivo"."IdDispositivo"::text
			AND d."IdContratante"::text = auth.uid()::text
	)
);

COMMIT;
