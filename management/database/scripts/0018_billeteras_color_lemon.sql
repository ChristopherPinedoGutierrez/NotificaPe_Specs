-- ==============================================================================
-- SCRIPT DE MIGRACIÓN: 0018_billeteras_color_lemon
-- App Origen: Proyecto General (Orquestador SDD)
-- Autor: AGENT_ROLE
-- Fecha: 2026-07-26
-- Justificación: Agregar campo de color dinámico y soporte para billetera Lemon
-- ==============================================================================

-- 1. Añadir columna ColorHex a la tabla Billeteras
ALTER TABLE public."Billeteras"
ADD COLUMN "ColorHex" varchar(7);

-- 2. Asignar colores a las billeteras existentes
UPDATE public."Billeteras" SET "ColorHex" = '#8A2387' WHERE "Nombre" = 'Yape';
UPDATE public."Billeteras" SET "ColorHex" = '#00B44C' WHERE "Nombre" LIKE 'Plin%';

-- 3. Insertar la billetera Lemon Cash
INSERT INTO public."Billeteras" ("IdBilletera", "PackageName", "Nombre", "ColorHex") 
VALUES (5, 'com.applemoncash', 'Lemon', '#10C267')
ON CONFLICT ("IdBilletera") DO UPDATE SET "PackageName" = EXCLUDED."PackageName", "Nombre" = EXCLUDED."Nombre", "ColorHex" = EXCLUDED."ColorHex";

-- (Reajustar secuencia)
SELECT setval(pg_get_serial_sequence('public."Billeteras"', 'IdBilletera'), (SELECT MAX("IdBilletera") FROM public."Billeteras"));
