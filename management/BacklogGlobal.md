# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de Integración Completada)

## [E1] Entregable 1: Core de Notificaciones y Sincronización

### Épica: Base de Datos y APIs
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket público en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la sección de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y añadir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producción' para remover el límite de 100 usuarios de prueba antes del lanzamiento oficial.


### Épica: Emisor
- [x] App: admin | Tarea: Implementar lógica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rápidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activación y billeteras dinámicas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticación de terminales mediante JWT único por dispositivo y eliminación de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integración (androidTest) para simular caídas físicas de red (handover) y persistencia transaccional en Room.


### Épica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseñar UI de resolución de conflictos.
- [x] App: viewer | Tarea: Integrar invocación de RPC `rpc_resolver_disputas` para mediación final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnóstico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexión Realtime y Delta Sync al retornar de background y ante transiciones de red física [CR-004].
- [ ] App: viewer | Tarea (CR): Diseñar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseña y verificación de billeteras asociadas [CR-005].



