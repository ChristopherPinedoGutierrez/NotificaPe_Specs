# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃƒÂ³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃƒÂ³n

### Ãƒâ€°pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃƒÂ³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÂºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÂ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÂ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÂ³n' para remover el lÃƒÂ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ãƒâ€°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÂ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: web | Tarea (CR): Crear bucket pÃºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃ³n' para remover el lÃ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ã‰pica: Emisor
- [x] App: admin | Tarea: Implementar lÃ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rÃ¡pidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activaciÃ³n y billeteras dinÃ¡micas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticaciÃ³n de terminales mediante JWT Ãºnico por dispositivo y eliminaciÃ³n de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integraciÃ³n (androidTest) para simular caÃ­das fÃ­sicas de red (handover) y persistencia transaccional en Room.
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicaciÃ³n errÃ³nea de transferencias idÃ©nticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuraciÃ³n de Presence en la creaciÃ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza AutomÃ¡tica Segura" (OpciÃ³n A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una Ãºnica notificaciÃ³n persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | Ãšltimo: S/ 15"), evitando saturar el lÃ­mite de Android bajo estrÃ©s [CR-012].
- [ ] App: admin | Tarea (Mejora UX/Ãconos): DiseÃ±ar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].

### Ã‰pica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseÃ±ar UI de resoluciÃ³n de conflictos.
- [x] App: viewer | Tarea: Integrar invocaciÃ³n de RPC `rpc_resolver_disputas` para mediaciÃ³n final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃ³stico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexiÃ³n Realtime y Delta Sync al retornar de background y ante transiciones de red fÃ­sica [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelaciÃ³n de listener al minimizar. Implementar cachÃ© local de sesiÃ³n en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [x] App: db | Tarea (Deuda TÃƒÂ©cnica): Elaborar y ejecutar un script de migraciÃƒÂ³n SQL ÃƒÂºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÂ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÂ³n.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒÂ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [x] App: viewer | Tarea (CR): RediseÃ±o de cola unificada de notificaciones (TTS/Push/VibraciÃ³n), ritmo dinÃ¡mico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃƒÂ³n correctamente [CR-008].
- [ ] App: viewer | Tarea (CR): DiseÃƒÂ±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃƒÂ±a y verificaciÃƒÂ³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### Ãƒâ€°pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃƒÂ­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃƒÂ³n pÃƒÂºblica para anÃƒÂ³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃƒÂ©cnica): Elaborar y ejecutar un script de migraciÃƒÂ³n SQL ÃƒÂºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÂ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÂ³n.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒÂ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃƒÂ³n.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃƒÂ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃƒÂ³n manual de fase Alpha/Beta en Google Play Console para el receptor.
# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃƒÂ³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃƒÂ³n

### Ãƒâ€°pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃƒÂ³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÂºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÂ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÂ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÂ³n' para remover el lÃƒÂ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ãƒâ€°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÂ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: web | Tarea (CR): Crear bucket pÃºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃ³n' para remover el lÃ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ã‰pica: Emisor
- [x] App: admin | Tarea: Implementar lÃ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rÃ¡pidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activaciÃ³n y billeteras dinÃ¡micas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticaciÃ³n de terminales mediante JWT Ãºnico por dispositivo y eliminaciÃ³n de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integraciÃ³n (androidTest) para simular caÃ­das fÃ­sicas de red (handover) y persistencia transaccional en Room.
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicaciÃ³n errÃ³nea de transferencias idÃ©nticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuraciÃ³n de Presence en la creaciÃ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza AutomÃ¡tica Segura" (OpciÃ³n A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una Ãºnica notificaciÃ³n persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | Ãšltimo: S/ 15"), evitando saturar el lÃ­mite de Android bajo estrÃ©s [CR-012].
- [ ] App: admin | Tarea (Mejora UX/Ãconos): DiseÃ±ar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].
- [x] App: db | Tarea (FCM): Crear Script SQL `0043` para agregar columna `FcmToken` a dispositivos y programar Triggers Inteligentes (BEFORE DELETE, AFTER UPDATE) invocando pg_net [CR-008].
- [x] App: web | Tarea (FCM): Programar Edge Function `fcm-dispatcher` en TypeScript para comunicarse vÃ­a OAuth 2.0 con la API HTTP v1 de Google FCM [CR-008].
- [x] App: admin | Tarea (FCM): Instalar SDKs de Firebase en `build.gradle.kts`, ajustar `deploy.yml`, y programar `FCMReceiverService.kt` con parseo de payloads [CR-008].
- [x] App: admin | Tarea (FCM): Modificar `AuthRepository.kt` (Subida de Token, DesvinculaciÃ³n) y extirpar WebSockets. Ajustar UI (pantalla de bloqueo y estados FCM) [CR-008].

### Ã‰pica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseÃ±ar UI de resoluciÃ³n de conflictos.
- [x] App: viewer | Tarea: Integrar invocaciÃ³n de RPC `rpc_resolver_disputas` para mediaciÃ³n final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃ³stico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexiÃ³n Realtime y Delta Sync al retornar de background y ante transiciones de red fÃ­sica [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelaciÃ³n de listener al minimizar. Implementar cachÃ© local de sesiÃ³n en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [x] App: db | Tarea (Deuda TÃƒÂ©cnica): Elaborar y ejecutar un script de migraciÃƒÂ³n SQL ÃƒÂºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÂ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÂ³n.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒÂ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [x] App: viewer | Tarea (CR): RediseÃ±o de cola unificada de notificaciones (TTS/Push/VibraciÃ³n), ritmo dinÃ¡mico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃƒÂ³n correctamente [CR-008].
- [x] App: viewer | Tarea (CR): DiseÃƒÂ±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃƒÂ±a y verificaciÃƒÂ³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### Ãƒâ€°pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃƒÂ­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃƒÂ³n pÃƒÂºblica para anÃƒÂ³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃƒÂ©cnica): Elaborar y ejecutar un script de migraciÃƒÂ³n SQL ÃƒÂºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÂ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÂ³n.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒable).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃ³n.
- [ ] App: viewer | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permiso `FOREGROUND_SERVICE_SPECIAL_USE` del CentinelaService.
- [x] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃ³n manual de fase Alpha/Beta en Google Play Console para el receptor.

### Ã‰pica: Infraestructura y Operaciones Cloud
- [x] App: web | Tarea (Infraestructura): MigraciÃ³n de despliegue en EasyPanel hacia nuevo VPS (31.220.50.238) por renovaciÃ³n anticipada y ahorro de costos de hosting, y actualizaciÃ³n de registros DNS en Namecheap para notificape.ryctech.dev.

### Tareas Generales (Por Priorizar)
- [x] **[TSK-001]** | App: Viewer | UI: RemociÃƒÂ³n de la verificaciÃƒÂ³n y solicitud obligatoria de optimizaciÃƒÂ³n de baterÃƒÂ­a (Google Play Policies).
- [x] **[CR-007]** | App: Admin | LÃƒÂ³gica: Actualizar el generador de notificaciones Mock para incluir `sbn.postTime` o un equivalente dinÃƒÂ¡mico en la generaciÃƒÂ³n del `IdSync`, a fin de evitar la deduplicaciÃƒÂ³n incorrecta en el receptor (Viewer).
- [x] **[CR-009]** | App: Web | UI/API: RediseÃƒÂ±o del Estado de ConexiÃƒÂ³n en detalle de dispositivo fÃƒÂ­sico vÃƒÂ­a Supabase Realtime Presence (escuchando el canal broadcast del app Admin).

## [E3] Entregable 3: ExpansiÃ³n de Negocio B2B (CR-014)

### Ã‰pica: Base de Datos y FacturaciÃ³n Modular (App: db)
- [x] Crear script `0035_addons_y_custom_plans.sql` aÃ±adiendo `IdContratanteExclusivo`, `PermiteAddons`, y precios extra a `Licencias`. Y columnas `ExtraUsuarios`, `ExtraDispositivos` a `LicenciasXContratante`.
- [x] Actualizar trigger `check_user_limit` y afines para que sumen `Limite + Extra` leyendo de la instancia de `LicenciasXContratante` activa.
- [x] Crear funciÃ³n RPC `procesar_compra_addon` que asigne el saldo en crÃ©dito y actualice los campos Extra de la licencia (con lÃ³gica de ticket mÃ­nimo).
- [x] Tarea (CR-014): Modificar motor de compras (previsualizar y ejecutar) para considerar add-ons e implementar motor automÃ¡tico de colas con pg_cron.

### Ã‰pica: Panel de Usuario y Superadmin (Frontend)
- [x] App: web | Tarea (CR-014): Actualizar DTOs en `actions_control.ts` y `dispositivos/actions.ts` para leer y sumar los campos `ExtraUsuarios` y `ExtraDispositivos` de la base de datos al validar lÃ­mites.
- [x] App: web | Tarea (CR-014): Implementar UI en el Dashboard de cliente para "Adquirir Usuarios/Dispositivos Extra", conectando a la funciÃ³n RPC de compra.
- [ ] App: web | Tarea (CR-014): Construir vista en `/superadmin/licencias` para que el Superadmin pueda crear "Planes Custom" aislando a un `IdContratanteExclusivo` y fijar precios manuales.
- [ ] App: web | Tarea (CR-014): Modificar `PricingCards.tsx` para ocultar planes corporativos al pÃºblico general y renderizarlos solo si el UUID coincide.
- [x] App: web/db | Tarea (Pendiente): Reforzar a nivel de servidor (`actions.ts`) y base de datos la inyecciÃ³n automÃ¡tica del diferencial (Vuelto) como saldo a favor cuando se aplica el Ticket MÃ­nimo de 5 soles en el checkout de MercadoPago.

## [E4] Entregable 4: Motor DinÃ¡mico de Regex y EstandarizaciÃ³n (Zero-Downtime)

### Ã‰pica: AplicaciÃ³n Web (Superadmin y Cliente)
- [x] App: web | Tarea: Crear UI 'Simulador Regex' en el Superadmin que tome el `PayloadBruto` (JSON) de notificaciones en estado 'REVISION', reconstruya el string concatenado en pantalla y evalÃºe la Regex en vivo.
- [ ] App: web | Tarea: Implementar UI 'Previsualizador de Mensaje' que aplique el `FormatoMensaje` sobre las variables extraÃ­das (Grupos Nombrados) en el simulador.
- [ ] App: web | Tarea: Agregar botÃ³n y conexiÃ³n a la Edge Function `reprocesar-notificaciones` para re-evaluar registros 'REVISION' tras guardar una regla.
- [x] App: web | Tarea: Modificar la UI de "Mis Billeteras" (Cliente) para que en el selector de asignaciÃ³n **solo** se listen billeteras que tengan al menos una regla activa con `VersionMotor = 2`.
- [ ] App: web | Tarea (Admin): Crear herramienta de limpieza masiva (Hard Delete) en el Superadmin para remover de DB y Storage las billeteras legacy inactivas.
- [ ] App: web | Tarea (Futuro): Desarrollar CRUD completo para la gestiÃ³n de Billeteras en el Superadmin. Considera alta complejidad tÃ©cnica (validaciones de integridad referencial, eliminaciÃ³n en cascada segura considerando asignaciones previas a usuarios y filtros) para no romper registros histÃ³ricos.

### Ã‰pica: Emisor Android (Admin)
- [x] App: admin | Tarea: Eliminar cÃ³digo duro de Lemon Pay en el servicio de evaluaciÃ³n.
- [x] App: admin | Tarea: Implementar generaciÃ³n del String de EvaluaciÃ³n concatenado (`[TITLE]...[TEXT]...`) en memoria RAM y ejecuciÃ³n de Regex con Grupos de Captura Nombrados.
- [x] App: admin | Tarea: Mapear variables extraÃ­das e interpolarlas con el `FormatoMensaje` antes de guardar `ContenidoMsg`.
- [x] App: admin | Tarea: Actualizar consulta DAO/Repository para descargar Ãºnicamente las reglas con `VersionMotor = 2`.
- [x] App: admin | Tarea: Modificar herramienta local 'Mensaje Mock' y capturar el PayloadBruto.

### Ã‰pica: Base de Datos y Backend
- [ ] App: db | Tarea: Crear script de migraciÃ³n aÃ±adiendo `TipoFiltro`, `FormatoMensaje`, `VersionMotor` a `FiltrosXBilletera` y `PayloadBruto` a `NotificacionesXDispositivo`.
- [ ] App: db | Tarea: Crear script inicial para duplicar las reglas vigentes de Yape y Lemon al formato concatenado bajo `VersionMotor = 2`.
- [ ] App: db | Tarea: Implementar Edge Function (Deno/TypeScript) `reprocesar-notificaciones` para recorrer y procesar con Regex (JS) las notificaciones en estado 'REVISION' y promoverlas a 'PENDIENTE'.

## [E5] Entregable 5: Sistema Integral de Onboarding y Usabilidad

### Hito 1: Hub de Descargas y Resiliencia de Accesos
- [x] App: web | **[TSK-016]** UI: Desarrollar `DownloadHubModal.tsx` con selector bitemÃ¡tico (Dark/Light) para App Emisor y App Receptor, cÃ³digos QR dinÃ¡micos para descarga directa desde celular, temporizador de descarga de APK, link a tiendas oficiales y botÃ³n para compartir enlace de instalaciÃ³n a cajeros vÃ­a mensajerÃ­a (sin marcas comerciales en cÃ³digo duro).
- [x] App: web | **[TSK-017]** NavegaciÃ³n: Integrar disparadores del Hub de Descargas en `SidebarNav.tsx` (versiÃ³n desktop y sheet mobile) y en el encabezado `DashboardHeader.tsx`.
- [x] App: web | **[TSK-018]** Seguridad/UX: Refactorizar `AccessGuard.tsx` y `licencias/page.tsx` para incorporar banner superior informativo contextual ante redirecciÃ³n por plan expirado o cuenta sin licencia activa.
- [x] App: web | **[TSK-019]** UI: RediseÃ±ar Empty States en `/dashboard/dispositivos` y `/dashboard/accesos` con micro-guÃ­as visuales y botones CTA directos para crear cajas y gestionar autorizaciones.

### Hito 2: Widget Setup Checklist en Dashboard
- [x] App: web | **[TSK-020]** Backend/DTO: Extender `fetchControlCenterStats` en `actions_control.ts` para calcular reactivamente los 4 estados de configuraciÃ³n inicial (perfil completado, licencia activa, cajas creadas, terminales/vendedores vinculados).
- [x] App: web | **[TSK-021]** UI: Construir el componente `SetupChecklist.tsx` en `/dashboard` con barra de progreso porcentual, estados interactivos (Checks/Botones), persistencia de colapso y dismiss en `localStorage`, y soporte Dark/Light.
- [x] App: web | **[TSK-022]** IntegraciÃ³n: Integrar `SetupChecklist.tsx` en `DashboardClient.tsx` arriba de las tarjetas de mÃ©tricas.

### Hito 3: Panel Lateral de Ayuda (Help Drawer) y Tour Interactivo Spotlight
- [x] App: web | **[TSK-023]** UI: Construir `HelpDrawer.tsx` (Panel lateral tipo `Sheet`) con detecciÃ³n de ruta activa (`pathname`), acordeones bitemÃ¡ticos de FAQs contextuales por secciÃ³n (Dashboard, Dispositivos, Accesos, Notificaciones) y accesos directos al Hub de Descargas y Tour.
- [x] App: web | **[TSK-024]** UI/Motor: Implementar el motor de tour interactivo `SpotlightTour.tsx` (overlay con backdrop y tooltips inteligentes bitemÃ¡ticos) para el recorrido general del Dashboard y mini-tours contextuales.
- [x] App: web | **[TSK-025]** NavegaciÃ³n/Estado: Montar el sistema de ayuda en `dashboard/layout.tsx` con trigger flotante e implementar la lÃ³gica de persistencia (`COMPLETED`, `IN_PROGRESS`, `DISMISSED`) y reanudaciÃ³n ante interrupciones.
- [x] App: web | **[TSK-025B]** UI/UX: Refactorizar SpotlightTour a tarjeta compacta flotante y arrastrable (Draggable) en desktop con modo dock inferior en mÃ³vil, tours condicionales multi-vista (actividad en dashboard, anatomÃ­a directa en detalle de dispositivo, personalizaciÃ³n en gestiÃ³n de licencias) y desacoplamiento de acordeones en /dashboard/licencias.

### Hito 4: InducciÃ³n, Onboarding y Tours en Aplicaciones MÃ³viles

#### Sub-Hito 4.1: App Admin (Emisor - Android / Jetpack Compose)
- [x] App: admin | **[TSK-026C]** Notificaciones de Sistema (Smart Diffing): Implementar motor de notificaciones locales para eventos administrativos recibidos vía FCM (UNBIND, Status, Rules, Wallets), utilizando diffing local en los repositorios para evitar spam offline.
- [x] App: admin | **[TSK-025C]** Refactorización UI Dashboard (Change Request): Homologar interfaz del Dashboard con la App Viewer, implementando "Bloques Gemelos" (Selector de Fecha y Píldora de Recaudación al 50%), corrigiendo Ripple Effects nativos y añadiendo el nombre del contratante obtenido vía JOIN en Supabase.
- [ ] App: admin | **[TSK-026A]** Spotlight Tour Principal: Implementar recorrido guiado (Tour Interactivo) paso a paso en la pantalla principal (Dashboard). Debe activarse post-vinculaciÃ³n, resaltando el interruptor del Foreground Service y el monitor de billeteras activas (basado exclusivamente en componentes de producciÃ³n/release, ignorando secciones debug).
- [ ] App: admin | **[TSK-026B]** MÃ³dulo de Ayuda y Persistencia (Help Drawer): Desarrollar un panel de ayuda (Bottom Sheet o Navigation Drawer) similar al proyecto Web, incluyendo respuestas a FAQs y un botÃ³n para re-lanzar el "Spotlight Tour". Persistir el estado de completitud del tour en DataStore.

#### Sub-Hito 4.2: App Viewer (Receptor - Android / Jetpack Compose)
- [ ] App: viewer | **[TSK-027A]** Onboarding Carousel: DiseÃ±ar carrusel de inducciÃ³n para personal y cajeros explicando las alertas inmediatas en caja ante transferencias Yape/Plin.
- [x] App: viewer | **[TSK-027B]** VinculaciÃ³n y Espera: DiseÃ±ar flujo de escaneo QR de caja para solicitar acceso y pantalla reactiva con animaciÃ³n de espera (*"Esperando aprobaciÃ³n del administrador"*).
- [-] App: viewer | **[TSK-027C]** CalibraciÃ³n de Audio/TTS: MÃ³dulo interactivo de prueba de sonido y sÃ­ntesis de voz ("Yape recibido: S/ 20") para verificar volumen y motor TTS antes de operar.
 (DESCARTADO)
- [ ] App: viewer | **[TSK-027D]** Spotlight Tour Principal: Implementar tour guiado en la pantalla de historial resaltando la tarjeta del Ãºltimo pago, filtros por dispositivo y ajustes de audio.
- [ ] App: viewer | **[TSK-027E]** Persistencia y Ayuda: Guardar el estado de inducciÃ³n en DataStore y agregar la opciÃ³n de reinicio de tour en el menÃº de ConfiguraciÃ³n.
- [ ] App: viewer | **[TSK-027F]** Cierre de Jornada / Cuadres (FUTURO): Disenar flujo y vista para cuadrar caja.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒÂ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.
- [x] App: web | Tarea (CR): Mejorar UX del estado Realtime en SidebarNav implementando matriz de 4 estados basados en red fÃ­sica (navigator.onLine) y ciclo de vida del socket.
### Ãƒâ€°pica: PolÃƒÂ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃƒÂ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃƒÂ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃƒÂ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃƒÂ³n.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃƒÂ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃƒÂ³n manual de fase Alpha/Beta en Google Play Console para el receptor.
# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃƒÂ³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃƒÂ³n

### Ãƒâ€°pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃƒÂ³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃƒÂºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃƒÂ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃƒÂ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃƒÂ³n' para remover el lÃƒÂ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ãƒâ€°pica: Emisor
- [x] App: admin | Tarea: Implementar lÃƒÂ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: web | Tarea (CR): Crear bucket pÃºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃ³n' para remover el lÃ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ã‰pica: Emisor
- [x] App: admin | Tarea: Implementar lÃ³gica Room-First y Worker Offline para resiliencia total.
- [x] App: admin | Tarea: Homogeneizar conectividad Realtime con el motor de Viewer (Watchdogs rÃ¡pidos, Backoff Exponencial y Scavenger de 5 min) [Hito 1].
- [x] App: admin | Tarea: Vincular Foreground Service con el estado de activaciÃ³n y billeteras dinÃ¡micas [Hito 2].
- [ ] App: admin | Tarea: Segurizar autenticaciÃ³n de terminales mediante JWT Ãºnico por dispositivo y eliminaciÃ³n de privilegios al rol anon en RLS [Hito 3].
- [x] App: admin | Tarea (CR): Implementar receptor de boot (BootReceiver) y permiso de reinicio para autoarrancar el Foreground Service de forma resiliente tras encender el celular [CR-002].
- [ ] App: admin | Tarea: Implementar suite de pruebas instrumentadas de integraciÃ³n (androidTest) para simular caÃ­das fÃ­sicas de red (handover) y persistencia transaccional en Room.
- [x] App: admin | Tarea (CR): Incluir timestamp (sbn.postTime) en el generador de IdSync (ExtractPaymentUseCase y TestLabHandler) para evitar la deduplicaciÃ³n errÃ³nea de transferencias idÃ©nticas repetidas en el tiempo [CR-007].
- [x] App: admin | Tarea (CR): Habilitar configuraciÃ³n de Presence en la creaciÃ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza AutomÃ¡tica Segura" (OpciÃ³n A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una Ãºnica notificaciÃ³n persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | Ãšltimo: S/ 15"), evitando saturar el lÃ­mite de Android bajo estrÃ©s [CR-012].
- [ ] App: admin | Tarea (Mejora UX/Ãconos): DiseÃ±ar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].
- [x] App: db | Tarea (FCM): Crear Script SQL `0043` para agregar columna `FcmToken` a dispositivos y programar Triggers Inteligentes (BEFORE DELETE, AFTER UPDATE) invocando pg_net [CR-008].
- [x] App: web | Tarea (FCM): Programar Edge Function `fcm-dispatcher` en TypeScript para comunicarse vÃ­a OAuth 2.0 con la API HTTP v1 de Google FCM [CR-008].
- [x] App: admin | Tarea (FCM): Instalar SDKs de Firebase en `build.gradle.kts`, ajustar `deploy.yml`, y programar `FCMReceiverService.kt` con parseo de payloads [CR-008].
- [x] App: admin | Tarea (FCM): Modificar `AuthRepository.kt` (Subida de Token, DesvinculaciÃ³n) y extirpar WebSockets. Ajustar UI (pantalla de bloqueo y estados FCM) [CR-008].

### Ã‰pica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseÃ±ar UI de resoluciÃ³n de conflictos.
- [x] App: viewer | Tarea: Integrar invocaciÃ³n de RPC `rpc_resolver_disputas` para mediaciÃ³n final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃ³stico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexiÃ³n Realtime y Delta Sync al retornar de background y ante transiciones de red fÃ­sica [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelaciÃ³n de listener al minimizar. Implementar cachÃ© local de sesiÃ³n en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [ ] App: viewer | Tarea (FCM): Implementar Camino 2 (Foreground Wake-up) optimizado para evitar peticiones REST de validaciÃ³n de permisos en cada SYNC_PAYMENTS y forzar recÃ¡lculo solo bajo SYNC_DEVICE_STATUS.
- [x] App: db | Tarea (Deuda TÃƒÂ©cnica): Elaborar y ejecutar un script de migraciÃƒÂ³n SQL ÃƒÂºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÂ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÂ³n.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒÂ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.
- [x] App: web | Tarea (CR): Mejorar UX del estado Realtime en SidebarNav implementando matriz de 4 estados basados en red fÃ­sica (navigator.onLine) y ciclo de vida del socket.
### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [x] App: viewer | Tarea (CR): RediseÃ±o de cola unificada de notificaciones (TTS/Push/VibraciÃ³n), ritmo dinÃ¡mico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃƒÂ³n correctamente [CR-008].
- [x] App: viewer | Tarea (CR): DiseÃƒÂ±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃƒÂ±a y verificaciÃƒÂ³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### Ãƒâ€°pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃƒÂ­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃƒÂ³n pÃƒÂºblica para anÃƒÂ³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃƒÂ©cnica): Elaborar y ejecutar un script de migraciÃƒÂ³n SQL ÃƒÂºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃƒÂ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃƒÂ³n.

### Ãƒâ€°pica: Portal Web y Cumplimiento (PerÃƒÂº)
- [x] App: web | Tarea (Legal): DiseÃƒÂ±ar e implementar las pÃƒÂ¡ginas estÃƒÂ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃƒÂ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃƒÂ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃƒÂ­o de correo de confirmaciÃƒÂ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ãƒâ€°pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃƒÂ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Ã‚Â°, la pestaÃƒÂ±a de licencias en cola/usuarios vinculados, y la visualizaciÃƒÂ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃƒÂ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃƒÂ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃƒÂ­as hÃƒable).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.
- [x] App: web | Tarea (CR): Mejorar UX del estado Realtime en SidebarNav implementando matriz de 4 estados basados en red fÃ­sica (navigator.onLine) y ciclo de vida del socket.
### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [x] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [x] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [x] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [x] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃ³n.
- [ ] App: viewer | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permiso `FOREGROUND_SERVICE_SPECIAL_USE` del CentinelaService.
- [x] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃ³n manual de fase Alpha/Beta en Google Play Console para el receptor.

### Ã‰pica: Infraestructura y Operaciones Cloud
- [x] App: web | Tarea (Infraestructura): MigraciÃ³n de despliegue en EasyPanel hacia nuevo VPS (31.220.50.238) por renovaciÃ³n anticipada y ahorro de costos de hosting, y actualizaciÃ³n de registros DNS en Namecheap para notificape.ryctech.dev.

### Tareas Generales (Por Priorizar)
- [x] **[TSK-001]** | App: Viewer | UI: RemociÃƒÂ³n de la verificaciÃƒÂ³n y solicitud obligatoria de optimizaciÃƒÂ³n de baterÃƒÂ­a (Google Play Policies).
- [x] **[CR-007]** | App: Admin | LÃƒÂ³gica: Actualizar el generador de notificaciones Mock para incluir `sbn.postTime` o un equivalente dinÃƒÂ¡mico en la generaciÃƒÂ³n del `IdSync`, a fin de evitar la deduplicaciÃƒÂ³n incorrecta en el receptor (Viewer).
- [x] **[CR-009]** | App: Web | UI/API: RediseÃƒÂ±o del Estado de ConexiÃƒÂ³n en detalle de dispositivo fÃƒÂ­sico vÃƒÂ­a Supabase Realtime Presence (escuchando el canal broadcast del app Admin).

## [E3] Entregable 3: ExpansiÃ³n de Negocio B2B (CR-014)

### Ã‰pica: Base de Datos y FacturaciÃ³n Modular (App: db)
- [x] Crear script `0035_addons_y_custom_plans.sql` aÃ±adiendo `IdContratanteExclusivo`, `PermiteAddons`, y precios extra a `Licencias`. Y columnas `ExtraUsuarios`, `ExtraDispositivos` a `LicenciasXContratante`.
- [x] Actualizar trigger `check_user_limit` y afines para que sumen `Limite + Extra` leyendo de la instancia de `LicenciasXContratante` activa.
- [x] Crear funciÃ³n RPC `procesar_compra_addon` que asigne el saldo en crÃ©dito y actualice los campos Extra de la licencia (con lÃ³gica de ticket mÃ­nimo).
- [x] Tarea (CR-014): Modificar motor de compras (previsualizar y ejecutar) para considerar add-ons e implementar motor automÃ¡tico de colas con pg_cron.

### Ã‰pica: Panel de Usuario y Superadmin (Frontend)
- [x] App: web | Tarea (CR-014): Actualizar DTOs en `actions_control.ts` y `dispositivos/actions.ts` para leer y sumar los campos `ExtraUsuarios` y `ExtraDispositivos` de la base de datos al validar lÃ­mites.
- [x] App: web | Tarea (CR-014): Implementar UI en el Dashboard de cliente para "Adquirir Usuarios/Dispositivos Extra", conectando a la funciÃ³n RPC de compra.
- [ ] App: web | Tarea (CR-014): Construir vista en `/superadmin/licencias` para que el Superadmin pueda crear "Planes Custom" aislando a un `IdContratanteExclusivo` y fijar precios manuales.
- [ ] App: web | Tarea (CR-014): Modificar `PricingCards.tsx` para ocultar planes corporativos al pÃºblico general y renderizarlos solo si el UUID coincide.
- [x] App: web/db | Tarea (Pendiente): Reforzar a nivel de servidor (`actions.ts`) y base de datos la inyecciÃ³n automÃ¡tica del diferencial (Vuelto) como saldo a favor cuando se aplica el Ticket MÃ­nimo de 5 soles en el checkout de MercadoPago.

## [E4] Entregable 4: Motor DinÃ¡mico de Regex y EstandarizaciÃ³n (Zero-Downtime)

### Ã‰pica: AplicaciÃ³n Web (Superadmin y Cliente)
- [x] App: web | Tarea: Crear UI 'Simulador Regex' en el Superadmin que tome el `PayloadBruto` (JSON) de notificaciones en estado 'REVISION', reconstruya el string concatenado en pantalla y evalÃºe la Regex en vivo.
- [ ] App: web | Tarea: Implementar UI 'Previsualizador de Mensaje' que aplique el `FormatoMensaje` sobre las variables extraÃ­das (Grupos Nombrados) en el simulador.
- [ ] App: web | Tarea: Agregar botÃ³n y conexiÃ³n a la Edge Function `reprocesar-notificaciones` para re-evaluar registros 'REVISION' tras guardar una regla.
- [x] App: web | Tarea: Modificar la UI de "Mis Billeteras" (Cliente) para que en el selector de asignaciÃ³n **solo** se listen billeteras que tengan al menos una regla activa con `VersionMotor = 2`.
- [ ] App: web | Tarea (Admin): Crear herramienta de limpieza masiva (Hard Delete) en el Superadmin para remover de DB y Storage las billeteras legacy inactivas.
- [ ] App: web | Tarea (Futuro): Desarrollar CRUD completo para la gestiÃ³n de Billeteras en el Superadmin. Considera alta complejidad tÃ©cnica (validaciones de integridad referencial, eliminaciÃ³n en cascada segura considerando asignaciones previas a usuarios y filtros) para no romper registros histÃ³ricos.

### Ã‰pica: Emisor Android (Admin)
- [x] App: admin | Tarea: Eliminar cÃ³digo duro de Lemon Pay en el servicio de evaluaciÃ³n.
- [x] App: admin | Tarea: Implementar generaciÃ³n del String de EvaluaciÃ³n concatenado (`[TITLE]...[TEXT]...`) en memoria RAM y ejecuciÃ³n de Regex con Grupos de Captura Nombrados.
- [x] App: admin | Tarea: Mapear variables extraÃ­das e interpolarlas con el `FormatoMensaje` antes de guardar `ContenidoMsg`.
- [x] App: admin | Tarea: Actualizar consulta DAO/Repository para descargar Ãºnicamente las reglas con `VersionMotor = 2`.
- [x] App: admin | Tarea: Modificar herramienta local 'Mensaje Mock' y capturar el PayloadBruto.

### Ã‰pica: Base de Datos y Backend
- [ ] App: db | Tarea: Crear script de migraciÃ³n aÃ±adiendo `TipoFiltro`, `FormatoMensaje`, `VersionMotor` a `FiltrosXBilletera` y `PayloadBruto` a `NotificacionesXDispositivo`.
- [ ] App: db | Tarea: Crear script inicial para duplicar las reglas vigentes de Yape y Lemon al formato concatenado bajo `VersionMotor = 2`.
- [ ] App: db | Tarea: Implementar Edge Function (Deno/TypeScript) `reprocesar-notificaciones` para recorrer y procesar con Regex (JS) las notificaciones en estado 'REVISION' y promoverlas a 'PENDIENTE'.

## [E5] Entregable 5: Sistema Integral de Onboarding y Usabilidad

### Hito 1: Hub de Descargas y Resiliencia de Accesos
- [x] App: web | **[TSK-016]** UI: Desarrollar `DownloadHubModal.tsx` con selector bitemÃ¡tico (Dark/Light) para App Emisor y App Receptor, cÃ³digos QR dinÃ¡micos para descarga directa desde celular, temporizador de descarga de APK, link a tiendas oficiales y botÃ³n para compartir enlace de instalaciÃ³n a cajeros vÃ­a mensajerÃ­a (sin marcas comerciales en cÃ³digo duro).
- [x] App: web | **[TSK-017]** NavegaciÃ³n: Integrar disparadores del Hub de Descargas en `SidebarNav.tsx` (versiÃ³n desktop y sheet mobile) y en el encabezado `DashboardHeader.tsx`.
- [x] App: web | **[TSK-018]** Seguridad/UX: Refactorizar `AccessGuard.tsx` y `licencias/page.tsx` para incorporar banner superior informativo contextual ante redirecciÃ³n por plan expirado o cuenta sin licencia activa.
- [x] App: web | **[TSK-019]** UI: RediseÃ±ar Empty States en `/dashboard/dispositivos` y `/dashboard/accesos` con micro-guÃ­as visuales y botones CTA directos para crear cajas y gestionar autorizaciones.

### Hito 2: Widget Setup Checklist en Dashboard
- [x] App: web | **[TSK-020]** Backend/DTO: Extender `fetchControlCenterStats` en `actions_control.ts` para calcular reactivamente los 4 estados de configuraciÃ³n inicial (perfil completado, licencia activa, cajas creadas, terminales/vendedores vinculados).
- [x] App: web | **[TSK-021]** UI: Construir el componente `SetupChecklist.tsx` en `/dashboard` con barra de progreso porcentual, estados interactivos (Checks/Botones), persistencia de colapso y dismiss en `localStorage`, y soporte Dark/Light.
- [x] App: web | **[TSK-022]** IntegraciÃ³n: Integrar `SetupChecklist.tsx` en `DashboardClient.tsx` arriba de las tarjetas de mÃ©tricas.

### Hito 3: Panel Lateral de Ayuda (Help Drawer) y Tour Interactivo Spotlight
- [x] App: web | **[TSK-023]** UI: Construir `HelpDrawer.tsx` (Panel lateral tipo `Sheet`) con detecciÃ³n de ruta activa (`pathname`), acordeones bitemÃ¡ticos de FAQs contextuales por secciÃ³n (Dashboard, Dispositivos, Accesos, Notificaciones) y accesos directos al Hub de Descargas y Tour.
- [x] App: web | **[TSK-024]** UI/Motor: Implementar el motor de tour interactivo `SpotlightTour.tsx` (overlay con backdrop y tooltips inteligentes bitemÃ¡ticos) para el recorrido general del Dashboard y mini-tours contextuales.
- [x] App: web | **[TSK-025]** NavegaciÃ³n/Estado: Montar el sistema de ayuda en `dashboard/layout.tsx` con trigger flotante e implementar la lÃ³gica de persistencia (`COMPLETED`, `IN_PROGRESS`, `DISMISSED`) y reanudaciÃ³n ante interrupciones.
- [x] App: web | **[TSK-025B]** UI/UX: Refactorizar SpotlightTour a tarjeta compacta flotante y arrastrable (Draggable) en desktop con modo dock inferior en mÃ³vil, tours condicionales multi-vista (actividad en dashboard, anatomÃ­a directa en detalle de dispositivo, personalizaciÃ³n en gestiÃ³n de licencias) y desacoplamiento de acordeones en /dashboard/licencias.

### Hito 4: InducciÃ³n, Onboarding y Tours en Aplicaciones MÃ³viles

#### Sub-Hito 4.1: App Admin (Emisor - Android / Jetpack Compose)
- [x] App: admin | **[TSK-026C]** Notificaciones de Sistema (Smart Diffing): Implementar motor de notificaciones locales para eventos administrativos recibidos vía FCM (UNBIND, Status, Rules, Wallets), utilizando diffing local en los repositorios para evitar spam offline.
- [x] App: admin | **[TSK-025C]** Refactorización UI Dashboard (Change Request): Homologar interfaz del Dashboard con la App Viewer, implementando "Bloques Gemelos" (Selector de Fecha y Píldora de Recaudación al 50%), corrigiendo Ripple Effects nativos y añadiendo el nombre del contratante obtenido vía JOIN en Supabase.
- [ ] App: admin | **[TSK-026A]** Spotlight Tour Principal: Implementar recorrido guiado (Tour Interactivo) paso a paso en la pantalla principal (Dashboard). Debe activarse post-vinculaciÃ³n, resaltando el interruptor del Foreground Service y el monitor de billeteras activas (basado exclusivamente en componentes de producciÃ³n/release, ignorando secciones debug).
- [ ] App: admin | **[TSK-026B]** MÃ³dulo de Ayuda y Persistencia (Help Drawer): Desarrollar un panel de ayuda (Bottom Sheet o Navigation Drawer) similar al proyecto Web, incluyendo respuestas a FAQs y un botÃ³n para re-lanzar el "Spotlight Tour". Persistir el estado de completitud del tour en DataStore.

#### Sub-Hito 4.2: App Viewer (Receptor - Android / Jetpack Compose)
- [ ] App: viewer | **[TSK-027A]** Onboarding Carousel: DiseÃ±ar carrusel de inducciÃ³n para personal y cajeros explicando las alertas inmediatas en caja ante transferencias Yape/Plin.
- [x] App: viewer | **[TSK-027B]** VinculaciÃ³n y Espera: DiseÃ±ar flujo de escaneo QR de caja para solicitar acceso y pantalla reactiva con animaciÃ³n de espera (*"Esperando aprobaciÃ³n del administrador"*).
- [-] App: viewer | **[TSK-027C]** CalibraciÃ³n de Audio/TTS: MÃ³dulo interactivo de prueba de sonido y sÃ­ntesis de voz ("Yape recibido: S/ 20") para verificar volumen y motor TTS antes de operar.
 (DESCARTADO)
- [ ] App: viewer | **[TSK-027D]** Spotlight Tour Principal: Implementar tour guiado en la pantalla de historial resaltando la tarjeta del Ãºltimo pago, filtros por dispositivo y ajustes de audio.
- [ ] App: viewer | **[TSK-027E]** Persistencia y Ayuda: Guardar el estado de inducciÃ³n en DataStore y agregar la opciÃ³n de reinicio de tour en el menÃº de ConfiguraciÃ³n.
- [ ] App: viewer | **[TSK-027F]** Cierre de Jornada / Cuadres (FUTURO): Disenar flujo y vista para cuadrar caja.



## [E6] Entregable 6: RefactorizaciÃ³n Push-to-Pull (FCM) en Viewer

### Ã‰pica 1: ConfiguraciÃ³n Cloud y GestiÃ³n de Tokens
- [x] App: viewer | Tarea 1.1: Configurar Firebase Console (AÃ±adir app Viewer), descargar google-services.json y actualizar dependencias a nivel de build.gradle.
- [x] App: db | Tarea 1.2: Crear script de migraciÃ³n SQL ( 044_fcm_tokens_viewer.sql) para agregar columna FcmToken a la tabla Usuarios. 
- [x] App: viewer | Tarea 1.3: En el Login de Google en el app Viewer, forzar siempre un UPDATE a la tabla Usuarios con el token FCM generado.
  - [x] App: viewer | **[TSK-028]** Rediseño Adaptativo de Cola FCM (Smart Batching): Implementar Supresión Contextual en primer plano, inyección inmediata a la Bandeja del Sistema (Fase 1), y lógica de agrupación de voz/pop-up en bloque para ráfagas de 3+ notificaciones, superando el límite de Wakelock (15s) de Android.
- [ ] App: viewer | **[TSK-029]** Flujos de Notificaciones Secundarias y Feedback de Sistema:
  - **Billeteras y QRs (Bandeja Silenciosa):** Implementar notificaciones regulares (sin TTS/Pop-Up) separando dos conceptos: 1) Agregado/Quitado de billeteras (agrupado singular/plural). 2) Edición de URL/Imagen de código QR (canal crítico para cajeros).
  - **Control de Acceso (Voz y Pop-Up):** Notificar aprobaciones y revocaciones de acceso a cajas indicando "Tienda X, Caja Y". Debe despertar el dispositivo si está bloqueado.
  - **Disputas y Reclamos (Voz y Pop-Up):** Notificar cambios de estado en disputas en las que el cajero esté involucrado.
  - **Condición Estricta (Respeto de UI):** Las alertas de Acceso y Disputas DEBEN obedecer los switches de preferencias del usuario (`isTtsEnabled`, `isHeadsUpEnabled`). Limpiar código muerto de notificación permanente residual.

### Ã‰pica 2: Desarrollo de Triggers Inteligentes (El Francotirador FCM)
- [x] App: db | Tarea 2.1 (Canal de Autorizaciones): Trigger en AutorizacionesXUsuario (UPDATE). Dispara Push {"action": "SYNC_AUTH"} al usuario afectado.
- [x] App: db | Tarea 2.2 (Canal de Nuevos Pagos): Trigger en NotificacionesXDispositivo (INSERT/UPDATE). Dispara Push {"action": "SYNC_PAYMENTS"} a todos los usuarios aprobados para ese IdDispositivo.
- [x] App: db | Tarea 2.3 (Canal de Reclamos y Disputas): Trigger en NotificacionesAUsuarios (INSERT/UPDATE/DELETE). Dispara Push {"action": "SYNC_PAYMENTS"} a la caja respectiva.
- [x] App: db | Tarea 2.4 (Canal de ConfiguraciÃ³n de Cajas/QRs): Trigger en BilleterasXDispositivo (INSERT/UPDATE/DELETE). Dispara Push {"action": "SYNC_WALLETS"} a los cajeros para forzar la actualizaciÃ³n del QR.

### Ã‰pica 3: ExtirpaciÃ³n del Core Realtime y Limpieza Profunda (App Viewer)
- [x] App: viewer | Tarea 3.1: Eliminar Panel de DiagnÃ³stico (RealtimeAuditDialog.kt). Eliminar botÃ³n de AuditorÃ­a ("Wifi") en VinculacionHeader.kt.
- [x] App: viewer | Tarea 3.2: Eliminar el Foreground Service: Borrar completamente CentinelaService.kt y CentinelaStateObserver.kt. 
- [x] App: viewer | Tarea 3.3: Eliminar lÃ³gica de Sockets: Borrar RealtimeCoordinator.kt, DiagnosticsManager.kt y todas las clases RealtimeDataSource.

### Ã‰pica 4: ImplementaciÃ³n Push-to-Pull y Motor de Alertas
- [x] App: viewer | Tarea 4.1: Crear FCMReceiverService.kt. Instanciar interceptaciÃ³n en background.
- [x] App: viewer | Tarea 4.2: Refactorizar repositorios. Convertir flujos de Supabase a SharedFlow locales y hacer Pull REST al recibir Push de FCMReceiverService.kt. (Transformado a True Data-Push).
- [x] App: viewer | Tarea 4.3: Enlazar el disparo de alertas de pago (TTS de voz y Pop-ups HeadsUp) al final exitoso de la descarga HTTP.
- [x] App: viewer | Tarea 4.4: Refactorizar CentinelaNotificationManager.kt a una Cola circular FIFO (10 notificaciones mÃ¡x).

### Ã‰pica 5: RefactorizaciÃ³n UI/UX, Loaders y Resiliencia (App Viewer)
- [x] App: viewer | Tarea 5.1: Refactorizar EsperaAprobacionScreen a vista pasiva. Al recibir Push de aprobaciÃ³n, auto-redireccionar al Dashboard (NavegaciÃ³n Cero-Sockets).
- [x] App: viewer | Tarea 5.2: Refactorizar botÃ³n "Desvincular". Ejecutar HTTP REST e invalidar sesiÃ³n inmediatamente.
- [x] App: viewer | Tarea 5.3: Eliminar ConnectionPill ("En LÃ­nea").
- [x] App: viewer | Tarea 5.4: Integrar NetworkMonitor.kt en la capa visual (Loaders de Auto-recuperaciÃ³n).


### Ã‰pica 6: Deuda TÃ©cnica y Limpieza Global (IsConnected)
- [ ] App: db | Tarea 6.1 (Deuda TÃ©cnica): Evaluar la eliminaciÃ³n del campo `IsConnected` en la tabla `AutorizacionesXUsuario` ya que el estado "En LÃ­nea" ha sido reemplazado por la entrega pasiva de FCM, ahorrando costos de escritura (UPDATEs).
- [x] App: web/admin | Tarea 6.2 (Deuda TÃ©cnica): Auditar los proyectos Web y Admin para remover cualquier indicador de "Puntito Verde" o estado de conexiÃ³n en vivo que dependa del campo `IsConnected`. Priorizar el uso del estado `IdEstadoAuth` para la gestiÃ³n de usuarios.
-   [ x ]   A p p :   w e b   |   T a r e a :   I m p l e m e n t a r   U I   y   B a s e   d e   D a t o s   p a r a   c a p t a c i ó n   d e   B e t a   T e s t e r s   ( L a n d i n g   y   P a n e l   S u p e r a d m i n )   p a r a   G o o g l e   P l a y   C l o s e d   T e s t i n g . 
 
 - [x] App: admin | Tarea 6.3 (Bug/UI): Corregir parpadeo de permisos y falsas expulsiones en reinstalaciones, desactivando Auto-Backup y condicionando la capa de permisos al estado validado.










### Épica 7: Motor Dinámico de Recompensas y Promociones (PLG)
- [ ] App: db | Tarea 7.1: Crear tabla CampanasPromocionales (IdCampana, TipoEvento, Prioridad, MontoCreditos, Fechas) para centralizar la configuración de promociones sin *hardcoding*.
- [ ] App: db | Tarea 7.2: Crear tabla CodigosPromocionales y vincularla a la lógica de referidos bilaterales.
- [x] App: db/web | Tarea 7.3: Implementar Edge Function / Trigger para evaluación atómica de campañas en el registro e inyectar el ABONO automático.
egistrar_tx_credito.
- [ ] App: web | Tarea 7.4: Desarrollar módulo CRUD en el panel Superadmin para gestionar, habilitar y priorizar las campañas dinámicas.
- [x] App: web | Tarea 7.5: Adaptar UI de Registro para aceptar códigos de invitación y crear componente dinámico (GlobalAnnouncementModal) en el Dashboard.


### Épica 10: Motor Centralizado de Anuncios y Novedades (SaaS)
- [ ] App: db/web | Tarea 10.1: Crear tabla CampanasInformativas en Supabase y panel CRUD en Superadmin para redactar y disparar avisos remotos.
- [ ] App: web | Tarea 10.2: Conectar GlobalAnnouncementModal a la tabla de avisos para despliegue dinámico.

### Épica 11: Mejora UX/UI del Gestor de Accesos y Dispositivos
- [x] App: web | Tarea 11.1: Refactorizar la vista de gestión de accesos (/dashboard/accesos) agrupando los usuarios por dispositivo asignado con orden alfabético A-Z estable, bandeja de atención inmediata de pendientes y menú desplegable de ordenamiento con icono de filtro.
- [x] App: web | Tarea 11.2: Implementar modales de confirmación para acciones críticas (Aprobar, Bloquear y sustitución en límite de cupo) con botones filled sólidos de alto contraste previniendo clics accidentales.

### [E7] Bugs y Pulido (Detectados en QA)
- [ ] **TSK-031:** Arreglar paleta de colores de billeteras en la UI (BCP sin color, Scotiabank con color de BBVA). Revisar Billeteras master o mapeo de UI.
- [ ] **TSK-032:** Arreglar silencio de notificaciones propias en Impugnaciones. El trigger de NotificacionesXDispositivo (al pasar a 'REVISION') no tiene cmo saber qu usuario hizo la accin, por lo que evade el filtro de silencio en Android. Adems, auditar por qu llega "Actualizacin de Reclamo" en lugar de NEW_CLAIM.
