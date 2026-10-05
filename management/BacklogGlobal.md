# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃƒÆ’Ã‚Â³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃƒÆ’Ã‚Â³n

### ÃƒÆ’Ã¢â‚¬Â°pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃƒÆ’Ã‚Â³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÆ’Ã‚Âºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÆ’Ã‚Â³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÆ’Ã‚Â±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÆ’Ã‚Â³n' para remover el lÃƒÆ’Ã‚Â­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### ÃƒÆ’Ã¢â‚¬Â°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÆ’Ã‚Â³gica Room-First y Worker Offline para resiliencia total.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÂºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÂ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÂ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÂ³n' para remover el lÃƒÂ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ãƒâ€°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÂ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rÃƒÂ¡pidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activaciÃƒÂ³n y billeteras dinÃƒÂ¡micas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticaciÃƒÂ³n de terminales mediante JWT ÃƒÂºnico por dispositivo y eliminaciÃƒÂ³n de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integraciÃƒÂ³n (androidTest) para simular caÃƒÂ­das fÃƒÂ­sicas de red (handover) y persistencia transaccional en Room.
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicaciÃƒÂ³n errÃƒÂ³nea de transferencias idÃƒÂ©nticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuraciÃƒÂ³n de Presence en la creaciÃƒÂ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza AutomÃƒÂ¡tica Segura" (OpciÃƒÂ³n A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una ÃƒÂºnica notificaciÃƒÂ³n persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | ÃƒÅ¡ltimo: S/ 15"), evitando saturar el lÃƒÂ­mite de Android bajo estrÃƒÂ©s [CR-012].
- [ ] App: admin | Tarea (Mejora UX/ÃƒÂconos): DiseÃƒÂ±ar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].
- [x] App: admin | Tarea (Fix UI): ContenciÃ³n de actividad de recorte de QR (CropActivity) e integraciÃ³n dinÃ¡mica de WindowInsets ante Edge-to-Edge obligatorio en Android 15/16 [CR-014].
- [x] App: admin | Tarea (Mejora Notificaciones): Notificaciones atÃ³micas por billetera (ID 2000 + IdBilletera) con reemplazo de estado en caliente y sincronizaciÃ³n silenciosa inicial [CR-015].

### Ãƒâ€°pica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseÃƒÂ±ar UI de resoluciÃƒÂ³n de conflictos.
- [x] App: viewer | Tarea: Integrar invocaciÃƒÂ³n de RPC `rpc_resolver_disputas` para mediaciÃƒÂ³n final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃƒÂ³stico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexiÃƒÂ³n Realtime y Delta Sync al retornar de background y ante transiciones de red fÃƒÂ­sica [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelaciÃƒÂ³n de listener al minimizar. Implementar cachÃƒÂ© local de sesiÃƒÂ³n en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [x] App: db | Tarea (Deuda TÃƒÆ’Ã‚Â©cnica): Elaborar y ejecutar un script de migraciÃƒÆ’Ã‚Â³n SQL ÃƒÆ’Ã‚Âºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÆ’Ã‚Â©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÆ’Ã‚Â³n.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’Ã‚Â¡biles).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### ÃƒÆ’Ã¢â‚¬Â°pica: PolÃƒÆ’Ã‚Â­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÆ’Ã‚Â±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃƒÆ’Ã‚Â³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÆ’Ã‚Â³n justificativa.
- [x] App: viewer | Tarea (CR): RediseÃƒÂ±o de cola unificada de notificaciones (TTS/Push/VibraciÃƒÂ³n), ritmo dinÃƒÂ¡mico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃƒÆ’Ã‚Â³n correctamente [CR-008].
- [ ] App: viewer | Tarea (CR): DiseÃƒÆ’Ã‚Â±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃƒÆ’Ã‚Â±a y verificaciÃƒÆ’Ã‚Â³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### ÃƒÆ’Ã¢â‚¬Â°pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃƒÆ’Ã‚Â­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃƒÆ’Ã‚Â³n pÃƒÆ’Ã‚Âºblica para anÃƒÆ’Ã‚Â³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃƒÆ’Ã‚Â©cnica): Elaborar y ejecutar un script de migraciÃƒÆ’Ã‚Â³n SQL ÃƒÆ’Ã‚Âºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÆ’Ã‚Â©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÆ’Ã‚Â³n.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’Ã‚Â¡biles).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### ÃƒÆ’Ã¢â‚¬Â°pica: PolÃƒÆ’Ã‚Â­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÆ’Ã‚Â±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃƒÆ’Ã‚Â³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÆ’Ã‚Â³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃƒÆ’Ã‚Â³n.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃƒÆ’Ã‚Â³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃƒÆ’Ã‚Â³n manual de fase Alpha/Beta en Google Play Console para el receptor.
# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃƒÆ’Ã‚Â³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃƒÆ’Ã‚Â³n

### ÃƒÆ’Ã¢â‚¬Â°pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃƒÆ’Ã‚Â³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÆ’Ã‚Âºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÆ’Ã‚Â³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÆ’Ã‚Â±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÆ’Ã‚Â³n' para remover el lÃƒÆ’Ã‚Â­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### ÃƒÆ’Ã¢â‚¬Â°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÆ’Ã‚Â³gica Room-First y Worker Offline para resiliencia total.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÂºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÂ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÂ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÂ³n' para remover el lÃƒÂ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ãƒâ€°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÂ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rÃƒÂ¡pidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activaciÃƒÂ³n y billeteras dinÃƒÂ¡micas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticaciÃƒÂ³n de terminales mediante JWT ÃƒÂºnico por dispositivo y eliminaciÃƒÂ³n de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integraciÃƒÂ³n (androidTest) para simular caÃƒÂ­das fÃƒÂ­sicas de red (handover) y persistencia transaccional en Room.
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicaciÃƒÂ³n errÃƒÂ³nea de transferencias idÃƒÂ©nticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuraciÃƒÂ³n de Presence en la creaciÃƒÂ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza AutomÃƒÂ¡tica Segura" (OpciÃƒÂ³n A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una ÃƒÂºnica notificaciÃƒÂ³n persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | ÃƒÅ¡ltimo: S/ 15"), evitando saturar el lÃƒÂ­mite de Android bajo estrÃƒÂ©s [CR-012].
- [ ] App: admin | Tarea (Mejora UX/ÃƒÂconos): DiseÃƒÂ±ar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].
- [x] App: db | Tarea (FCM): Crear Script SQL `0043` para agregar columna `FcmToken` a dispositivos y programar Triggers Inteligentes (BEFORE DELETE, AFTER UPDATE) invocando pg_net [CR-008].
- [x] App: web | Tarea (FCM): Programar Edge Function `fcm-dispatcher` en TypeScript para comunicarse vÃƒÂ­a OAuth 2.0 con la API HTTP v1 de Google FCM [CR-008].
- [x] App: admin | Tarea (FCM): Instalar SDKs de Firebase en `build.gradle.kts`, ajustar `deploy.yml`, y programar `FCMReceiverService.kt` con parseo de payloads [CR-008].
- [x] App: admin | Tarea (FCM): Modificar `AuthRepository.kt` (Subida de Token, DesvinculaciÃƒÂ³n) y extirpar WebSockets. Ajustar UI (pantalla de bloqueo y estados FCM) [CR-008].

### Ãƒâ€°pica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseÃƒÂ±ar UI de resoluciÃƒÂ³n de conflictos.
- [x] App: viewer | Tarea: Integrar invocaciÃƒÂ³n de RPC `rpc_resolver_disputas` para mediaciÃƒÂ³n final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃƒÂ³stico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexiÃƒÂ³n Realtime y Delta Sync al retornar de background y ante transiciones de red fÃƒÂ­sica [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelaciÃƒÂ³n de listener al minimizar. Implementar cachÃƒÂ© local de sesiÃƒÂ³n en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [x] App: db | Tarea (Deuda TÃƒÆ’Ã‚Â©cnica): Elaborar y ejecutar un script de migraciÃƒÆ’Ã‚Â³n SQL ÃƒÆ’Ã‚Âºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÆ’Ã‚Â©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÆ’Ã‚Â³n.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’Ã‚Â¡biles).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [x] App: viewer | Tarea (CR): RediseÃƒÂ±o de cola unificada de notificaciones (TTS/Push/VibraciÃƒÂ³n), ritmo dinÃƒÂ¡mico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃƒÆ’Ã‚Â³n correctamente [CR-008].
- [x] App: viewer | Tarea (CR): DiseÃƒÆ’Ã‚Â±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃƒÆ’Ã‚Â±a y verificaciÃƒÆ’Ã‚Â³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### ÃƒÆ’Ã¢â‚¬Â°pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃƒÆ’Ã‚Â­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃƒÆ’Ã‚Â³n pÃƒÆ’Ã‚Âºblica para anÃƒÆ’Ã‚Â³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃƒÆ’Ã‚Â©cnica): Elaborar y ejecutar un script de migraciÃƒÆ’Ã‚Â³n SQL ÃƒÆ’Ã‚Âºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÆ’Ã‚Â©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÆ’Ã‚Â³n.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’able).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃƒÂ³n.
- [ ] App: viewer | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permiso `FOREGROUND_SERVICE_SPECIAL_USE` del CentinelaService.
- [x] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃƒÂ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃƒÂ³n manual de fase Alpha/Beta en Google Play Console para el receptor.

### Ãƒâ€°pica: Infraestructura y Operaciones Cloud
- [x] App: web | Tarea (Infraestructura): MigraciÃƒÂ³n de despliegue en EasyPanel hacia nuevo VPS (31.220.50.238) por renovaciÃƒÂ³n anticipada y ahorro de costos de hosting, y actualizaciÃƒÂ³n de registros DNS en Namecheap para notificape.ryctech.dev.

### Tareas Generales (Por Priorizar)
- [x] **[TSK-001]** | App: Viewer | UI: RemociÃƒÆ’Ã‚Â³n de la verificaciÃƒÆ’Ã‚Â³n y solicitud obligatoria de optimizaciÃƒÆ’Ã‚Â³n de baterÃƒÆ’Ã‚Â­a (Google Play Policies).
- [x] **[CR-007]** | App: Admin | LÃƒÆ’Ã‚Â³gica: Actualizar el generador de notificaciones Mock para incluir `sbn.postTime` o un equivalente dinÃƒÆ’Ã‚Â¡mico en la generaciÃƒÆ’Ã‚Â³n del `IdSync`, a fin de evitar la deduplicaciÃƒÆ’Ã‚Â³n incorrecta en el receptor (Viewer).
- [x] **[CR-009]** | App: Web | UI/API: RediseÃƒÆ’Ã‚Â±o del Estado de ConexiÃƒÆ’Ã‚Â³n en detalle de dispositivo fÃƒÆ’Ã‚Â­sico vÃƒÆ’Ã‚Â­a Supabase Realtime Presence (escuchando el canal broadcast del app Admin).
- [x] **[CR-015]** | App: Web/DB | UI/API: Ampliar vista view_notificaciones_disputadas con metadatos de usuarios y ContenidoMsg, y rediseñar DisputaCard en el dashboard de clientes para permitir la desambiguación.


## [E3] Entregable 3: ExpansiÃƒÂ³n de Negocio B2B (CR-014)

### Ãƒâ€°pica: Base de Datos y FacturaciÃƒÂ³n Modular (App: db)
- [x] Crear script `0035_addons_y_custom_plans.sql` aÃƒÂ±adiendo `IdContratanteExclusivo`, `PermiteAddons`, y precios extra a `Licencias`. Y columnas `ExtraUsuarios`, `ExtraDispositivos` a `LicenciasXContratante`.
- [x] Actualizar trigger `check_user_limit` y afines para que sumen `Limite + Extra` leyendo de la instancia de `LicenciasXContratante` activa.
- [x] Crear funciÃƒÂ³n RPC `procesar_compra_addon` que asigne el saldo en crÃƒÂ©dito y actualice los campos Extra de la licencia (con lÃƒÂ³gica de ticket mÃƒÂ­nimo).
- [x] Tarea (CR-014): Modificar motor de compras (previsualizar y ejecutar) para considerar add-ons e implementar motor automÃƒÂ¡tico de colas con pg_cron.

### Ãƒâ€°pica: Panel de Usuario y Superadmin (Frontend)
- [x] App: web | Tarea (CR-014): Actualizar DTOs en `actions_control.ts` y `dispositivos/actions.ts` para leer y sumar los campos `ExtraUsuarios` y `ExtraDispositivos` de la base de datos al validar lÃƒÂ­mites.
- [x] App: web | Tarea (CR-014): Implementar UI en el Dashboard de cliente para "Adquirir Usuarios/Dispositivos Extra", conectando a la funciÃƒÂ³n RPC de compra.
- [ ] App: web | Tarea (CR-014): Construir vista en `/superadmin/licencias` para que el Superadmin pueda crear "Planes Custom" aislando a un `IdContratanteExclusivo` y fijar precios manuales.
- [ ] App: web | Tarea (CR-014): Modificar `PricingCards.tsx` para ocultar planes corporativos al pÃƒÂºblico general y renderizarlos solo si el UUID coincide.
- [x] App: web/db | Tarea (Pendiente): Reforzar a nivel de servidor (`actions.ts`) y base de datos la inyecciÃƒÂ³n automÃƒÂ¡tica del diferencial (Vuelto) como saldo a favor cuando se aplica el Ticket MÃƒÂ­nimo de 5 soles en el checkout de MercadoPago.

## [E4] Entregable 4: Motor DinÃƒÂ¡mico de Regex y EstandarizaciÃƒÂ³n (Zero-Downtime)

### Ãƒâ€°pica: AplicaciÃƒÂ³n Web (Superadmin y Cliente)
- [x] App: web | Tarea: Crear UI 'Simulador Regex' en el Superadmin que tome el `PayloadBruto` (JSON) de notificaciones en estado 'REVISION', reconstruya el string concatenado en pantalla y evalÃƒÂºe la Regex en vivo.
- [ ] App: web | Tarea: Implementar UI 'Previsualizador de Mensaje' que aplique el `FormatoMensaje` sobre las variables extraÃƒÂ­das (Grupos Nombrados) en el simulador.
- [ ] App: web | Tarea: Agregar botÃƒÂ³n y conexiÃƒÂ³n a la Edge Function `reprocesar-notificaciones` para re-evaluar registros 'REVISION' tras guardar una regla.
- [x] App: web | Tarea: Modificar la UI de "Mis Billeteras" (Cliente) para que en el selector de asignaciÃƒÂ³n **solo** se listen billeteras que tengan al menos una regla activa con `VersionMotor = 2`.
- [ ] App: web | Tarea (Admin): Crear herramienta de limpieza masiva (Hard Delete) en el Superadmin para remover de DB y Storage las billeteras legacy inactivas.
- [ ] App: web | Tarea (Futuro): Desarrollar CRUD completo para la gestiÃƒÂ³n de Billeteras en el Superadmin. Considera alta complejidad tÃƒÂ©cnica (validaciones de integridad referencial, eliminaciÃƒÂ³n en cascada segura considerando asignaciones previas a usuarios y filtros) para no romper registros histÃƒÂ³ricos.

### Ãƒâ€°pica: Emisor Android (Admin)
- [x] App: admin | Tarea: Eliminar cÃƒÂ³digo duro de Lemon Pay en el servicio de evaluaciÃƒÂ³n.
- [x] App: admin | Tarea: Implementar generaciÃƒÂ³n del String de EvaluaciÃƒÂ³n concatenado (`[TITLE]...[TEXT]...`) en memoria RAM y ejecuciÃƒÂ³n de Regex con Grupos de Captura Nombrados.
- [x] App: admin | Tarea: Mapear variables extraÃƒÂ­das e interpolarlas con el `FormatoMensaje` antes de guardar `ContenidoMsg`.
- [x] App: admin | Tarea: Actualizar consulta DAO/Repository para descargar ÃƒÂºnicamente las reglas con `VersionMotor = 2`.
- [x] App: admin | Tarea: Modificar herramienta local 'Mensaje Mock' y capturar el PayloadBruto.

### Ãƒâ€°pica: Base de Datos y Backend
- [ ] App: db | Tarea: Crear script de migraciÃƒÂ³n aÃƒÂ±adiendo `TipoFiltro`, `FormatoMensaje`, `VersionMotor` a `FiltrosXBilletera` y `PayloadBruto` a `NotificacionesXDispositivo`.
- [ ] App: db | Tarea: Crear script inicial para duplicar las reglas vigentes de Yape y Lemon al formato concatenado bajo `VersionMotor = 2`.
- [ ] App: db | Tarea: Implementar Edge Function (Deno/TypeScript) `reprocesar-notificaciones` para recorrer y procesar con Regex (JS) las notificaciones en estado 'REVISION' y promoverlas a 'PENDIENTE'.

## [E5] Entregable 5: Sistema Integral de Onboarding y Usabilidad

### Hito 1: Hub de Descargas y Resiliencia de Accesos
- [x] App: web | **[TSK-016]** UI: Desarrollar `DownloadHubModal.tsx` con selector bitemÃƒÂ¡tico (Dark/Light) para App Emisor y App Receptor, cÃƒÂ³digos QR dinÃƒÂ¡micos para descarga directa desde celular, temporizador de descarga de APK, link a tiendas oficiales y botÃƒÂ³n para compartir enlace de instalaciÃƒÂ³n a cajeros vÃƒÂ­a mensajerÃƒÂ­a (sin marcas comerciales en cÃƒÂ³digo duro).
- [x] App: web | **[TSK-017]** NavegaciÃƒÂ³n: Integrar disparadores del Hub de Descargas en `SidebarNav.tsx` (versiÃƒÂ³n desktop y sheet mobile) y en el encabezado `DashboardHeader.tsx`.
- [x] App: web | **[TSK-018]** Seguridad/UX: Refactorizar `AccessGuard.tsx` y `licencias/page.tsx` para incorporar banner superior informativo contextual ante redirecciÃƒÂ³n por plan expirado o cuenta sin licencia activa.
- [x] App: web | **[TSK-019]** UI: RediseÃƒÂ±ar Empty States en `/dashboard/dispositivos` y `/dashboard/accesos` con micro-guÃƒÂ­as visuales y botones CTA directos para crear cajas y gestionar autorizaciones.

### Hito 2: Widget Setup Checklist en Dashboard
- [x] App: web | **[TSK-020]** Backend/DTO: Extender `fetchControlCenterStats` en `actions_control.ts` para calcular reactivamente los 4 estados de configuraciÃƒÂ³n inicial (perfil completado, licencia activa, cajas creadas, terminales/vendedores vinculados).
- [x] App: web | **[TSK-021]** UI: Construir el componente `SetupChecklist.tsx` en `/dashboard` con barra de progreso porcentual, estados interactivos (Checks/Botones), persistencia de colapso y dismiss en `localStorage`, y soporte Dark/Light.
- [x] App: web | **[TSK-022]** IntegraciÃƒÂ³n: Integrar `SetupChecklist.tsx` en `DashboardClient.tsx` arriba de las tarjetas de mÃƒÂ©tricas.

### Hito 3: Panel Lateral de Ayuda (Help Drawer) y Tour Interactivo Spotlight
- [x] App: web | **[TSK-023]** UI: Construir `HelpDrawer.tsx` (Panel lateral tipo `Sheet`) con detecciÃƒÂ³n de ruta activa (`pathname`), acordeones bitemÃƒÂ¡ticos de FAQs contextuales por secciÃƒÂ³n (Dashboard, Dispositivos, Accesos, Notificaciones) y accesos directos al Hub de Descargas y Tour.
- [x] App: web | **[TSK-024]** UI/Motor: Implementar el motor de tour interactivo `SpotlightTour.tsx` (overlay con backdrop y tooltips inteligentes bitemÃƒÂ¡ticos) para el recorrido general del Dashboard y mini-tours contextuales.
- [x] App: web | **[TSK-025]** NavegaciÃƒÂ³n/Estado: Montar el sistema de ayuda en `dashboard/layout.tsx` con trigger flotante e implementar la lÃƒÂ³gica de persistencia (`COMPLETED`, `IN_PROGRESS`, `DISMISSED`) y reanudaciÃƒÂ³n ante interrupciones.
- [x] App: web | **[TSK-025B]** UI/UX: Refactorizar SpotlightTour a tarjeta compacta flotante y arrastrable (Draggable) en desktop con modo dock inferior en mÃƒÂ³vil, tours condicionales multi-vista (actividad en dashboard, anatomÃƒÂ­a directa en detalle de dispositivo, personalizaciÃƒÂ³n en gestiÃƒÂ³n de licencias) y desacoplamiento de acordeones en /dashboard/licencias.

### Hito 4: InducciÃƒÂ³n, Onboarding y Tours en Aplicaciones MÃƒÂ³viles

#### Sub-Hito 4.1: App Admin (Emisor - Android / Jetpack Compose)
- [x] App: admin | **[TSK-026C]** Notificaciones de Sistema (Smart Diffing): Implementar motor de notificaciones locales para eventos administrativos recibidos vÃ­a FCM (UNBIND, Status, Rules, Wallets), utilizando diffing local en los repositorios para evitar spam offline.
- [x] App: admin | **[TSK-025C]** RefactorizaciÃ³n UI Dashboard (Change Request): Homologar interfaz del Dashboard con la App Viewer, implementando "Bloques Gemelos" (Selector de Fecha y PÃ­ldora de RecaudaciÃ³n al 50%), corrigiendo Ripple Effects nativos y aÃ±adiendo el nombre del contratante obtenido vÃ­a JOIN en Supabase.
- [ ] App: admin | **[TSK-026A]** Spotlight Tour Principal: Implementar recorrido guiado (Tour Interactivo) paso a paso en la pantalla principal (Dashboard). Debe activarse post-vinculaciÃƒÂ³n, resaltando el interruptor del Foreground Service y el monitor de billeteras activas (basado exclusivamente en componentes de producciÃƒÂ³n/release, ignorando secciones debug).
- [ ] App: admin | **[TSK-026B]** MÃƒÂ³dulo de Ayuda y Persistencia (Help Drawer): Desarrollar un panel de ayuda (Bottom Sheet o Navigation Drawer) similar al proyecto Web, incluyendo respuestas a FAQs y un botÃƒÂ³n para re-lanzar el "Spotlight Tour". Persistir el estado de completitud del tour en DataStore.

#### Sub-Hito 4.2: App Viewer (Receptor - Android / Jetpack Compose)
- [ ] App: viewer | **[TSK-027A]** Onboarding Carousel: DiseÃƒÂ±ar carrusel de inducciÃƒÂ³n para personal y cajeros explicando las alertas inmediatas en caja ante transferencias Yape/Plin.
- [x] App: viewer | **[TSK-027B]** VinculaciÃƒÂ³n y Espera: DiseÃƒÂ±ar flujo de escaneo QR de caja para solicitar acceso y pantalla reactiva con animaciÃƒÂ³n de espera (*"Esperando aprobaciÃƒÂ³n del administrador"*).
- [-] App: viewer | **[TSK-027C]** CalibraciÃƒÂ³n de Audio/TTS: MÃƒÂ³dulo interactivo de prueba de sonido y sÃƒÂ­ntesis de voz ("Yape recibido: S/ 20") para verificar volumen y motor TTS antes de operar.
 (DESCARTADO)
- [ ] App: viewer | **[TSK-027D]** Spotlight Tour Principal: Implementar tour guiado en la pantalla de historial resaltando la tarjeta del ÃƒÂºltimo pago, filtros por dispositivo y ajustes de audio.
- [ ] App: viewer | **[TSK-027E]** Persistencia y Ayuda: Guardar el estado de inducciÃƒÂ³n en DataStore y agregar la opciÃƒÂ³n de reinicio de tour en el menÃƒÂº de ConfiguraciÃƒÂ³n.
- [ ] App: viewer | **[TSK-027F]** Cierre de Jornada / Cuadres (FUTURO): Disenar flujo y vista para cuadrar caja.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’Ã‚Â¡biles).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.
- [x] App: web | Tarea (CR): Mejorar UX del estado Realtime en SidebarNav implementando matriz de 4 estados basados en red fÃƒÂ­sica (navigator.onLine) y ciclo de vida del socket.
### ÃƒÆ’Ã¢â‚¬Â°pica: PolÃƒÆ’Ã‚Â­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÆ’Ã‚Â±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃƒÆ’Ã‚Â³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÆ’Ã‚Â³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃƒÆ’Ã‚Â³n.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃƒÆ’Ã‚Â³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃƒÆ’Ã‚Â³n manual de fase Alpha/Beta en Google Play Console para el receptor.
# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃƒÆ’Ã‚Â³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃƒÆ’Ã‚Â³n

### ÃƒÆ’Ã¢â‚¬Â°pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃƒÆ’Ã‚Â³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÆ’Ã‚Âºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÆ’Ã‚Â³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÆ’Ã‚Â±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÆ’Ã‚Â³n' para remover el lÃƒÆ’Ã‚Â­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### ÃƒÆ’Ã¢â‚¬Â°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÆ’Ã‚Â³gica Room-First y Worker Offline para resiliencia total.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÂºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÂ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÂ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÂ³n' para remover el lÃƒÂ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ãƒâ€°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÂ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rÃƒÂ¡pidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activaciÃƒÂ³n y billeteras dinÃƒÂ¡micas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticaciÃƒÂ³n de terminales mediante JWT ÃƒÂºnico por dispositivo y eliminaciÃƒÂ³n de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integraciÃƒÂ³n (androidTest) para simular caÃƒÂ­das fÃƒÂ­sicas de red (handover) y persistencia transaccional en Room.
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicaciÃƒÂ³n errÃƒÂ³nea de transferencias idÃƒÂ©nticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuraciÃƒÂ³n de Presence en la creaciÃƒÂ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza AutomÃƒÂ¡tica Segura" (OpciÃƒÂ³n A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una ÃƒÂºnica notificaciÃƒÂ³n persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | ÃƒÅ¡ltimo: S/ 15"), evitando saturar el lÃƒÂ­mite de Android bajo estrÃƒÂ©s [CR-012].
- [ ] App: admin | Tarea (Mejora UX/ÃƒÂconos): DiseÃƒÂ±ar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].
- [x] App: db | Tarea (FCM): Crear Script SQL `0043` para agregar columna `FcmToken` a dispositivos y programar Triggers Inteligentes (BEFORE DELETE, AFTER UPDATE) invocando pg_net [CR-008].
- [x] App: web | Tarea (FCM): Programar Edge Function `fcm-dispatcher` en TypeScript para comunicarse vÃƒÂ­a OAuth 2.0 con la API HTTP v1 de Google FCM [CR-008].
- [x] App: admin | Tarea (FCM): Instalar SDKs de Firebase en `build.gradle.kts`, ajustar `deploy.yml`, y programar `FCMReceiverService.kt` con parseo de payloads [CR-008].
- [x] App: admin | Tarea (FCM): Modificar `AuthRepository.kt` (Subida de Token, DesvinculaciÃƒÂ³n) y extirpar WebSockets. Ajustar UI (pantalla de bloqueo y estados FCM) [CR-008].

### Ãƒâ€°pica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseÃƒÂ±ar UI de resoluciÃƒÂ³n de conflictos.
- [x] App: viewer | Tarea: Integrar invocaciÃƒÂ³n de RPC `rpc_resolver_disputas` para mediaciÃƒÂ³n final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃƒÂ³stico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexiÃƒÂ³n Realtime y Delta Sync al retornar de background y ante transiciones de red fÃƒÂ­sica [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelaciÃƒÂ³n de listener al minimizar. Implementar cachÃƒÂ© local de sesiÃƒÂ³n en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [ ] App: viewer | Tarea (FCM): Implementar Camino 2 (Foreground Wake-up) optimizado para evitar peticiones REST de validaciÃƒÂ³n de permisos en cada SYNC_PAYMENTS y forzar recÃƒÂ¡lculo solo bajo SYNC_DEVICE_STATUS.
- [x] App: db | Tarea (Deuda TÃƒÆ’Ã‚Â©cnica): Elaborar y ejecutar un script de migraciÃƒÆ’Ã‚Â³n SQL ÃƒÆ’Ã‚Âºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÆ’Ã‚Â©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÆ’Ã‚Â³n.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’Ã‚Â¡biles).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.
- [x] App: web | Tarea (CR): Mejorar UX del estado Realtime en SidebarNav implementando matriz de 4 estados basados en red fÃƒÂ­sica (navigator.onLine) y ciclo de vida del socket.
### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [x] App: viewer | Tarea (CR): RediseÃƒÂ±o de cola unificada de notificaciones (TTS/Push/VibraciÃƒÂ³n), ritmo dinÃƒÂ¡mico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃƒÆ’Ã‚Â³n correctamente [CR-008].
- [x] App: viewer | Tarea (CR): DiseÃƒÆ’Ã‚Â±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃƒÆ’Ã‚Â±a y verificaciÃƒÆ’Ã‚Â³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### ÃƒÆ’Ã¢â‚¬Â°pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃƒÆ’Ã‚Â­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃƒÆ’Ã‚Â³n pÃƒÆ’Ã‚Âºblica para anÃƒÆ’Ã‚Â³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃƒÆ’Ã‚Â©cnica): Elaborar y ejecutar un script de migraciÃƒÆ’Ã‚Â³n SQL ÃƒÆ’Ã‚Âºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÆ’Ã‚Â©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÆ’Ã‚Â³n.

### ÃƒÆ’Ã¢â‚¬Â°pica: Portal Web y Cumplimiento (PerÃƒÆ’Ã‚Âº)
- [x] App: web | Tarea (Legal): DiseÃƒÆ’Ã‚Â±ar e implementar las pÃƒÆ’Ã‚Â¡ginas estÃƒÆ’Ã‚Â¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÆ’Ã‚Â¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÆ’Ã‚Â³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÆ’Ã‚Â­o de correo de confirmaciÃƒÆ’Ã‚Â³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### ÃƒÆ’Ã¢â‚¬Â°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÆ’Ã‚Â±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ãƒâ€šÃ‚Â°, la pestaÃƒÆ’Ã‚Â±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÆ’Ã‚Â³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÆ’Ã‚Â³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÆ’Ã‚Â³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÆ’Ã‚Â­as hÃƒÆ’able).
- [ ] App: web | Tarea (CR): Habilitar panel de Recompensas/Compensacin dentro de /superadmin/reclamaciones llamando al RPC justar_credito_superadmin con auto-vinculacin de IdContratante.
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.
- [x] App: web | Tarea (CR): Mejorar UX del estado Realtime en SidebarNav implementando matriz de 4 estados basados en red fÃƒÂ­sica (navigator.onLine) y ciclo de vida del socket.
### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃƒÂ³n.
- [ ] App: viewer | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permiso `FOREGROUND_SERVICE_SPECIAL_USE` del CentinelaService.
- [x] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃƒÂ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃƒÂ³n manual de fase Alpha/Beta en Google Play Console para el receptor.

### Ãƒâ€°pica: Infraestructura y Operaciones Cloud
- [x] App: web | Tarea (Infraestructura): MigraciÃƒÂ³n de despliegue en EasyPanel hacia nuevo VPS (31.220.50.238) por renovaciÃƒÂ³n anticipada y ahorro de costos de hosting, y actualizaciÃƒÂ³n de registros DNS en Namecheap para notificape.ryctech.dev.

### Tareas Generales (Por Priorizar)
- [x] **[TSK-001]** | App: Viewer | UI: RemociÃƒÆ’Ã‚Â³n de la verificaciÃƒÆ’Ã‚Â³n y solicitud obligatoria de optimizaciÃƒÆ’Ã‚Â³n de baterÃƒÆ’Ã‚Â­a (Google Play Policies).
- [x] **[CR-007]** | App: Admin | LÃƒÆ’Ã‚Â³gica: Actualizar el generador de notificaciones Mock para incluir `sbn.postTime` o un equivalente dinÃƒÆ’Ã‚Â¡mico en la generaciÃƒÆ’Ã‚Â³n del `IdSync`, a fin de evitar la deduplicaciÃƒÆ’Ã‚Â³n incorrecta en el receptor (Viewer).
- [x] **[CR-009]** | App: Web | UI/API: RediseÃƒÆ’Ã‚Â±o del Estado de ConexiÃƒÆ’Ã‚Â³n en detalle de dispositivo fÃƒÆ’Ã‚Â­sico vÃƒÆ’Ã‚Â­a Supabase Realtime Presence (escuchando el canal broadcast del app Admin).
- [x] **[CR-015]** | App: Web/DB | UI/API: Ampliar vista view_notificaciones_disputadas con metadatos de usuarios y ContenidoMsg, y rediseñar DisputaCard en el dashboard de clientes para permitir la desambiguación.


## [E3] Entregable 3: ExpansiÃƒÂ³n de Negocio B2B (CR-014)

### Ãƒâ€°pica: Base de Datos y FacturaciÃƒÂ³n Modular (App: db)
- [x] Crear script `0035_addons_y_custom_plans.sql` aÃƒÂ±adiendo `IdContratanteExclusivo`, `PermiteAddons`, y precios extra a `Licencias`. Y columnas `ExtraUsuarios`, `ExtraDispositivos` a `LicenciasXContratante`.
- [x] Actualizar trigger `check_user_limit` y afines para que sumen `Limite + Extra` leyendo de la instancia de `LicenciasXContratante` activa.
- [x] Crear funciÃƒÂ³n RPC `procesar_compra_addon` que asigne el saldo en crÃƒÂ©dito y actualice los campos Extra de la licencia (con lÃƒÂ³gica de ticket mÃƒÂ­nimo).
- [x] Tarea (CR-014): Modificar motor de compras (previsualizar y ejecutar) para considerar add-ons e implementar motor automÃƒÂ¡tico de colas con pg_cron.

### Ãƒâ€°pica: Panel de Usuario y Superadmin (Frontend)
- [x] App: web | Tarea (CR-014): Actualizar DTOs en `actions_control.ts` y `dispositivos/actions.ts` para leer y sumar los campos `ExtraUsuarios` y `ExtraDispositivos` de la base de datos al validar lÃƒÂ­mites.
- [x] App: web | Tarea (CR-014): Implementar UI en el Dashboard de cliente para "Adquirir Usuarios/Dispositivos Extra", conectando a la funciÃƒÂ³n RPC de compra.
- [ ] App: web | Tarea (CR-014): Construir vista en `/superadmin/licencias` para que el Superadmin pueda crear "Planes Custom" aislando a un `IdContratanteExclusivo` y fijar precios manuales.
- [ ] App: web | Tarea (CR-014): Modificar `PricingCards.tsx` para ocultar planes corporativos al pÃƒÂºblico general y renderizarlos solo si el UUID coincide.
- [x] App: web/db | Tarea (Pendiente): Reforzar a nivel de servidor (`actions.ts`) y base de datos la inyecciÃƒÂ³n automÃƒÂ¡tica del diferencial (Vuelto) como saldo a favor cuando se aplica el Ticket MÃƒÂ­nimo de 5 soles en el checkout de MercadoPago.
- [x] App: db/web | Tarea (CR-015 / Fix): RegularizaciÃ³n del Motor de Colas de Licencias (CorrecciÃ³n de Check Constraint de estado 'APLICADA', aislamiento transaccional de excepciones en pg_cron diario, activaciÃ³n reactiva Just-In-Time en DashboardLayout/licencias y temporizador global de auto-refresh en AccessGuard).

## [E4] Entregable 4: Motor DinÃƒÂ¡mico de Regex y EstandarizaciÃƒÂ³n (Zero-Downtime)

### Ãƒâ€°pica: AplicaciÃƒÂ³n Web (Superadmin y Cliente)
- [x] App: web | Tarea: Crear UI 'Simulador Regex' en el Superadmin que tome el `PayloadBruto` (JSON) de notificaciones en estado 'REVISION', reconstruya el string concatenado en pantalla y evalÃƒÂºe la Regex en vivo.
- [ ] App: web | Tarea: Implementar UI 'Previsualizador de Mensaje' que aplique el `FormatoMensaje` sobre las variables extraÃƒÂ­das (Grupos Nombrados) en el simulador.
- [ ] App: web | Tarea: Agregar botÃƒÂ³n y conexiÃƒÂ³n a la Edge Function `reprocesar-notificaciones` para re-evaluar registros 'REVISION' tras guardar una regla.
- [x] App: web | Tarea: Modificar la UI de "Mis Billeteras" (Cliente) para que en el selector de asignaciÃƒÂ³n **solo** se listen billeteras que tengan al menos una regla activa con `VersionMotor = 2`.
- [ ] App: web | Tarea (Admin): Crear herramienta de limpieza masiva (Hard Delete) en el Superadmin para remover de DB y Storage las billeteras legacy inactivas.
- [ ] App: web | Tarea (Futuro): Desarrollar CRUD completo para la gestiÃƒÂ³n de Billeteras en el Superadmin. Considera alta complejidad tÃƒÂ©cnica (validaciones de integridad referencial, eliminaciÃƒÂ³n en cascada segura considerando asignaciones previas a usuarios y filtros) para no romper registros histÃƒÂ³ricos.

### Ãƒâ€°pica: Emisor Android (Admin)
- [x] App: admin | Tarea: Eliminar cÃƒÂ³digo duro de Lemon Pay en el servicio de evaluaciÃƒÂ³n.
- [x] App: admin | Tarea: Implementar generaciÃƒÂ³n del String de EvaluaciÃƒÂ³n concatenado (`[TITLE]...[TEXT]...`) en memoria RAM y ejecuciÃƒÂ³n de Regex con Grupos de Captura Nombrados.
- [x] App: admin | Tarea: Mapear variables extraÃƒÂ­das e interpolarlas con el `FormatoMensaje` antes de guardar `ContenidoMsg`.
- [x] App: admin | Tarea: Actualizar consulta DAO/Repository para descargar ÃƒÂºnicamente las reglas con `VersionMotor = 2`.
- [x] App: admin | Tarea: Modificar herramienta local 'Mensaje Mock' y capturar el PayloadBruto.

### Ãƒâ€°pica: Base de Datos y Backend
- [ ] App: db | Tarea: Crear script de migraciÃƒÂ³n aÃƒÂ±adiendo `TipoFiltro`, `FormatoMensaje`, `VersionMotor` a `FiltrosXBilletera` y `PayloadBruto` a `NotificacionesXDispositivo`.
- [ ] App: db | Tarea: Crear script inicial para duplicar las reglas vigentes de Yape y Lemon al formato concatenado bajo `VersionMotor = 2`.
- [ ] App: db | Tarea: Implementar Edge Function (Deno/TypeScript) `reprocesar-notificaciones` para recorrer y procesar con Regex (JS) las notificaciones en estado 'REVISION' y promoverlas a 'PENDIENTE'.

## [E5] Entregable 5: Sistema Integral de Onboarding y Usabilidad

### Hito 1: Hub de Descargas y Resiliencia de Accesos
- [x] App: web | **[TSK-016]** UI: Desarrollar `DownloadHubModal.tsx` con selector bitemÃƒÂ¡tico (Dark/Light) para App Emisor y App Receptor, cÃƒÂ³digos QR dinÃƒÂ¡micos para descarga directa desde celular, temporizador de descarga de APK, link a tiendas oficiales y botÃƒÂ³n para compartir enlace de instalaciÃƒÂ³n a cajeros vÃƒÂ­a mensajerÃƒÂ­a (sin marcas comerciales en cÃƒÂ³digo duro).
- [x] App: web | **[TSK-017]** NavegaciÃƒÂ³n: Integrar disparadores del Hub de Descargas en `SidebarNav.tsx` (versiÃƒÂ³n desktop y sheet mobile) y en el encabezado `DashboardHeader.tsx`.
- [x] App: web | **[TSK-018]** Seguridad/UX: Refactorizar `AccessGuard.tsx` y `licencias/page.tsx` para incorporar banner superior informativo contextual ante redirecciÃƒÂ³n por plan expirado o cuenta sin licencia activa.
- [x] App: web | **[TSK-019]** UI: RediseÃƒÂ±ar Empty States en `/dashboard/dispositivos` y `/dashboard/accesos` con micro-guÃƒÂ­as visuales y botones CTA directos para crear cajas y gestionar autorizaciones.

### Hito 2: Widget Setup Checklist en Dashboard
- [x] App: web | **[TSK-020]** Backend/DTO: Extender `fetchControlCenterStats` en `actions_control.ts` para calcular reactivamente los 4 estados de configuraciÃƒÂ³n inicial (perfil completado, licencia activa, cajas creadas, terminales/vendedores vinculados).
- [x] App: web | **[TSK-021]** UI: Construir el componente `SetupChecklist.tsx` en `/dashboard` con barra de progreso porcentual, estados interactivos (Checks/Botones), persistencia de colapso y dismiss en `localStorage`, y soporte Dark/Light.
- [x] App: web | **[TSK-022]** IntegraciÃƒÂ³n: Integrar `SetupChecklist.tsx` en `DashboardClient.tsx` arriba de las tarjetas de mÃƒÂ©tricas.

### Hito 3: Panel Lateral de Ayuda (Help Drawer) y Tour Interactivo Spotlight
- [x] App: web | **[TSK-023]** UI: Construir `HelpDrawer.tsx` (Panel lateral tipo `Sheet`) con detecciÃƒÂ³n de ruta activa (`pathname`), acordeones bitemÃƒÂ¡ticos de FAQs contextuales por secciÃƒÂ³n (Dashboard, Dispositivos, Accesos, Notificaciones) y accesos directos al Hub de Descargas y Tour.
- [x] App: web | **[TSK-024]** UI/Motor: Implementar el motor de tour interactivo `SpotlightTour.tsx` (overlay con backdrop y tooltips inteligentes bitemÃƒÂ¡ticos) para el recorrido general del Dashboard y mini-tours contextuales.
- [x] App: web | **[TSK-025]** NavegaciÃƒÂ³n/Estado: Montar el sistema de ayuda en `dashboard/layout.tsx` con trigger flotante e implementar la lÃƒÂ³gica de persistencia (`COMPLETED`, `IN_PROGRESS`, `DISMISSED`) y reanudaciÃƒÂ³n ante interrupciones.
- [x] App: web | **[TSK-025B]** UI/UX: Refactorizar SpotlightTour a tarjeta compacta flotante y arrastrable (Draggable) en desktop con modo dock inferior en mÃƒÂ³vil, tours condicionales multi-vista (actividad en dashboard, anatomÃƒÂ­a directa en detalle de dispositivo, personalizaciÃƒÂ³n en gestiÃƒÂ³n de licencias) y desacoplamiento de acordeones en /dashboard/licencias.

### Hito 4: InducciÃƒÂ³n, Onboarding y Tours en Aplicaciones MÃƒÂ³viles

#### Sub-Hito 4.1: App Admin (Emisor - Android / Jetpack Compose)
- [x] App: admin | **[TSK-026C]** Notificaciones de Sistema (Smart Diffing): Implementar motor de notificaciones locales para eventos administrativos recibidos vÃ­a FCM (UNBIND, Status, Rules, Wallets), utilizando diffing local en los repositorios para evitar spam offline.
- [x] App: admin | **[TSK-025C]** RefactorizaciÃ³n UI Dashboard (Change Request): Homologar interfaz del Dashboard con la App Viewer, implementando "Bloques Gemelos" (Selector de Fecha y PÃ­ldora de RecaudaciÃ³n al 50%), corrigiendo Ripple Effects nativos y aÃ±adiendo el nombre del contratante obtenido vÃ­a JOIN en Supabase.
- [ ] App: admin | **[TSK-026A]** Spotlight Tour Principal: Implementar recorrido guiado (Tour Interactivo) paso a paso en la pantalla principal (Dashboard). Debe activarse post-vinculaciÃƒÂ³n, resaltando el interruptor del Foreground Service y el monitor de billeteras activas (basado exclusivamente en componentes de producciÃƒÂ³n/release, ignorando secciones debug).
- [ ] App: admin | **[TSK-026B]** MÃƒÂ³dulo de Ayuda y Persistencia (Help Drawer): Desarrollar un panel de ayuda (Bottom Sheet o Navigation Drawer) similar al proyecto Web, incluyendo respuestas a FAQs y un botÃƒÂ³n para re-lanzar el "Spotlight Tour". Persistir el estado de completitud del tour en DataStore.

#### Sub-Hito 4.2: App Viewer (Receptor - Android / Jetpack Compose)
- [ ] App: viewer | **[TSK-027A]** Onboarding Carousel: DiseÃƒÂ±ar carrusel de inducciÃƒÂ³n para personal y cajeros explicando las alertas inmediatas en caja ante transferencias Yape/Plin.
- [x] App: viewer | **[TSK-027B]** VinculaciÃƒÂ³n y Espera: DiseÃƒÂ±ar flujo de escaneo QR de caja para solicitar acceso y pantalla reactiva con animaciÃƒÂ³n de espera (*"Esperando aprobaciÃƒÂ³n del administrador"*).
- [-] App: viewer | **[TSK-027C]** CalibraciÃƒÂ³n de Audio/TTS: MÃƒÂ³dulo interactivo de prueba de sonido y sÃƒÂ­ntesis de voz ("Yape recibido: S/ 20") para verificar volumen y motor TTS antes de operar.
 (DESCARTADO)
- [ ] App: viewer | **[TSK-027D]** Spotlight Tour Principal: Implementar tour guiado en la pantalla de historial resaltando la tarjeta del ÃƒÂºltimo pago, filtros por dispositivo y ajustes de audio.
- [ ] App: viewer | **[TSK-027E]** Persistencia y Ayuda: Guardar el estado de inducciÃƒÂ³n en DataStore y agregar la opciÃƒÂ³n de reinicio de tour en el menÃƒÂº de ConfiguraciÃƒÂ³n.
- [ ] App: viewer | **[TSK-027F]** Cierre de Jornada / Cuadres (FUTURO): Disenar flujo y vista para cuadrar caja.



## [E6] Entregable 6: RefactorizaciÃƒÂ³n Push-to-Pull (FCM) en Viewer

### Ãƒâ€°pica 1: ConfiguraciÃƒÂ³n Cloud y GestiÃƒÂ³n de Tokens
- [x] App: viewer | Tarea 1.1: Configurar Firebase Console (AÃƒÂ±adir app Viewer), descargar google-services.json y actualizar dependencias a nivel de build.gradle.
- [x] App: db | Tarea 1.2: Crear script de migraciÃƒÂ³n SQL ( 044_fcm_tokens_viewer.sql) para agregar columna FcmToken a la tabla Usuarios. 
- [x] App: viewer | Tarea 1.3: En el Login de Google en el app Viewer, forzar siempre un UPDATE a la tabla Usuarios con el token FCM generado.
  - [x] App: viewer | **[TSK-028]** RediseÃ±o Adaptativo de Cola FCM (Smart Batching): Implementar SupresiÃ³n Contextual en primer plano, inyecciÃ³n inmediata a la Bandeja del Sistema (Fase 1), y lÃ³gica de agrupaciÃ³n de voz/pop-up en bloque para rÃ¡fagas de 3+ notificaciones, superando el lÃ­mite de Wakelock (15s) de Android.
- [x] App: viewer | **[TSK-029]** Flujos de Notificaciones Secundarias y Feedback de Sistema:
  - **Billeteras y QRs (Bandeja Silenciosa):** Implementar notificaciones regulares (sin TTS/Pop-Up) separando dos conceptos: 1) Agregado/Quitado de billeteras (agrupado singular/plural). 2) EdiciÃ³n de URL/Imagen de cÃ³digo QR (canal crÃ­tico para cajeros).
  - **Control de Acceso (Voz y Pop-Up):** Notificar aprobaciones y revocaciones de acceso a cajas indicando "Tienda X, Caja Y". Debe despertar el dispositivo si estÃ¡ bloqueado.
  - **Disputas y Reclamos (Voz y Pop-Up):** Notificar cambios de estado en disputas en las que el cajero estÃ© involucrado.
  - **CondiciÃ³n Estricta (Respeto de UI):** Las alertas de Acceso y Disputas DEBEN obedecer los switches de preferencias del usuario (`isTtsEnabled`, `isHeadsUpEnabled`). Limpiar cÃ³digo muerto de notificaciÃ³n permanente residual.

### Ãƒâ€°pica 2: Desarrollo de Triggers Inteligentes (El Francotirador FCM)
- [x] App: db | Tarea 2.1 (Canal de Autorizaciones): Trigger en AutorizacionesXUsuario (UPDATE). Dispara Push {"action": "SYNC_AUTH"} al usuario afectado.
- [x] App: db | Tarea 2.2 (Canal de Nuevos Pagos): Trigger en NotificacionesXDispositivo (INSERT/UPDATE). Dispara Push {"action": "SYNC_PAYMENTS"} a todos los usuarios aprobados para ese IdDispositivo.
- [x] App: db | Tarea 2.3 (Canal de Reclamos y Disputas): Trigger en NotificacionesAUsuarios (INSERT/UPDATE/DELETE). Dispara Push {"action": "SYNC_PAYMENTS"} a la caja respectiva.
- [x] App: db | Tarea 2.4 (Canal de ConfiguraciÃƒÂ³n de Cajas/QRs): Trigger en BilleterasXDispositivo (INSERT/UPDATE/DELETE). Dispara Push {"action": "SYNC_WALLETS"} a los cajeros para forzar la actualizaciÃƒÂ³n del QR.

### Ãƒâ€°pica 3: ExtirpaciÃƒÂ³n del Core Realtime y Limpieza Profunda (App Viewer)
- [x] App: viewer | Tarea 3.1: Eliminar Panel de DiagnÃƒÂ³stico (RealtimeAuditDialog.kt). Eliminar botÃƒÂ³n de AuditorÃƒÂ­a ("Wifi") en VinculacionHeader.kt.
- [x] App: viewer | Tarea 3.2: Eliminar el Foreground Service: Borrar completamente CentinelaService.kt y CentinelaStateObserver.kt. 
- [x] App: viewer | Tarea 3.3: Eliminar lÃƒÂ³gica de Sockets: Borrar RealtimeCoordinator.kt, DiagnosticsManager.kt y todas las clases RealtimeDataSource.

### Ãƒâ€°pica 4: ImplementaciÃƒÂ³n Push-to-Pull y Motor de Alertas
- [x] App: viewer | Tarea 4.1: Crear FCMReceiverService.kt. Instanciar interceptaciÃƒÂ³n en background.
- [x] App: viewer | Tarea 4.2: Refactorizar repositorios. Convertir flujos de Supabase a SharedFlow locales y hacer Pull REST al recibir Push de FCMReceiverService.kt. (Transformado a True Data-Push).
- [x] App: viewer | Tarea 4.3: Enlazar el disparo de alertas de pago (TTS de voz y Pop-ups HeadsUp) al final exitoso de la descarga HTTP.
- [x] App: viewer | Tarea 4.4: Refactorizar CentinelaNotificationManager.kt a una Cola circular FIFO (10 notificaciones mÃƒÂ¡x).

### Ãƒâ€°pica 5: RefactorizaciÃƒÂ³n UI/UX, Loaders y Resiliencia (App Viewer)
- [x] App: viewer | Tarea 5.1: Refactorizar EsperaAprobacionScreen a vista pasiva. Al recibir Push de aprobaciÃƒÂ³n, auto-redireccionar al Dashboard (NavegaciÃƒÂ³n Cero-Sockets).
- [x] App: viewer | Tarea 5.2: Refactorizar botÃƒÂ³n "Desvincular". Ejecutar HTTP REST e invalidar sesiÃƒÂ³n inmediatamente.
- [x] App: viewer | Tarea 5.3: Eliminar ConnectionPill ("En LÃƒÂ­nea").
- [x] App: viewer | Tarea 5.4: Integrar NetworkMonitor.kt en la capa visual (Loaders de Auto-recuperaciÃƒÂ³n).


### Ãƒâ€°pica 6: Deuda TÃƒÂ©cnica y Limpieza Global (IsConnected)
- [ ] App: db | Tarea 6.1 (Deuda TÃƒÂ©cnica): Evaluar la eliminaciÃƒÂ³n del campo `IsConnected` en la tabla `AutorizacionesXUsuario` ya que el estado "En LÃƒÂ­nea" ha sido reemplazado por la entrega pasiva de FCM, ahorrando costos de escritura (UPDATEs).
- [x] App: web/admin | Tarea 6.2 (Deuda TÃƒÂ©cnica): Auditar los proyectos Web y Admin para remover cualquier indicador de "Puntito Verde" o estado de conexiÃƒÂ³n en vivo que dependa del campo `IsConnected`. Priorizar el uso del estado `IdEstadoAuth` para la gestiÃƒÂ³n de usuarios.
- [x] App: web | Tarea: Implementar UI y Base de Datos para captaciÃ³n de Beta Testers (Landing y Panel Superadmin) para Google Play Closed Testing.
- [x] App: web | Tarea: Reestructuración comercial de la Landing Page (eliminación de tecnicismos Beta), modal de beneficios/promociones con centrado simétrico para 720p/1080p, layout de 2 columnas simétricas con validaciones reactivas en formulario y resolución de FOUC en modo oscuro.

- [x] App: admin | Tarea 6.3 (Bug/UI): Corregir parpadeo de permisos y falsas expulsiones en reinstalaciones, desactivando Auto-Backup y condicionando la capa de permisos al estado validado.










### Ã‰pica 7: Motor DinÃ¡mico de Recompensas y Promociones (PLG)
- [ ] App: db | Tarea 7.1: Crear tabla CampanasPromocionales (IdCampana, TipoEvento, Prioridad, MontoCreditos, Fechas) para centralizar la configuraciÃ³n de promociones sin *hardcoding*.
- [ ] App: db | Tarea 7.2: Crear tabla CodigosPromocionales y vincularla a la lÃ³gica de referidos bilaterales.
- [x] App: db/web | Tarea 7.3: Implementar Edge Function / Trigger para evaluaciÃ³n atÃ³mica de campaÃ±as en el registro e inyectar el ABONO automÃ¡tico.
egistrar_tx_credito.
- [ ] App: web | Tarea 7.4: Desarrollar mÃ³dulo CRUD en el panel Superadmin para gestionar, habilitar y priorizar las campaÃ±as dinÃ¡micas.
- [x] App: web | Tarea 7.5: Adaptar UI de Registro para aceptar cÃ³digos de invitaciÃ³n y crear componente dinÃ¡mico (GlobalAnnouncementModal) en el Dashboard.


### Ã‰pica 10: Motor Centralizado de Anuncios y Novedades (SaaS)
- [ ] App: db/web | Tarea 10.1: Crear tabla CampanasInformativas en Supabase y panel CRUD en Superadmin para redactar y disparar avisos remotos.
- [ ] App: web | Tarea 10.2: Conectar GlobalAnnouncementModal a la tabla de avisos para despliegue dinÃ¡mico.

### Ã‰pica 11: Mejora UX/UI del Gestor de Accesos y Dispositivos
- [x] App: web | Tarea 11.1: Refactorizar la vista de gestiÃ³n de accesos (/dashboard/accesos) agrupando los usuarios por dispositivo asignado con orden alfabÃ©tico A-Z estable, bandeja de atenciÃ³n inmediata de pendientes y menÃº desplegable de ordenamiento con icono de filtro.
- [x] App: web | Tarea 11.2: Implementar modales de confirmaciÃ³n para acciones crÃ­ticas (Aprobar, Bloquear y sustituciÃ³n en lÃ­mite de cupo) con botones filled sÃ³lidos de alto contraste previniendo clics accidentales.

### [E7] Bugs y Pulido (Detectados en QA)
- [x] **TSK-031:** Arreglar paleta de colores de billeteras en la UI (BCP sin color, Scotiabank con color de BBVA). Revisar Billeteras master o mapeo de UI.
- [x] **TSK-032:** Arreglar silencio de notificaciones propias en Impugnaciones. El trigger de NotificacionesXDispositivo (al pasar a 'REVISION') no tiene cmo saber qu usuario hizo la accin, por lo que evade el filtro de silencio en Android. Adems, auditar por qu llega "Actualizacin de Reclamo" en lugar de NEW_CLAIM.
- [x] **TSK-033:** Filtrado y blindaje de notificaciones sin monto / REVISION en Viewer y Supabase (Eliminación de falsos pagos S/ 0.00).
