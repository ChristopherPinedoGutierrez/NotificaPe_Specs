-- Script: 0041_actualizar_precios_addons.sql
-- App Origen: NotificaPe_Specs / db
-- Autor: AGENT_ROLE (Orquestador SDD / Arquitecto Principal)
-- Fecha: 2026-09-03
-- Justificación: Actualización de tarifas de addons (S/ 30.00 por dispositivo extra y S/ 20.00 por usuario extra) en catálogo de licencias.

BEGIN;

UPDATE public."Licencias"
   SET "PrecioExtraDispositivoCentimos" = 3000,
       "PrecioExtraUsuarioCentimos" = 2000
 WHERE "PermiteAddons" = TRUE;

COMMIT;
