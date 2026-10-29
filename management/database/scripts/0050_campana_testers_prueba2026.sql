-- ==============================================================================
-- SCRIPT: 0050_campana_testers_prueba2026.sql
-- App Origen: web
-- Autor: Senior Architect / Antigravity
-- Fecha: 2026-10-28
-- Justificación: Creación de la campaña promocional exclusiva para evaluadores de
--                la fase Beta (Código: PRUEBA2026) con bono manual de S/ 20.00
--                y límite estricto de 50 cupos para completar el beneficio de
--                1 mes gratis del Plan Comerciante (S/ 50.00) en conjunto con
--                el Bono de Bienvenida (S/ 20) y el Bono de Invitado (S/ 10).
-- ==============================================================================

INSERT INTO public."CampanasPromocionales" (
    "TipoEvento",
    "Nombre",
    "MontoInvitado",
    "MontoAnfitrion",
    "UsosMaximos",
    "UsosActuales",
    "CodigoTexto",
    "Estado",
    "FechaInicio",
    "FechaFin"
)
SELECT 
    'MANUAL',
    'Bono Evaluadores Beta (Prueba 2026)',
    20,
    0,
    50,
    0,
    'PRUEBA2026',
    'ACTIVA',
    NOW(),
    '2027-01-01 04:59:59+00'
WHERE NOT EXISTS (
    SELECT 1 FROM public."CampanasPromocionales"
    WHERE "TipoEvento" = 'MANUAL' AND "CodigoTexto" = 'PRUEBA2026'
);
