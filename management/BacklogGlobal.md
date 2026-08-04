# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃ³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃ³n

### Ã‰pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃ³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃ³n' para remover el lÃ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ã‰pica: Emisor
- [x] App: admin | Tarea: Implementar lÃ³gica Room-First y Worker Offline para resiliencia total.
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
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza Automática Segura" (Opción A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una única notificación persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | Último: S/ 15"), evitando saturar el límite de Android bajo estrés [CR-012].
- [ ] App: admin | Tarea (Mejora UX/Íconos): Diseñar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].

### Épica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseñar UI de resolución de conflictos.
- [x] App: viewer | Tarea: Integrar invocación de RPC `rpc_resolver_disputas` para mediación final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnóstico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexión Realtime y Delta Sync al retornar de background y ante transiciones de red física [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelación de listener al minimizar. Implementar caché local de sesión en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [x] App: db | Tarea (Deuda TÃ©cnica): Elaborar y ejecutar un script de migraciÃ³n SQL Ãºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃ³n.

### Ã‰pica: Portal Web y Cumplimiento (PerÃº)
- [x] App: web | Tarea (Legal): DiseÃ±ar e implementar las pÃ¡ginas estÃ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃ­o de correo de confirmaciÃ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ã‰pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Â°, la pestaÃ±a de licencias en cola/usuarios vinculados, y la visualizaciÃ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃ­as hÃ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [x] App: viewer | Tarea (CR): Rediseño de cola unificada de notificaciones (TTS/Push/Vibración), ritmo dinámico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃ³n correctamente [CR-008].
- [ ] App: viewer | Tarea (CR): DiseÃ±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃ±a y verificaciÃ³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### Ã‰pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃ­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃ³n pÃºblica para anÃ³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃ©cnica): Elaborar y ejecutar un script de migraciÃ³n SQL Ãºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃ³n.

### Ã‰pica: Portal Web y Cumplimiento (PerÃº)
- [x] App: web | Tarea (Legal): DiseÃ±ar e implementar las pÃ¡ginas estÃ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃ­o de correo de confirmaciÃ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ã‰pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Â°, la pestaÃ±a de licencias en cola/usuarios vinculados, y la visualizaciÃ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃ­as hÃ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃ³n.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃ³n manual de fase Alpha/Beta en Google Play Console para el receptor.
# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Fase Inicial de IntegraciÃ³n Completada)

## [E1] Entregable 1: Core de Notificaciones y SincronizaciÃ³n

### Ã‰pica: Base de Datos y APIs
- [x] App: db | Tarea (CR): ExtensiÃ³n de Billeteras: Agregar campo ColorHex y soporte para Lemon Cash (me.lemon.ar) mediante el script 0018_billeteras_color_lemon.sql.
- [x] App: web | Tarea: Conectar MCP de Supabase y validar estructura final de disputas (Triggers/Vistas) vs la nube.
- [ ] App: web | Tarea: Implementar endpoints CRUD y Edge Functions para el manejo de sesiones y empresas.
- [x] App: web | Tarea (CR): Crear bucket pÃºblico en Supabase Storage (o configurar URL en GitHub Releases) y subir las compilaciones APK iniciales.
- [x] App: web | Tarea (CR): Modificar Landing Page para actualizar la secciÃ³n de precios (nuevos planes), detallar el flujo de las 3 aplicaciones y aÃ±adir botones de descarga directa para los APKs.
- [ ] App: web | Tarea (Deploy): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃ³n' para remover el lÃ­mite de 100 usuarios de prueba antes del lanzamiento oficial.

### Ã‰pica: Emisor
- [x] App: admin | Tarea: Implementar lÃ³gica Room-First y Worker Offline para resiliencia total.
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
- [x] App: admin | Tarea (Mejora UX): Implementar "Limpieza Automática Segura" (Opción A). Borrar notificaciones bancarias entrantes al instante (0 delay) y reemplazarlas con una única notificación persistente propia (InboxStyle) de NotificaPe que agrupe un resumen (ej. "50 pagos | Último: S/ 15"), evitando saturar el límite de Android bajo estrés [CR-012].
- [ ] App: admin | Tarea (Mejora UX/Íconos): Diseñar e integrar silueta transparente (SmallIcon) y logo a color (LargeIcon) para notificaciones en la barra de estado y panel Android [CR-013].

### Épica: Receptor
- [x] App: viewer | Tarea: Consumir vista `view_notificaciones_disputadas` y diseñar UI de resolución de conflictos.
- [x] App: viewer | Tarea: Integrar invocación de RPC `rpc_resolver_disputas` para mediación final.
- [x] App: viewer | Tarea (CR): Implementar mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnóstico no presencial de fallos de firma o servicios [CR-003].
- [x] App: viewer | Tarea (CR): Robustecer resiliencia de conexión Realtime y Delta Sync al retornar de background y ante transiciones de red física [CR-004].
- [x] App: viewer | Tarea (CR): Solucionar atasco en 'Sincronizando...' y cancelación de listener al minimizar. Implementar caché local de sesión en AuthRepositoryImpl (evitar REST HTTP en background) y eliminar llamada a realtimeManager.detener() en CentinelaService [CR-006].
- [x] App: viewer | Tarea (CR): Restaurar flujo de events Insert en RealtimeCoordinator
- [x] App: db | Tarea (Deuda TÃ©cnica): Elaborar y ejecutar un script de migraciÃ³n SQL Ãºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃ³n.

### Ã‰pica: Portal Web y Cumplimiento (PerÃº)
- [x] App: web | Tarea (Legal): DiseÃ±ar e implementar las pÃ¡ginas estÃ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃ­o de correo de confirmaciÃ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ã‰pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Â°, la pestaÃ±a de licencias en cola/usuarios vinculados, y la visualizaciÃ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃ­as hÃ¡biles).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [x] App: viewer | Tarea (CR): Rediseño de cola unificada de notificaciones (TTS/Push/Vibración), ritmo dinámico, catch-up silencioso, escrituras DataStore batch, modo tradicional en cortina Android y auto-limpieza de alertas al abrir el app [CR-010]. (cumpleFiltro) para que las notificaciones en segundo plano disparen alertas TTS y VibraciÃ³n correctamente [CR-008].
- [ ] App: viewer | Tarea (CR): DiseÃ±ar e implementar el flujo alternativo de Registro y Login Manual (sin Google Services/GMS) mediante correo/contraseÃ±a y verificaciÃ³n de billeteras asociadas [CR-005].

## [E2] Entregable 2: Cumplimiento Legal y Operaciones SaaS

### Ã‰pica: Base de Datos y Mantenimiento
- [x] App: db | Tarea (Legal): Crear la tabla `Superadministradores` en Supabase con polÃ­ticas RLS para control restrictivo de acceso al dashboard.
- [x] App: db | Tarea (Legal): Crear la tabla `Reclamaciones` en Supabase con RLS habilitado (inserciÃ³n pÃºblica para anÃ³nimos, lectura exclusiva para superadmins).
- [x] App: db | Tarea (Deuda TÃ©cnica): Elaborar y ejecutar un script de migraciÃ³n SQL Ãºnico (`0030_legal_and_superadmin.sql`) para eliminar definitivamente las tablas huÃ©rfanas `ConflictosXNotificacion` y `DisputasNotificaciones` en desarrollo y producciÃ³n.

### Ã‰pica: Portal Web y Cumplimiento (PerÃº)
- [x] App: web | Tarea (Legal): DiseÃ±ar e implementar las pÃ¡ginas estÃ¡ticas `/terminos-condiciones` y `/politica-privacidad` usando variables de entorno para datos dinÃ¡micos.
- [x] App: web | Tarea (Legal): Agregar enlaces legales e isotipo oficial del Libro de Reclamaciones de INDECOPI en el footer del Landing Page.
- [x] App: web | Tarea (Legal): Crear el formulario interactivo `/libro-reclamaciones` con validaciones exigidas por ley e integraciÃ³n con Supabase.
- [x] App: web | Tarea (Legal): Configurar Edge Function para el envÃ­o de correo de confirmaciÃ³n HTML al cliente y soporte utilizando la variable `SUPPORT_EMAIL`.

### Ã‰pica: Dashboard de Superadministrador
- [x] App: web | Tarea (Admin): DiseÃ±ar panel general protegido en `/superadmin` verificando privilegios en la tabla `Superadministradores`.
- [/] App: web | Tarea (Admin): Desarrollar Consola de Contratantes en `/superadmin/contratantes` (Falta validar a fondo la nueva Consola 360Â°, la pestaÃ±a de licencias en cola/usuarios vinculados, y la visualizaciÃ³n de notificaciones por dispositivo).
- [x] App: web | Tarea (Admin): Construir la Consola de Disputas en `/superadmin/disputas` que invoque la funciÃ³n RPC `resolver_disputa` de Supabase para mediaciones.
- [x] App: web | Tarea (Admin): Implementar vista de gestiÃ³n `/superadmin/reclamaciones` para auditar Libro de Reclamaciones legal y plazos (15 dÃ­as hÃable).
- [x] App: web | Tarea (Admin): Desarrollar Simulador y Depurador de Regex en `/superadmin/regex` para evaluar expresiones de billeteras en vivo y publicarlas en `FiltrosXBilletera`.

### Ã‰pica: PolÃ­ticas de Google Play Console (Apps)
- [ ] App: admin | Tarea (Store): Generar activos visuales faltantes (Icono 512x512, Banner 1024x500) y redactar Ficha de Play Store en EspaÃ±ol.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Solicitar promociÃ³n manual de Alpha/Beta en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [ ] App: viewer | Tarea (Store): Generar activos visuales, redactar Ficha de Play Store y completar Data Safety Form sobre inicio de sesiÃ³n.
- [ ] App: viewer | Tarea (Store): Crear e inyectar en BD una cuenta bypass de prueba para permitir la revisiÃ³n automatizada del equipo de Google Play.
- [ ] App: viewer | Tarea (Store): Solicitar promociÃ³n manual de fase Alpha/Beta en Google Play Console para el receptor.

### Tareas Generales (Por Priorizar)
- [x] **[TSK-001]** | App: Viewer | UI: RemociÃ³n de la verificaciÃ³n y solicitud obligatoria de optimizaciÃ³n de baterÃ­a (Google Play Policies).
- [x] **[CR-007]** | App: Admin | LÃ³gica: Actualizar el generador de notificaciones Mock para incluir `sbn.postTime` o un equivalente dinÃ¡mico en la generaciÃ³n del `IdSync`, a fin de evitar la deduplicaciÃ³n incorrecta en el receptor (Viewer).
- [x] **[CR-009]** | App: Web | UI/API: RediseÃ±o del Estado de ConexiÃ³n en detalle de dispositivo fÃ­sico vÃ­a Supabase Realtime Presence (escuchando el canal broadcast del app Admin).

## [E3] Entregable 3: Expansión de Negocio B2B (CR-014)

### Épica: Base de Datos y Facturación Modular (App: db)
- [x] Crear script `0035_addons_y_custom_plans.sql` añadiendo `IdContratanteExclusivo`, `PermiteAddons`, y precios extra a `Licencias`. Y columnas `ExtraUsuarios`, `ExtraDispositivos` a `LicenciasXContratante`.
- [x] Actualizar trigger `check_user_limit` y afines para que sumen `Limite + Extra` leyendo de la instancia de `LicenciasXContratante` activa.
- [x] Crear función RPC `procesar_compra_addon` que asigne el saldo en crédito y actualice los campos Extra de la licencia (con lógica de ticket mínimo).
- [x] Tarea (CR-014): Modificar motor de compras (previsualizar y ejecutar) para considerar add-ons e implementar motor automático de colas con pg_cron.

### Épica: Panel de Usuario y Superadmin (Frontend)
- [x] App: web | Tarea (CR-014): Actualizar DTOs en `actions_control.ts` y `dispositivos/actions.ts` para leer y sumar los campos `ExtraUsuarios` y `ExtraDispositivos` de la base de datos al validar límites.
- [x] App: web | Tarea (CR-014): Implementar UI en el Dashboard de cliente para "Adquirir Usuarios/Dispositivos Extra", conectando a la función RPC de compra.
- [ ] App: web | Tarea (CR-014): Construir vista en `/superadmin/licencias` para que el Superadmin pueda crear "Planes Custom" aislando a un `IdContratanteExclusivo` y fijar precios manuales.
- [ ] App: web | Tarea (CR-014): Modificar `PricingCards.tsx` para ocultar planes corporativos al público general y renderizarlos solo si el UUID coincide.
- [ ] App: web/db | Tarea (Pendiente): Reforzar a nivel de servidor (`actions.ts`) y base de datos la inyección automática del diferencial (Vuelto) como saldo a favor cuando se aplica el Ticket Mínimo de 5 soles en el checkout de MercadoPago.
