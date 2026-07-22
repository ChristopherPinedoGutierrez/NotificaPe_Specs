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
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicación errónea de transferencias idénticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuración de Presence en la creación del canal Realtime para permitir el track de estado online en el dashboard [CR-010].

### Épica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseñar UI de resolución de conflictos.
- [x] App: viewer | Tarea: Integrar invocación de RPC `rpc_resolver_disputas` para mediación final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnóstico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexión Realtime y Delta Sync al retornar de background y ante transiciones de red física [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelación de listener al minimizar. Implementar caché local de sesión en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de eventos Insert en RealtimeCoordinator (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y Vibración correctamente [CR-008].
- [ ] App: viewer | Tarea (CR): Diseñar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseña y verificación de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### Épica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con políticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserción pública para anónimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda Técnica): Elaborar y ejecutar un script de migración SQL único (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huérfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producción.

### Épica: Portal Web y Cumplimiento (Perú)
- [x] App: web | Tarea (Legal): Diseñar e implementar las páginas estáticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinámicos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integración con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envío de correo de confirmación HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Épica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): Diseñar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360°, la pestaña de licencias en cola/usuarios vinculados, y la visualización de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la función RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestión `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 días hábiles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Épica: Políticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en Español.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promoción manual de Alpha/Beta en la consola de Google Play, adjuntando la documentación justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesión.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisión automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promoción manual de fase Alpha/Beta en Google Play Console para el receptor.

### Tareas Generales (Por Priorizar)
- [x] **[TSK-001]** | App: Viewer | UI: Remoción de la verificación y solicitud obligatoria de optimización de batería (Google Play Policies).
- [ ] **[CR-007]** | App: Admin | Lógica: Actualizar el generador de notificaciones Mock para incluir `sbn.postTime` o un equivalente dinámico en la generación del `IdSync`, a fin de evitar la deduplicación incorrecta en el receptor (Viewer).
- [x] **[CR-009]** | App: Web | UI/API: Rediseño del Estado de Conexión en detalle de dispositivo físico vía Supabase Realtime Presence (escuchando el canal broadcast del app Admin).
