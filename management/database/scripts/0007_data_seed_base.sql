-- ==============================================================================
-- SCRIPT DE DATOS SEMILLA: CATÁLOGOS BASE Y CONFIGURACIÓN
-- Proyecto: NotificaPe
-- Tablas: Roles, EstadosAuth, Billeteras
-- ==============================================================================

-- ==========================================
-- 1. ROLES DE USUARIO
-- ==========================================
-- Nota: IdRol 1 será el valor por defecto en la App para la fuerza laboral.
INSERT INTO public."Roles" ("IdRol", "NomRol", "CanRead", "CanWrite") 
VALUES 
(1, 'Vendedor', TRUE, TRUE),    -- Puede leer notificaciones y autoasignarse (escribir)
(2, 'Supervisor', TRUE, TRUE);  -- Puede ver reportes consolidados y revocar asignaciones

-- ==========================================
-- 2. ESTADOS DE AUTENTICACIÓN
-- ==========================================
-- Definen el estado de vinculación entre un Usuario y un Dispositivo (Caja)
-- Ya definido en 07_auth_states_seed.sql

-- ==========================================
-- 3. BILLETERAS SOPORTADAS (PERÚ)
-- ==========================================
-- Nota: Dado que "Plin" no es una app independiente, sino que vive dentro de las apps 
-- de los bancos, registramos los "Package Names" de los bancos principales que lo soportan.
-- Los IDs explícitos se usan para poder enlazarlos fácilmente con los Filtros Regex después.
INSERT INTO public."Billeteras" ("IdBilletera", "PackageName", "Nombre") 
VALUES 
(1, 'com.bcp.innovacxion.yape', 'Yape'),
(2, 'pe.com.interbank.mobilebanking', 'Plin_Interbank'),
(3, 'com.bbva.nibble.pe', 'Plin_BBVA'),
(4, 'pe.com.scotiabank.bancamovil', 'Plin_Scotiabank');

-- ==========================================
-- 4. (OPCIONAL) EJEMPLO DE FILTROS REGEX PARA YAPE
-- ==========================================
-- Esto le enseñará a la App Android cómo leer las notificaciones de Yape
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido")
VALUES
(1, 'Pago Recibido Estándar', '(?i)yapeaste.*?(s/|usd)\s*([0-9,]+\.[0-9]{2}).*?a\s+(.*)'),
(1, 'Pago Recibido Variante B', '(?i)recibiste.*?(s/|usd)\s*([0-9,]+\.[0-9]{2}).*?de\s+(.*)');

-- (Reajustar secuencias para evitar errores de ID en futuras inserciones automáticas)
SELECT setval(pg_get_serial_sequence('public."Billeteras"', 'IdBilletera'), (SELECT MAX("IdBilletera") FROM public."Billeteras"));

-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 14_flltros_actualizados_billeteras.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: FiltrosXBilletera)
-- ==========================================================================

-- 3. Insertar las dos reglas maestras para Yape
INSERT INTO public."FiltrosXBilletera" ("IdBilletera", "NombreRegla", "RegexContenido")
VALUES
(
  (SELECT "IdBilletera" FROM public."Billeteras" WHERE "Nombre" ILIKE '%Yape%' LIMIT 1),
  'Yape Estándar (Con o sin prefijo Yape!)',
  '(?i)(?:Yape!\s*)?(?<remitente>.*?) te envió un pago por S/\s*(?<monto>[0-9,.]+)'
),
(
  (SELECT "IdBilletera" FROM public."Billeteras" WHERE "Nombre" ILIKE '%Yape%' LIMIT 1),
  'Yape con Código de Seguridad',
  '(?i)(?<remitente>.*) te envió un pago por S/\s*(?<monto>[0-9,.]+).*cód\. de seguridad'
);


-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 39_soporte_laboratorio_mensajes_mock.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: FiltrosXBilletera)
-- ==========================================================================

-- 1. Añadir columna MensajeMock a la tabla FiltrosXBilletera
ALTER TABLE "FiltrosXBilletera"
ADD COLUMN "MensajeMock" text;

-- 2. Actualizar Regex y MensajeMock para Yape con Código de Seguridad
-- Esta regex es más flexible para permitir conectores como "El cód. de seguridad es:"
UPDATE "FiltrosXBilletera"
SET
    "RegexContenido" = '(?i)(?:Yape!\s*)?(?<remitente>.*?) te envió un pago por S/\s*(?<monto>[0-9.,]+).*?cód\.\s*de\s*seguridad.*?[:\s]+(?<codigo>[0-9]{3,10})',
    "MensajeMock" = 'Martha Gut* te envió un pago por S/ 35. El cód. de seguridad es: 016'
WHERE "NombreRegla" = 'Yape con Código de Seguridad';

-- 3. Actualizar MensajeMock para reglas de Plin estándar
UPDATE "FiltrosXBilletera"
SET "MensajeMock" = 'Juan Perez te envió S/ 25.50. Operación: 456789'
WHERE "NombreRegla" LIKE 'Plin%' AND "MensajeMock" IS NULL;

-- 4. Mensaje específico para Plin Scotiabank
UPDATE "FiltrosXBilletera"
SET "MensajeMock" = 'Plin_Scotiabank: Pago recibido por S/ 10.00'
WHERE "NombreRegla" = 'Plin Scotiabank';



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 34_view_notificaciones_disputadas.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: Billeteras)
-- ==========================================================================

-- ==========================================================
-- 34_VIEW_NOTIFICACIONES_DISPUTADAS.SQL
-- Objetivo: Facilitar la consulta de notificaciones en disputa
-- uniendo la maestra con sus respectivos reclamantes.
-- Corregido: Usa MontoCentimos y Join con Billeteras.
-- ==========================================================

CREATE OR REPLACE VIEW public.view_notificaciones_disputadas
WITH (security_invoker = true)
AS
SELECT
    nd."IdSync",
    nd."MontoCentimos",
    -- Intentamos obtener CodigoOperacion si existe, si no, lo manejamos como NULL
    -- para no romper el script si aún no has corrido el script que añade esa columna.
    (SELECT column_name FROM information_schema.columns
     WHERE table_name='NotificacionesXDispositivo' AND column_name='CodigoOperacion' LIMIT 1) as "HasCol",
    nd."FechaOpera",
    b."Nombre" AS "App",
    nd."IdContratante",
    COALESCE(
        jsonb_agg(
            jsonb_build_object(
                'IdUsuario', nau."IdUsuario",
                'Nombre', u."NombreCompleto",
                'Observacion', nau."Observacion",
                'FechaReclamacion', nau."FechaReg"
            )
        ) FILTER (WHERE nau."IdUsuario" IS NOT NULL),
        '[]'::jsonb
    ) AS "Reclamantes"
FROM public."NotificacionesXDispositivo" nd
LEFT JOIN public."Billeteras" b ON nd."IdBilletera" = b."IdBilletera"
LEFT JOIN public."NotificacionesAUsuarios" nau ON nd."IdSync" = nau."IdSync"
LEFT JOIN public."Usuarios" u ON nau."IdUsuario" = u."IdUsuario"
WHERE nd."EstadoProgreso" = 'REVISION'
GROUP BY nd."IdSync", nd."MontoCentimos", nd."FechaOpera", b."Nombre", nd."IdContratante";



-- ==========================================================================
-- EXTENSIÓN (App Viewer): Origen -> 37_rls_viewer_billeteras_access.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: Billeteras)
-- ==========================================================================

-- ==========================================================
-- 37_RLS_VIEWER_BILLETERAS_ACCESS.SQL
-- Descripción: Permite que los Vendedores (Viewer) vean las
-- billeteras y QRs de las cajas a las que están vinculados.
-- ==========================================================

-- 1. Asegurar que los usuarios autenticados puedan ver el catálogo de billeteras
DROP POLICY IF EXISTS "Lectura_Authenticated_Billeteras" ON public."Billeteras";
CREATE POLICY "Lectura_Authenticated_Billeteras"
ON public."Billeteras" FOR SELECT
TO authenticated
USING (true);

-- 2. Permitir que los Vendedores vean las billeteras activas de sus dispositivos autorizados
DROP POLICY IF EXISTS "Vendedores_Ven_Billeteras_Asignadas" ON public."BilleterasXDispositivo";
CREATE POLICY "Vendedores_Ven_Billeteras_Asignadas"
ON public."BilleterasXDispositivo" FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public."AutorizacionesXUsuario" a
    WHERE a."IdDispositivo" = public."BilleterasXDispositivo"."IdDispositivo"
    AND a."IdUsuario" = auth.uid()
    AND a."IdEstadoAuth" = 2 -- APROBADO
  )
);

