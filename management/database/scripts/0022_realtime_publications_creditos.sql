-- ==============================================================================
-- 31_realtime_publications_creditos.sql
-- Habilita la publicación de eventos Realtime para las nuevas tablas de licencias
-- ==============================================================================

BEGIN;

-- 1. Habilitar publicación Realtime en las tablas (Idempotente)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'LicenciasXContratante') THEN
        EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE public."LicenciasXContratante"';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'CreditoXContratante') THEN
        EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE public."CreditoXContratante"';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'LicenciasCola') THEN
        EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE public."LicenciasCola"';
    END IF;
END
$$;

-- 2. Asegurar que existan políticas de lectura (SELECT) para los dueños
-- (El realtime solo emite eventos al cliente si la tabla tiene RLS activado y el
-- usuario tiene permisos SELECT sobre las filas modificadas).

-- Asegurar RLS activo
ALTER TABLE public."LicenciasXContratante" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."CreditoXContratante" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."LicenciasCola" ENABLE ROW LEVEL SECURITY;

-- Políticas de lectura (ignoramos si ya existen usando DO block)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Contratante puede ver sus licencias' AND tablename = 'LicenciasXContratante') THEN
        CREATE POLICY "Contratante puede ver sus licencias" ON public."LicenciasXContratante" FOR SELECT TO authenticated USING ("IdContratante" = auth.uid());
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Contratante puede ver su credito' AND tablename = 'CreditoXContratante') THEN
        CREATE POLICY "Contratante puede ver su credito" ON public."CreditoXContratante" FOR SELECT TO authenticated USING ("IdContratante" = auth.uid());
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Contratante puede ver su cola' AND tablename = 'LicenciasCola') THEN
        CREATE POLICY "Contratante puede ver su cola" ON public."LicenciasCola" FOR SELECT TO authenticated USING ("IdContratante" = auth.uid());
    END IF;
END
$$;

COMMIT;
