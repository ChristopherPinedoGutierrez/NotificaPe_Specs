-- ==============================================================================
-- MIGRACIÓN: CONFIGURACIÓN DE BORRADO EN CASCADA / SET NULL EN LICENCIAS
-- Archivo: 41_upgrade_cascade_delete_licencias.sql
-- Descripción: 
--   - Modifica las restricciones de clave foránea que apuntan a la tabla "Licencias".
--   - Permite borrar planes físicos en el catálogo desde la interfaz de Supabase 
--     sin violar restricciones de integridad referencial.
--   - Configura:
--       * LicenciasXContratante: ON DELETE SET NULL (para mantener historial sin romper la cuenta).
--       * LicenciasCola: ON DELETE CASCADE (limpia colas programadas de este plan).
--       * TransaccionesXLicencia: ON DELETE SET NULL (conserva registros históricos).
-- ==============================================================================

BEGIN;

-- 1. Actualizar clave foránea en la tabla LicenciasXContratante
--    Si se elimina el plan, el IdLicencia del historial pasa a NULL.
--    El usuario quedará "Sin plan activo" en la UI pero su registro histórico no se borra.
ALTER TABLE public."LicenciasXContratante"
  DROP CONSTRAINT IF EXISTS "LicenciasXContratante_IdLicencia_fkey",
  ADD CONSTRAINT "LicenciasXContratante_IdLicencia_fkey"
    FOREIGN KEY ("IdLicencia") REFERENCES public."Licencias"("IdLicencia")
    ON DELETE SET NULL;

-- 2. Actualizar clave foránea en la tabla LicenciasCola
--    Si se elimina el plan, se eliminan las colas programadas de ese plan.
ALTER TABLE public."LicenciasCola"
  DROP CONSTRAINT IF EXISTS "LicenciasCola_IdLicencia_fkey",
  ADD CONSTRAINT "LicenciasCola_IdLicencia_fkey"
    FOREIGN KEY ("IdLicencia") REFERENCES public."Licencias"("IdLicencia")
    ON DELETE CASCADE;

-- 3. Actualizar claves foráneas en la tabla TransaccionesXLicencia
--    Si se elimina el plan, los campos IdLicenciaOrigen y IdLicenciaDestino pasan a NULL
--    para mantener el ledger de auditoría financiera intacto.
ALTER TABLE public."TransaccionesXLicencia"
  DROP CONSTRAINT IF EXISTS "TransaccionesXLicencia_IdLicenciaOrigen_fkey",
  ADD CONSTRAINT "TransaccionesXLicencia_IdLicenciaOrigen_fkey"
    FOREIGN KEY ("IdLicenciaOrigen") REFERENCES public."Licencias"("IdLicencia")
    ON DELETE SET NULL,
  DROP CONSTRAINT IF EXISTS "TransaccionesXLicencia_IdLicenciaDestino_fkey",
  ADD CONSTRAINT "TransaccionesXLicencia_IdLicenciaDestino_fkey"
    FOREIGN KEY ("IdLicenciaDestino") REFERENCES public."Licencias"("IdLicencia")
    ON DELETE SET NULL;

COMMIT;
