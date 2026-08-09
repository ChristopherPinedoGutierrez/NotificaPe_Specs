-- ==========================================
-- Script: 0037_filtros_v2_exclusiones_agora.sql
-- App Origen: db
-- Autor: Antigravity
-- Fecha: 2026-08-09
-- Justificación: 
-- 1. Eliminación de la billetera inactiva Agora y limpieza de llave foránea.
-- 2. Inyección de reglas de Inclusión V2 para las billeteras V1 restantes y la nueva billetera Prexpe.
-- 3. Creación de 6 reglas de Exclusión V2 categorizadas para Yape.
-- ==========================================

BEGIN;

-- 1. Hard Delete de Agora (IdBilletera = 7) y sus dependencias
DELETE FROM public."BilleterasXDispositivo" WHERE "IdBilletera" = 7;
DELETE FROM public."FiltrosXBilletera" WHERE "IdBilletera" = 7;
DELETE FROM public."Billeteras" WHERE "IdBilletera" = 7;


-- 2. Inyección de Filtros de Inclusión (V2)
-- Plin Interbank (IdBilletera = 2)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (2, 'Plin Interbank Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>[^\[\]]+?)\s+te ha plineado S/\s*(?<monto>[0-9,.]+)', '[TITLE] Plin [TEXT] Juan Perez te ha plineado S/ 25.00. [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- Plin BBVA (IdBilletera = 3)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (3, 'Plin BBVA Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>[^\[\]]+?)\s+te ha plineado S/\s*(?<monto>[0-9,.]+)', '[TITLE] Plin [TEXT] Raul Gomez te ha plineado S/ 45.00. [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- Plin Scotiabank (IdBilletera = 4)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (4, 'Plin Scotiabank Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>[^\[\]]+?)\s+te ha plineado S/\s*(?<monto>[0-9,.]+)', '[TITLE] Plin [TEXT] Fernando Ramos te ha plineado S/ 15.00. [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- Sip (IdBilletera = 6)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (6, 'Sip Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>Usuario de Sip)\s+te ha enviado\s+(?<monto>[0-9.,]+)', '[TITLE] Sip [TEXT] Usuario de Sip te ha enviado 16.00 [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- Bim (IdBilletera = 8)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (8, 'Bim Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>Usuario de Bim)\s+te ha enviado\s+(?<monto>[0-9.,]+)', '[TITLE] Bim [TEXT] Usuario de Bim te ha enviado 18.00 [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- BiPay (IdBilletera = 9)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (9, 'BiPay Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>Usuario de BiPay)\s+te ha enviado\s+(?<monto>[0-9.,]+)', '[TITLE] BiPay [TEXT] Usuario de BiPay te ha enviado 19.80 [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- Plin BanBif (IdBilletera = 10)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (10, 'Plin BanBif Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>Usuario de Plin BanBif)\s+te ha enviado\s+(?<monto>[0-9.,]+)', '[TITLE] Plin [TEXT] Usuario de Plin BanBif te ha enviado 20.10 [SUBTEXT]', 'INCLUSION', '{text}', 2);

-- Prexpe (IdBilletera = 11) - Nueva
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES (11, 'Prexpe Estándar V2', '(?i)\[TEXT\]\s*(?<remitente>Usuario de Prexpe)\s+te ha enviado\s+(?<monto>[0-9.,]+)', '[TITLE] Prexpe [TEXT] Usuario de Prexpe te ha enviado 20.00 [SUBTEXT]', 'INCLUSION', '{text}', 2);


-- 3. Inyección de Filtros de Exclusión Yape (V2) (IdBilletera = 1)
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock", "TipoFiltro", "FormatoMensaje", "VersionMotor") 
VALUES 
(1, 'Yape Exclusión - Pagos Salientes', '(?i)(tu pago en)', 'Tu pago en BETANO fue exitoso', 'EXCLUSION', '{text}', 2),
(1, 'Yape Exclusión - Pago de Servicios', '(?i)(pago .*? pendiente|recibo|servicios próximos a vencer)', 'Tienes un pago de Claro pendiente', 'EXCLUSION', '{text}', 2),
(1, 'Yape Exclusión - Créditos y Préstamos', '(?i)(crédito|\¿sin dinero)', '¡No dejes pasar tu Crédito!', 'EXCLUSION', '{text}', 2),
(1, 'Yape Exclusión - Promociones y Comida', '(?i)(yape promos|yape gaming|recarga diamantes|pollo a la brasa|pizza|burger|chicken fingers|norky|papa johns|cinestar|cine star|oxxo|pepsi|huarique)', '1 pollo a la brasa + papas fritas', 'EXCLUSION', '{text}', 2),
(1, 'Yape Exclusión - Sorteos y Afiliaciones', '(?i)(sorteo|participa por|afiliándote|dinero más seguro|bonos y enlaces)', 'Gana hasta S/3,000 afiliándote', 'EXCLUSION', '{text}', 2),
(1, 'Yape Exclusión - Avisos de Sistema', '(?i)(crear una cuenta|actualízala|tu hij@|sueños|extranjero)', 'Actualízala dando click aquí', 'EXCLUSION', '{text}', 2);

COMMIT;
