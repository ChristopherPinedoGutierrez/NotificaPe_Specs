-- ==============================================================================
-- SCRIPT DE DATOS SEMILLA: LICENCIAS Y PAQUETES (WOOCOMMERCE)
-- Proyecto: NotificaPe
-- Tabla: public."Licencias"
-- Nota: Los precios están en céntimos (Ej: S/ 40.00 = 4000)
-- ==============================================================================

INSERT INTO public."Licencias" 
("Nombre", "LimiteDispositivos", "LimiteUsuarios", "PrecioCentimos", "Moneda", "DuracionDias", "SkuExterno", "Activo") 
VALUES 
-- ==========================================
-- 0. PLAN TRIAL (Oculto en tienda, usado por Triggers)
-- ==========================================
('Prueba - 7 Días', 1, 3, 0, 'PEN', 7, 'TRIAL-7D', TRUE),

-- ==========================================
-- 1. LICENCIA EMPRENDEDOR (1 Dispositivo, 3 Usuarios)
-- Base Mensual: S/ 40.00
-- ==========================================
('Emprendedor - 1 Mes', 1, 3, 4000, 'PEN', 30, 'EMP-1M', TRUE),
('Emprendedor - 3 Meses', 1, 3, 10500, 'PEN', 90, 'EMP-3M', TRUE),      -- Ahorro ~12% (S/ 35/mes)
('Emprendedor - 6 Meses', 1, 3, 18000, 'PEN', 180, 'EMP-6M', TRUE),     -- Ahorro 25% (S/ 30/mes)
('Emprendedor - Anual', 1, 3, 30000, 'PEN', 365, 'EMP-12M', TRUE),      -- Ahorro 37% (S/ 25/mes)

-- ==========================================
-- 2. LICENCIA EMPRESARIO (2 Dispositivos, 8 Usuarios)
-- Base Mensual: S/ 70.00
-- ==========================================
('Empresario - 1 Mes', 2, 8, 7000, 'PEN', 30, 'BIZ-1M', TRUE),
('Empresario - 3 Meses', 2, 8, 18500, 'PEN', 90, 'BIZ-3M', TRUE),       -- Ahorro ~12% (S/ 61/mes)
('Empresario - 6 Meses', 2, 8, 31500, 'PEN', 180, 'BIZ-6M', TRUE),      -- Ahorro 25% (S/ 52/mes)
('Empresario - Anual', 2, 8, 52000, 'PEN', 365, 'BIZ-12M', TRUE),       -- Ahorro ~38% (S/ 43/mes)

-- ==========================================
-- 3. LICENCIA PYME (5 Dispositivos, 25 Usuarios)
-- Base Mensual: S/ 150.00
-- ==========================================
('PYME - 1 Mes', 5, 25, 15000, 'PEN', 30, 'PYM-1M', TRUE),
('PYME - 3 Meses', 5, 25, 39500, 'PEN', 90, 'PYM-3M', TRUE),            -- Ahorro ~12% (S/ 131/mes)
('PYME - 6 Meses', 5, 25, 67500, 'PEN', 180, 'PYM-6M', TRUE),           -- Ahorro 25% (S/ 112/mes)
('PYME - Anual', 5, 25, 110000, 'PEN', 365, 'PYM-12M', TRUE),           -- Ahorro ~38% (S/ 91/mes)

-- ==========================================
-- 4. LICENCIA GRAN EMPRESA (10 Dispositivos, 60 Usuarios)
-- Base Mensual: S/ 250.00
-- ==========================================
('Gran Empresa - 1 Mes', 10, 60, 25000, 'PEN', 30, 'CORP-1M', TRUE),
('Gran Empresa - 3 Meses', 10, 60, 66000, 'PEN', 90, 'CORP-3M', TRUE),  -- Ahorro ~12% (S/ 220/mes)
('Gran Empresa - 6 Meses', 10, 60, 112500, 'PEN', 180, 'CORP-6M', TRUE),-- Ahorro 25% (S/ 187/mes)
('Gran Empresa - Anual', 10, 60, 180000, 'PEN', 365, 'CORP-12M', TRUE); -- Ahorro 40% (S/ 150/mes)