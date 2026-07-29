-- Script: 0034_filtros_genericos_nuevas_billeteras.sql
-- Descripción: Insertar filtros genéricos para nuevas billeteras sin configuración para pruebas.
-- Autor: AI Agent
-- Fecha: 2026-07-28
-- Justificación: Añadir configuración base temporal a billeteras agregadas recientemente.

INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido", "MensajeMock") VALUES
(6, 'Sip Estándar', '(?i)(?<remitente>Usuario de Sip)\s+te ha enviado\s+(?<monto>[0-9.,]+)', 'Usuario de Sip te ha enviado 16.00'),
(7, 'Agora Estándar', '(?i)(?<remitente>Usuario de Agora)\s+te ha enviado\s+(?<monto>[0-9.,]+)', 'Usuario de Agora te ha enviado 17.50'),
(8, 'Bim Estándar', '(?i)(?<remitente>Usuario de Bim)\s+te ha enviado\s+(?<monto>[0-9.,]+)', 'Usuario de Bim te ha enviado 18.00'),
(9, 'BiPay Estándar', '(?i)(?<remitente>Usuario de BiPay)\s+te ha enviado\s+(?<monto>[0-9.,]+)', 'Usuario de BiPay te ha enviado 19.80'),
(10, 'Plin BanBif Estándar', '(?i)(?<remitente>Usuario de Plin BanBif)\s+te ha enviado\s+(?<monto>[0-9.,]+)', 'Usuario de Plin BanBif te ha enviado 20.10');
