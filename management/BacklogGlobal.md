# Backlog Global Unificado
**Proyecto:** NotificaPe
**Estatus:** Activo (Preparación para Pruebas Cerradas y Lanzamiento)

## 📌 Tareas Pendientes (Prioridad Alta - Pruebas Cerradas)

### Épica: Políticas de Google Play Console y Google Cloud (Blockers de Lanzamiento)
- [x] App: web | Tarea (GCP): Publicar la Pantalla de Consentimiento de OAuth en Google Cloud Console a estado 'En producción' para remover el límite de 100 usuarios de prueba. (Completado: Validado que no hay límite para scopes básicos).
- [ ] App: admin | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permisos `NotificationListenerService` y `FOREGROUND_SERVICE`.
- [ ] App: admin | Tarea (Store): Llenar el Data Safety Form detallando captura y cifrado de notificaciones financieras.
- [ ] App: viewer | Tarea (Store): Grabar y alojar el Policy Video demostrativo requerido para justificar permiso `FOREGROUND_SERVICE_SPECIAL_USE` del CentinelaService.
- [ ] App: viewer | Tarea (Store): Completar el Data Safety Form sobre inicio de sesión y datos recopilados.
- [ ] App: admin/viewer | Tarea (Store): Solicitar promoción manual de la versión de Pruebas Internas a Pruebas Cerradas (Alpha) en la consola de Google Play, adjuntando la documentación justificativa.
- [ ] App: admin/viewer | Tarea (Store - Post 14 días): Solicitar pase a Producción. Al llenar el cuestionario final sobre cómo se probó, incluir el texto: *"La app Admin es un servicio de fondo (set-and-forget). Los testers la mantuvieron corriendo en segundo plano durante 14 días procesando notificaciones. El feedback principal fue sobre su estabilidad de conexión y bajo consumo de batería."*

## 📌 Tareas Programadas para Siguiente Iteración (Onboarding y UX)

### Épica: Sistema Integral de Onboarding y Usabilidad (Post-Pruebas Cerradas)
- [ ] App: admin | Tarea [TSK-026A]: Spotlight Tour Principal. Implementar recorrido guiado paso a paso en la pantalla principal (Dashboard), resaltando el interruptor del Foreground Service.
- [ ] App: admin | Tarea [TSK-026B]: Módulo de Ayuda y Persistencia (Help Drawer). Panel de ayuda con FAQs y persistencia del estado del tour.
- [ ] App: viewer | Tarea [TSK-027A]: Onboarding Carousel. Diseñar carrusel de inducción para personal y cajeros explicando las alertas inmediatas.
- [ ] App: viewer | Tarea [TSK-027D]: Spotlight Tour Principal. Tour guiado en la pantalla de historial resaltando filtros y ajustes de audio.
- [ ] App: viewer | Tarea [TSK-027E]: Persistencia y Ayuda. Guardar el estado de inducción en DataStore y reiniciar tour.
- [ ] App: viewer | Tarea [TSK-027F]: Cierre de Jornada / Cuadres (FUTURO). Flujo y vista para cuadrar caja.
- [ ] App: admin | Tarea (UX/Store): Reutilizar componente "Copiar URL del Panel Web" en la sección de Configuración para permitir a los clientes gestionar sus licencias sin usar enlaces interactivos (Cumplimiento de Google Play Payments).
- [ ] App: viewer | Tarea (UX/Store): Agregar componente "Copiar URL del Panel Web" en la vista de Ajustes para mantener consistencia con el ecosistema y evitar rechazos por evasión de pagos.

## 📌 Tareas de Mantenimiento y Backoffice

### Épica: Gestión Administrativa y Plataforma Web
- [ ] App: web | Tarea (Admin): Construir vista en `/superadmin/licencias` para crear "Planes Custom" aislando a un IdContratanteExclusivo y fijar precios manuales.
- [ ] App: web | Tarea (Regex): Implementar UI 'Previsualizador de Mensaje' que aplique el FormatoMensaje sobre las variables extraídas en el simulador.
- [ ] App: web | Tarea (Regex): Agregar botón y conexión a la Edge Function `reprocesar-notificaciones` para re-evaluar registros 'REVISION' tras guardar una regla.
- [ ] App: web | Tarea (Billeteras): Crear herramienta de limpieza masiva (Hard Delete) en el Superadmin para remover de DB y Storage las billeteras legacy inactivas.
- [ ] App: web | Tarea (Billeteras): Desarrollar CRUD completo para la gestión de Billeteras (alta complejidad por integridad referencial).

---

## 🗄️ Historial de Entregables Completados (Archivo)
> *Nota: Para ver el detalle atómico de cada tarea completada, consulte la carpeta `management/changelogs/`.*

- **[E1]** Core de Notificaciones, Sincronización y Emisor Android (Realtime/Room).
- **[E2]** Cumplimiento Legal (Perú), Libro de Reclamaciones y Dashboard Superadmin.
- **[E3]** Expansión de Negocio B2B, Pasarela MercadoPago y Módulos de Expansión (Add-ons).
- **[E4]** Motor Dinámico de Regex y Estandarización (Zero-Downtime) V2.
- **[E5]** Arquitectura de Sincronización FCM Push-to-Pull, Eliminación de Doze Mode Limits, Webhooks y Resiliencia Offline.

### �pica: Arquitectura CI/CD, Versionamiento y DevOps
- [ ] App: admin/viewer/web | Tarea (DevOps): Configurar 'release-please' para automatizar el versionamiento sem�ntico. (Debe leer los commits [fix, feat] de CHANGELOG.md para decidir si sube la versi�n a Patch o Minor, e inyectar el versionName resultante directamente en build.gradle.kts usando un script en el Action).
- [ ] App: admin/viewer | Tarea (DevOps): Automatizar el llenado de 'Notas de la Versi�n' en Google Play. (Modificar el Action de Google Play Upload para que env�e el extracto del CHANGELOG.md a la consola usando Fastlane o las capacidades nativas del action).
- [ ] App: specs | Tarea (Knowledge): Crear la skill 'skill_versioning_and_releases' para los agentes de desarrollo. Definir� las reglas estrictas de Conventional Commits, la jerarqu�a de SemVer (1.X.X para features, 1.0.X para parches), y el flujo de cu�ndo generar un release en lugar de solo acumular commits.
