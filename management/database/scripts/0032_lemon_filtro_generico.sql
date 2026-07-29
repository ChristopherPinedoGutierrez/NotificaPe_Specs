-- =============================================================================
-- Script: 0032_lemon_filtro_generico.sql
-- App Origen: Specs / DB Global
-- Autor: AGENT_ROLE
-- Fecha: 2026-07-26
-- Justificación: Registro de regla Regex genérica inicial para la billetera Lemon (IdBilletera: 5)
--                permitiendo que aparezca listada en las aplicaciones client/web para asignación a dispositivos.
-- =============================================================================

INSERT INTO "FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock")
VALUES (5, 'Lemon Estándar (Generico)', '(?i)Recibiste S/\s*(?<monto>[0-9.,]+).*?(?<remitente>.*?)\s+te envió dinero.*', 'Recibiste S/ 10.00 🙌 - Usuario Lemon te envió dinero. Ya lo puedes encontrar en tu cuenta.');
