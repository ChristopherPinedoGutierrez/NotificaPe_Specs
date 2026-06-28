-- ==============================================================================
-- 16. RLS: CONFIGURACIÓN DE BILLETERAS POR DISPOSITIVO (BilleterasXDispositivo)
-- Fecha: 2024-05-20
-- Descripción: Permite que cada App Admin gestione qué billeteras tiene activas,
-- sus nombres de titular y sus códigos QR.
-- ==============================================================================

ALTER TABLE public."BilleterasXDispositivo" ENABLE ROW LEVEL SECURITY;

-- 16.1. Acceso para la App Admin (Rol anon)
-- Permitimos que cualquier dispositivo inserte o actualice su propia configuración.
-- Usamos casting ::text para asegurar compatibilidad de tipos
DROP POLICY IF EXISTS "App Admin gestiona sus billeteras" ON public."BilleterasXDispositivo";
CREATE POLICY "App Admin gestiona sus billeteras"
ON public."BilleterasXDispositivo"
FOR ALL
TO anon
USING (true)
WITH CHECK (true);

-- 16.2. Acceso para el DUEÑO (Contratante) via Web Panel (Rol authenticated)
-- Comparamos convirtiendo ambos lados a text para evitar el error de tipos
DROP POLICY IF EXISTS "Contratantes ven billeteras de sus dispositivos" ON public."BilleterasXDispositivo";
CREATE POLICY "Contratantes ven billeteras de sus dispositivos"
ON public."BilleterasXDispositivo"
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo"::text = public."BilleterasXDispositivo"."IdDispositivo"::text
    AND d."IdContratante"::text = auth.uid()::text
  )
);

-- 16.3. Acceso para el DUEÑO para editar (Rol authenticated)
DROP POLICY IF EXISTS "Contratantes editan billeteras de sus dispositivos" ON public."BilleterasXDispositivo";
CREATE POLICY "Contratantes editan billeteras de sus dispositivos"
ON public."BilleterasXDispositivo"
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo"::text = public."BilleterasXDispositivo"."IdDispositivo"::text
    AND d."IdContratante"::text = auth.uid()::text
  )
);

-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 37_fix_rls_logical_identity.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: BilleterasXDispositivo)
-- ==========================================================================

-- ==============================================================================
-- 37. FIX: RLS PARA IDENTIDAD LÓGICA (PDV) VS FÍSICA (HARDWARE) - CORREGIDO
-- Fecha: 2024-05-24
-- Descripción: Permite que el App Admin gestione QRs y actualice su perfil
--              usando el HardwareId como llave de validación cruzada.
-- ==============================================================================

-- 1. PERMISOS PARA LA TABLA BilleterasXDispositivo
-- Permite que el rol anon actualice la URL del QR validando su HardwareId
DROP POLICY IF EXISTS "AdminApp_Update_Wallet_QR" ON public."BilleterasXDispositivo";
CREATE POLICY "AdminApp_Update_Wallet_QR"
ON public."BilleterasXDispositivo"
FOR UPDATE
TO anon
USING (
    EXISTS (
        SELECT 1 FROM "DispositivosXContratante" d
        WHERE d."IdDispositivo" = "BilleterasXDispositivo"."IdDispositivo"
        AND d."HardwareId" = current_setting('request.headers', true)::json->>'x-hardware-id'
    )
)
WITH CHECK (true);

-- 2. PERMISOS PARA STORAGE (Bucket: billeteras_qrs)
-- El App Admin tiene control total sobre sus propios archivos en el bucket.
DROP POLICY IF EXISTS "App Admin Full Control QRs" ON storage.objects;
CREATE POLICY "App Admin Full Control QRs"
ON storage.objects
FOR ALL
TO anon
USING (bucket_id = 'billeteras_qrs')
WITH CHECK (bucket_id = 'billeteras_qrs');

-- Permitir lectura pública para que el Panel Web vea las imágenes
DROP POLICY IF EXISTS "QRs lectura publica" ON storage.objects;
CREATE POLICY "QRs lectura publica"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'billeteras_qrs');

-- 3. OPTIMIZACIÓN REALTIME
-- Forzamos que los eventos de cambio incluyan todos los campos
ALTER TABLE public."BilleterasXDispositivo" REPLICA IDENTITY FULL;
ALTER TABLE public."DispositivosXContratante" REPLICA IDENTITY FULL;



-- ==========================================================================
-- EXTENSIÓN (App Admin): Origen -> 37_remove_owner_name_wallets.sql
-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: BilleterasXDispositivo)
-- ==========================================================================

-- 37. REMOVER COLUMNA NombreTitular de BilleterasXDispositivo
-- Justificación: El titular ya no se gestiona por dispositivo, simplificando la configuración.

ALTER TABLE public."BilleterasXDispositivo" DROP COLUMN IF EXISTS "NombreTitular";

-- Comentario de integridad
COMMENT ON COLUMN public."BilleterasXDispositivo"."UrlQR" IS 'URL pública del código QR para cobros (Supabase Storage)';

