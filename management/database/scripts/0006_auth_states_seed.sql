-- ==============================================================================
-- SCRIPT DE DATOS SEMILLA: ESTADOS DE AUTORIZACIÓN
-- Proyecto: NotificaPe
-- Tabla: public."EstadosAuth"
-- ==============================================================================

-- 1: Pendiente (Usuario solicitó unirse pero Admin no ha respondido)
-- 2: Aprobado (Admin permite la conexión)
-- 3: Bloqueado (Admin revocó el acceso permanentemente)
-- 4: Rechazado (Admin denegó la solicitud inicial)

INSERT INTO public."EstadosAuth" ("IdEstadoAuth", "NomEstaAuth")
VALUES 
(1, 'Pendiente'),
(2, 'Aprobado'),
(3, 'Bloqueado'),
(4, 'Rechazado')
ON CONFLICT ("IdEstadoAuth") DO NOTHING;
