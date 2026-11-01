-- ==============================================================================
-- SCRIPT: 0051_lemon_v3_y_exclusiones.sql
-- App Origen: Specs / DB Global
-- Autor: Senior Architect / Antigravity
-- Fecha: 2026-10-31
-- Justificación: 
-- 1. Registro oficial y homologación de regla de inclusión V2 'Lemon Estándar V3'
--    para transferencias P2P entre usuarios Lemon ($lemontag y moneda PEN).
-- 2. Incorporación de 5 reglas de exclusión V2 para la billetera Lemon (IdBilletera: 5)
--    para descartar en el dispositivo cashback QR, 2FA, compras con tarjeta débito,
--    declinaciones por fondos insuficientes y notificaciones promocionales.
-- ==============================================================================

BEGIN;

-- 1. Regla de Inclusión V3: Transferencias Lemon P2P ($lemontag)
INSERT INTO public."FiltrosXBilletera" (
    "IdBilletera", 
    "NombreRegla", 
    "RegexContenido", 
    "MensajeMock", 
    "TipoFiltro", 
    "FormatoMensaje", 
    "VersionMotor"
) 
SELECT 
    5, 
    'Lemon Estándar V3', 
    '(?i)\[TITLE\]\s*Recibiste\s+(?<monto>[0-9.,]+)\s*PEN.*?\\[TEXT\\]\s*De\s+(?<remitente>\$[^\\[\\]\s]+)', 
    '[TITLE] Recibiste 1 PEN 🤑 [TEXT] De $usuario [SUBTEXT] ', 
    'INCLUSION', 
    '{title} - {text}', 
    2
WHERE NOT EXISTS (
    SELECT 1 FROM public."FiltrosXBilletera" WHERE "NombreRegla" = 'Lemon Estándar V3'
);

-- Actualizar mensaje mock y formato si ya existía sin ellos
UPDATE public."FiltrosXBilletera"
SET 
    "MensajeMock" = '[TITLE] Recibiste 1 PEN 🤑 [TEXT] De $usuario [SUBTEXT] ',
    "FormatoMensaje" = '{title} - {text}'
WHERE "NombreRegla" = 'Lemon Estándar V3';


-- 2. Reglas de Exclusión Lemon (IdBilletera = 5)

-- A. Cashback y Recompensas Satoshis
INSERT INTO public."FiltrosXBilletera" (
    "IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor"
) 
SELECT 
    5, 
    'Lemon Exclusión - Cashback y Recompensas', 
    '(?i)(ganaste bitcoin|satoshis de cashback|cashback en btc)', 
    '[TITLE] Ganaste Bitcoin por pagar con QR [TEXT] Recibiste 10 satoshis de cashback.', 
    'EXCLUSION', 
    '{text}', 
    2
WHERE NOT EXISTS (
    SELECT 1 FROM public."FiltrosXBilletera" WHERE "NombreRegla" = 'Lemon Exclusión - Cashback y Recompensas'
);

-- B. Códigos de Seguridad y Autorización 2FA
INSERT INTO public."FiltrosXBilletera" (
    "IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor"
) 
SELECT 
    5, 
    'Lemon Exclusión - Códigos de Autorización', 
    '(?i)(código de autorización|tu codigo es:\s*[0-9]+)', 
    '[TITLE] Código de autorización [TEXT] Tu codigo es: 668143. Nadie de Lemon Cash te va a pedir esta info.', 
    'EXCLUSION', 
    '{text}', 
    2
WHERE NOT EXISTS (
    SELECT 1 FROM public."FiltrosXBilletera" WHERE "NombreRegla" = 'Lemon Exclusión - Códigos de Autorización'
);

-- C. Pagos Salientes y Consumos con Tarjeta Débito
INSERT INTO public."FiltrosXBilletera" (
    "IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor"
) 
SELECT 
    5, 
    'Lemon Exclusión - Consumos con Tarjeta', 
    '(?i)(pagaste .*? pen en|le sacaste jugo a tu lemon card)', 
    '[TITLE] Pagaste 29,19 PEN en Vivanda 💳 [TEXT] Le sacaste jugo a tu Lemon Card.', 
    'EXCLUSION', 
    '{text}', 
    2
WHERE NOT EXISTS (
    SELECT 1 FROM public."FiltrosXBilletera" WHERE "NombreRegla" = 'Lemon Exclusión - Consumos con Tarjeta'
);

-- D. Fondos Insuficientes y Fallos de Débito
INSERT INTO public."FiltrosXBilletera" (
    "IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor"
) 
SELECT 
    5, 
    'Lemon Exclusión - Fallos y Fondos Insuficientes', 
    '(?i)(fondos insuficientes|tarjeta no está disponible|débito automático .*? falló)', 
    '[TITLE] Fondos insuficientes ❌ [TEXT] Tu débito automático falló.', 
    'EXCLUSION', 
    '{text}', 
    2
WHERE NOT EXISTS (
    SELECT 1 FROM public."FiltrosXBilletera" WHERE "NombreRegla" = 'Lemon Exclusión - Fallos y Fondos Insuficientes'
);

-- E. Noticias, Promociones y Avisos de Mercado
INSERT INTO public."FiltrosXBilletera" (
    "IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor"
) 
SELECT 
    5, 
    'Lemon Exclusión - Noticias y Promociones', 
    '(?i)(google cae|bitcoin superó|acciones sin horarios|sorteamos|lemon news|renta fija|participa por|sube brasil|con lemon, algo vuelve|exprime tu tarjeta)', 
    '[TITLE] Google cae 11% 📉 [TEXT] Puedes comprar acciones desde S/ 4.', 
    'EXCLUSION', 
    '{text}', 
    2
WHERE NOT EXISTS (
    SELECT 1 FROM public."FiltrosXBilletera" WHERE "NombreRegla" = 'Lemon Exclusión - Noticias y Promociones'
);

COMMIT;
