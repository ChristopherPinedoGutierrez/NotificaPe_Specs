-- Script: 0031_registrar_reclamacion_publica_rpc.sql
-- App Origen: NotificaPe_Specs
-- Autor: AGENT_ROLE (Desarrollador Web)
-- Fecha: 2026-07-19 11:40
-- Justificación: Crear función RPC SECURITY DEFINER para permitir la inserción pública y retorno seguro del CodigoReclamacion sin vulnerar RLS de SELECT.

CREATE OR REPLACE FUNCTION registrar_reclamacion_publica(
  p_nombre_completo text,
  p_tipo_documento text,
  p_numero_documento text,
  p_correo text,
  p_telefono text,
  p_tipo_reclamacion text,
  p_detalle_reclamacion text,
  p_pedido_cliente text
)
RETURNS text
LANGUAGE plpgsql
SECURITY DEFINER -- Ejecuta con permisos de superusuario
AS $$
DECLARE
  v_codigo text;
BEGIN
  INSERT INTO "public"."Reclamaciones" (
    "NombreCompleto",
    "TipoDocumento",
    "NumeroDocumento",
    "Correo",
    "Telefono",
    "TipoReclamacion",
    "DetalleReclamacion",
    "PedidoCliente",
    "Estado"
  )
  VALUES (
    p_nombre_completo,
    p_tipo_documento,
    p_numero_documento,
    p_correo,
    p_telefono,
    p_tipo_reclamacion,
    p_detalle_reclamacion,
    p_pedido_cliente,
    'PENDIENTE'
  )
  RETURNING "CodigoReclamacion" INTO v_codigo;

  RETURN v_codigo;
END;
$$;
