# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de Integración Completada)

## [E1] Entregable 1: Core de Notificaciones y Sincronización

### Épica: Base de Datos y APIs
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket público en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la sección de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y añadir botones de descarga directa para los APKs.

### Épica: Emisor
- [ ] App: admin | Tarea: Implementar lógica Room-First y Worker Offline para resiliencia total.
- [ ] App: admin | Tarea: Implementar CentinelaService (Foreground Service persistente con auto-recuperación).

### Épica: Receptor
- [ ] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseñar UI de resolución de conflictos.
- [ ] App: viewer | Tarea: Integrar invocación de RPC `rpc_resolver_disputas` para mediación final.
