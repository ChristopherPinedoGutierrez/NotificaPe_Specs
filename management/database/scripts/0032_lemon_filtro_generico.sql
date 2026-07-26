-- =============================================================================
-- Script: 0032_lemon_filtro_generico.sql
-- App Origen: Specs / DB Global
-- Autor: AGENT_ROLE
-- Fecha: 2026-07-26
-- Justificación: Registro de regla Regex genérica inicial para la billetera Lemon (IdBilletera: 5)
--                permitiendo que aparezca listada en las aplicaciones client/web para asignación a dispositivos.
-- =============================================================================

INSERT INTO "FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock")
VALUES (5, 'Lemon Estándar (Generico)', '(?i)(?<remitente>.*?) te envió S/\s*(?<monto>[0-9.,]+)', 'Usuario Lemon te envió S/ 10.00.');
