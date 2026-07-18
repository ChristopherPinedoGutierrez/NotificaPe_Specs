-- Script: 0030_legal_and_superadmin
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-07-17
-- Justificación: Eliminación de tablas huérfanas. Creación de infraestructura para Superadministradores y Libro de Reclamaciones con generador de códigos correlativos y políticas RLS para garantizar el cumplimiento legal y la seguridad operativa de la consola de administración.

-- 1. Eliminación de tablas huérfanas
DROP TABLE IF EXISTS public."ConflictosXNotificacion" CASCADE;
DROP TABLE IF EXISTS public."DisputasNotificaciones" CASCADE;

-- 2. Creación de la tabla Superadministradores
CREATE TABLE IF NOT EXISTS public."Superadministradores" (
    "IdSuperadmin" UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    "Correo" VARCHAR(100) UNIQUE NOT NULL,
    "FechaCreacion" TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);

-- 3. Políticas RLS para Superadministradores
ALTER TABLE public."Superadministradores" ENABLE ROW LEVEL SECURITY;

-- Política de lectura: Solo permite leer su propio registro al superadministrador autenticado para validar permisos
CREATE POLICY "Permitir validacion de lectura de superadmin" 
    ON public."Superadministradores"
    FOR SELECT 
    USING (auth.uid() = "IdSuperadmin");

-- (No se añaden políticas de INSERT, UPDATE o DELETE por seguridad. Se deben administrar vía dashboard de Supabase o SQL directo por el root).

-- 4. Creación de la tabla Reclamaciones
CREATE TABLE IF NOT EXISTS public."Reclamaciones" (
    "IdReclamacion" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "CodigoReclamacion" VARCHAR(50) UNIQUE,
    "IdContratante" UUID REFERENCES public."Contratantes"("IdContratante") ON DELETE SET NULL,
    "NombreCompleto" VARCHAR(150) NOT NULL,
    "TipoDocumento" VARCHAR(20) NOT NULL,
    "NumeroDocumento" VARCHAR(20) NOT NULL,
    "Correo" VARCHAR(100) NOT NULL,
    "Telefono" VARCHAR(20) NOT NULL,
    "TipoReclamacion" VARCHAR(20) NOT NULL,
    "DetalleReclamacion" TEXT NOT NULL,
    "PedidoCliente" TEXT NOT NULL,
    "Estado" VARCHAR(20) DEFAULT 'PENDIENTE' NOT NULL,
    "Respuesta" TEXT,
    "FechaRegistro" TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    "FechaRespuesta" TIMESTAMP WITH TIME ZONE
);

-- 5. Función PL/pgSQL y Trigger para autogenerar CodigoReclamacion
CREATE OR REPLACE FUNCTION public.generar_codigo_reclamacion()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    fecha_str VARCHAR(8);
    consecutivo INT;
BEGIN
    -- Formato YYYYMMDD
    fecha_str := to_char(NEW."FechaRegistro", 'YYYYMMDD');
    
    -- Obtener el conteo de registros para el mismo día para asegurar secuencia
    SELECT COUNT(*) + 1 INTO consecutivo
    FROM public."Reclamaciones"
    WHERE to_char("FechaRegistro", 'YYYYMMDD') = fecha_str;

    -- Generar el código final: R-YYYYMMDD-XXXX
    NEW."CodigoReclamacion" := 'R-' || fecha_str || '-' || lpad(consecutivo::text, 4, '0');
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_generar_codigo_reclamacion
    BEFORE INSERT ON public."Reclamaciones"
    FOR EACH ROW
    EXECUTE FUNCTION public.generar_codigo_reclamacion();

-- 6. Políticas RLS para Reclamaciones
ALTER TABLE public."Reclamaciones" ENABLE ROW LEVEL SECURITY;

-- Inserción: Pública (cualquier usuario anónimo puede registrar una queja desde el Landing)
CREATE POLICY "Permitir insercion publica"
    ON public."Reclamaciones"
    FOR INSERT
    WITH CHECK (true);

-- Lectura: Solo para superadministradores
CREATE POLICY "Permitir lectura de superadmins"
    ON public."Reclamaciones"
    FOR SELECT
    USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));

-- Actualización: Solo para superadministradores (para registrar estado y respuesta)
CREATE POLICY "Permitir actualizacion a superadmins"
    ON public."Reclamaciones"
    FOR UPDATE
    USING (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()))
    WITH CHECK (EXISTS (SELECT 1 FROM public."Superadministradores" WHERE "IdSuperadmin" = auth.uid()));
