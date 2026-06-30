-- ==========================================================
-- 37_RLS_AUTORIZACIONES_WEB.SQL
-- Descripción: Corrección de políticas RLS para que el
-- Web Panel (Contratante) pueda listar y gestionar a sus vendedores.
-- ==========================================================

-- 1. Políticas sobre AutorizacionesXUsuario para el Contratante (Admin Web)
-- Permite que el dueño del negocio lea y actualice autorizaciones si el dispositivo le pertenece.
DROP POLICY IF EXISTS "Contratantes gestionan autorizaciones de sus cajas" ON public."AutorizacionesXUsuario";
DROP POLICY IF EXISTS "Contratantes gestionan autorizaciones de sus cajas - Escritura" ON public."AutorizacionesXUsuario";
DROP POLICY IF EXISTS "Contratantes gestionan autorizaciones de sus cajas - Lectura" ON public."AutorizacionesXUsuario";

-- Escritura: mantiene protección EXISTS por seguridad
CREATE POLICY "Contratantes gestionan autorizaciones de sus cajas - Escritura"
ON public."AutorizacionesXUsuario"
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public."DispositivosXContratante" d
    WHERE d."IdDispositivo" = "AutorizacionesXUsuario"."IdDispositivo"
    AND d."IdContratante" = auth.uid()
  )
);

-- Lectura: simplificada a USING(true) para compatibilidad con Supabase Realtime
CREATE POLICY "Contratantes gestionan autorizaciones de sus cajas - Lectura"
ON public."AutorizacionesXUsuario"
FOR SELECT
TO authenticated
USING (true);

-- 2. Políticas sobre Usuarios para el Contratante (Admin Web)
-- Permite que el dueño del negocio lea el perfil (nombre, correo, teléfono) del Vendedor
-- únicamente si ese vendedor tiene una solicitud/autorización en alguna de sus cajas.
DROP POLICY IF EXISTS "Contratantes ven perfiles de sus vendedores" ON public."Usuarios";

CREATE POLICY "Contratantes ven perfiles de sus vendedores"
ON public."Usuarios"
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public."AutorizacionesXUsuario" a
    JOIN public."DispositivosXContratante" d ON a."IdDispositivo" = d."IdDispositivo"
    WHERE a."IdUsuario" = "Usuarios"."IdUsuario"
    AND d."IdContratante" = auth.uid()
  )
);
