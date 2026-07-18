-- =====================================================================
-- SCRIPT: utilidades_superadmin.sql
-- PROYECTO: NotificaPe
-- AUTOR: AGENT_ROLE (Arquitecto de Software Principal)
-- FECHA: 2026-07-17
-- JUSTIFICACIÓN: Facilitar la gestión de superadministradores mediante
--                consultas SQL directas buscando por correo electrónico,
--                evitando la manipulación manual de UUIDs en producción.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. AGREGAR UN SUPERADMINISTRADOR
--    Reemplace 'correo@ejemplo.com' con el email de Google del usuario.
-- ---------------------------------------------------------------------
-- INSERT INTO public."Superadministradores" ("IdSuperadmin", "Correo")
-- SELECT id, email FROM auth.users WHERE email = 'correo@ejemplo.com'
-- ON CONFLICT ("IdSuperadmin") DO NOTHING;


-- ---------------------------------------------------------------------
-- 2. QUITAR UN SUPERADMINISTRADOR
--    Reemplace 'correo@ejemplo.com' con el email del usuario a remover.
-- ---------------------------------------------------------------------
-- DELETE FROM public."Superadministradores"
-- WHERE "IdSuperadmin" IN (
--   SELECT id FROM auth.users WHERE email = 'correo@ejemplo.com'
-- );


-- ---------------------------------------------------------------------
-- 3. LISTAR TODOS LOS SUPERADMINISTRADORES ACTIVOS
--    Lista correos, nombres de contratante (si existen) y fechas de alta.
-- ---------------------------------------------------------------------
-- SELECT 
--   sa."IdSuperadmin" AS "UID",
--   u.email AS "Correo",
--   c."Nombre" AS "NombreContratante",
--   sa."CreadoEn" AS "FechaAlta"
-- FROM public."Superadministradores" sa
-- JOIN auth.users u ON sa."IdSuperadmin" = u.id
-- LEFT JOIN public."Contratantes" c ON sa."IdSuperadmin" = c."IdContratante";
