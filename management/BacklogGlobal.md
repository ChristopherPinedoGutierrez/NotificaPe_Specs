# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (PreparaciÃ³n para Pruebas Cerradas y Lanzamiento)

## ðŸ“Œ Tareas Pendientes (Prioridad Alta - Pruebas Cerradas)

### Ã‰pica: PolÃ­ticas de Google Play Console y Google Cloud (Blockers de Lanzamiento)
- [x] App: web | Tarea (GCP): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producciÃ³n' para remover el lÃ­mite de 100 usuarios de prueba. (Completado: Validado que no hay lÃ­mite para scopes bÃ¡sicos).
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: viewer | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permiso `FOREGROUND_SERVICE_SPECIAL_USE` del CentinelaService.
- [ ] App: viewer | Tarea (Store): Completar el Data Safety Form sobre inicio de sesiÃ³n y datos recopilados.
- [ ] App: admin/viewer | Tarea (Store): Solicitar promociÃ³n manual de la versiÃ³n de Pruebas Internas a Pruebas Cerradas (Alpha) en la consola de Google Play, adjuntando la documentaciÃ³n justificativa.
- [ ] App: admin/viewer | Tarea (Store - Post 14 dÃ­as): Solicitar pase a ProducciÃ³n. Al llenar el cuestionario final sobre cÃ³mo se probÃ³, incluir el texto: *"La app Admin es un servicio de fondo (set-and-forget). Los testers la mantuvieron corriendo en segundo plano durante 14 dÃ­as procesando notificaciones. El feedback principal fue sobre su estabilidad de conexiÃ³n y bajo consumo de baterÃ­a."*
- [x] App: viewer | Tarea [TSK-CR017]: Resiliencia de Registro de Token FCM (Onboarding y Centinela de Arranque con Caché) y Alta Prioridad en Dispatcher.
- [x] App: viewer | Tarea [TSK-CR018]: Resiliencia Offline Completa, Reclamos en DataStore (TTL 24h), Single Device Kickout con InstallationId, Toast Persistente y Validación E2E.

## ðŸ“Œ Tareas Programadas para Siguiente IteraciÃ³n (Onboarding y UX)

### Ã‰pica: Sistema Integral de Onboarding y Usabilidad (Post-Pruebas Cerradas)
- [ ] App: admin | Tarea [TSK-026A]: Spotlight Tour Principal. Implementar recorrido guiado paso a paso en la pantalla principal (Dashboard), resaltando el interruptor del Foreground Service.
- [ ] App: admin | Tarea [TSK-026B]: MÃ³dulo de Ayuda y Persistencia (Help Drawer). Panel de ayuda con FAQs y persistencia del estado del tour.
- [ ] App: viewer | Tarea [TSK-027A]: Onboarding Carousel. DiseÃ±ar carrusel de inducciÃ³n para personal y cajeros explicando las alertas inmediatas.
- [ ] App: viewer | Tarea [TSK-027D]: Spotlight Tour Principal. Tour guiado en la pantalla de historial resaltando filtros y ajustes de audio.
- [ ] App: viewer | Tarea [TSK-027E]: Persistencia y Ayuda. Guardar el estado de inducciÃ³n en DataStore y reiniciar tour.
- [ ] App: viewer | Tarea [TSK-027F]: Cierre de Jornada / Cuadres (FUTURO). Flujo y vista para cuadrar caja.
- [ ] App: admin | Tarea (UX/Store): Reutilizar componente "Copiar URL del Panel Web" en la secciÃ³n de ConfiguraciÃ³n para permitir a los clientes gestionar sus licencias sin usar enlaces interactivos (Cumplimiento de Google Play Payments).
- [ ] App: viewer | Tarea (UX/Store): Agregar componente "Copiar URL del Panel Web" en la vista de Ajustes para mantener consistencia con el ecosistema y evitar rechazos por evasiÃ³n de pagos.

## ðŸ“Œ Tareas de Mantenimiento y Backoffice

### Ã‰pica: GestiÃ³n Administrativa y Plataforma Web
- [ ] App: web | Tarea (Admin): Construir vista en `/superadmin/licencias` para crear "Planes Custom" aislando a un IdContratanteExclusivo y fijar precios manuales.
- [ ] App: web | Tarea (Regex): Implementar UI 'Previsualizador de Mensaje' que aplique el FormatoMensaje sobre las variables extraÃ­das en el simulador.
- [ ] App: web | Tarea (Regex): Agregar botÃ³n y conexiÃ³n a la Edge Function `reprocesar-notificaciones` para re-evaluar registros 'REVISION' tras guardar una regla.
- [ ] App: web | Tarea (Billeteras): Crear herramienta de limpieza masiva (Hard Delete) en el Superadmin para remover de DB y Storage las billeteras legacy inactivas.
- [ ] App: web | Tarea (Billeteras): Desarrollar CRUD completo para la gestiÃ³n de Billeteras (alta complejidad por integridad referencial).

---

## ðŸ—„ï¸ Historial de Entregables Completados (Archivo)
> *Nota: Para ver el detalle atÃ³mico de cada tarea completada, consulte la carpeta `management/changelogs/`.*

- **[E1]** Core de Notificaciones, SincronizaciÃ³n y Emisor Android (Realtime/Room).
- **[E2]** Cumplimiento Legal (PerÃº), Libro de Reclamaciones y Dashboard Superadmin.
- **[E3]** ExpansiÃ³n de Negocio B2B, Pasarela MercadoPago y MÃ³dulos de ExpansiÃ³n (Add-ons).
- **[E4]** Motor DinÃ¡mico de Regex y EstandarizaciÃ³n (Zero-Downtime) V2.
- **[E5]** Arquitectura de SincronizaciÃ³n FCM Push-to-Pull, EliminaciÃ³n de Doze Mode Limits, Webhooks y Resiliencia Offline.

### Épica: Arquitectura CI/CD, Versionamiento y DevOps
- [ ] App: admin/viewer/web | Tarea (DevOps): Configurar 'release-please' para automatizar el versionamiento semántico. (Debe leer los commits [fix, feat] de CHANGELOG.md para decidir si sube la versión a Patch o Minor, e inyectar el versionName resultante directamente en build.gradle.kts usando un script en el Action).
- [ ] App: admin/viewer | Tarea (DevOps): Automatizar el llenado de 'Notas de la Versión' en Google Play. (Modificar el Action de Google Play Upload para que envíe el extracto del CHANGELOG.md a la consola usando Fastlane o las capacidades nativas del action).
- [ ] App: specs | Tarea (Knowledge): Crear la skill 'skill_versioning_and_releases' para los agentes de desarrollo. Definirá las reglas estrictas de Conventional Commits, la jerarquía de SemVer (1.X.X para features, 1.0.X para parches), y el flujo de cuándo generar un release en lugar de solo acumular commits.
- [ ] App: viewer | Tarea (DevOps): Desacoplar modo 'Pre-producción (Solo Fixes/Patches)' y reactivar SemVer completo (feat/fix) tras el lanzamiento oficial a Producción.
- [ ] App: admin | Tarea (DevOps): Configurar 'release-please' y modo 'Pre-producción (Solo Fixes/Patches)' con despliegue unificado hacia Google Play.



