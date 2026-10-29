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

### Épica [CR-016]: Paquete Go-To-Market, Promociones y Adquisición de Testers (Web & DB)

#### Grupo 1: Responsive y Embudo de Adquisición (Prioridad Crítica — Listo para Ejecución)
- [x] App: web | Tarea [GTM-1.1] (Mobile-First Audit): Auditoría y corrección granular vista por vista del frontend en modo móvil (Landing, Navbar, vista "Únete", Modales de bienvenida/login y Dashboard inicial) para eliminar desbordamientos y asegurar usabilidad en pantallas de 360px-414px.
- [x] App: web | Tarea [GTM-1.2] (Hero Trial Badge): Crear componente visual `<HeroTrialBadge />` (SVG llamativo en el Hero) que consulte dinámicamente `DuracionDias` del plan gratuito (`PrecioCentimos = 0` / `TRIAL-7D`) en la tabla `Licencias`. Permanente e independiente de campañas.
- [x] App: web | Tarea [GTM-1.3] (Modal Multipágina): Verificar y asegurar que `LandingPromoModal` opere de forma autónoma leyendo las campañas activas (`CampanasPromocionales`: Bono de Bienvenida y Referidos) sin depender del cierre de la fase Beta.
- [x] App: web | Tarea [GTM-1.4] (Gancho Tester en "Únete"): Diseñar e integrar bloque destacado en la vista "Únete" explicando el beneficio de 1 mes adicional gratis para los primeros 50 testers mediante doble validación (Código de Referido en registro + Código Promocional Tester en licencias).
- [x] App: web/db | Tarea [GTM-1.5] (Beta Kill Switch & Contingencia): Implementar control de cierre en 2 niveles: (1) Automático/DB verificando disponibilidad y estado `'ACTIVA'` de la campaña de testers (`UsosActuales < UsosMaximos`), vinculada a la campaña independiente `PRUEBA2026` (Script `0050_campana_testers_prueba2026.sql`), más copy de contingencia derivando a WhatsApp si se agotan los cupos para ajuste manual de crédito; y (2) Variable de entorno maestra `NEXT_PUBLIC_IS_BETA_PHASE` para ocultar globalmente cintillos y bloques de fase de pruebas en EasyPanel.
- [x] App: web | Tarea [GTM-1.6] (Superadmin WhatsApp Link): Agregar botón "Aprobar y Enviar WhatsApp" en la gestión de testers de `/superadmin` que genere un enlace `wa.me` con mensaje pre-armado estructurado en 3 pasos pedagógicos para validar todo el flujo de monetización y acreditación (Invitación S/ 10 + Bienvenida S/ 20 + Código Evaluador PRUEBA2026 S/ 20 = S/ 50 totales para canjear 1 mes de Plan Comerciante a costo S/ 0.00), con URL de producción oficial.

#### Grupo 2: Onboarding y Retención de Testers (Prioridad Alta — Listo para Ejecución)
- [ ] App: web | Tarea [GTM-2.1] (Soporte Directo Fundador): Implementar botón flotante / acceso rápido de WhatsApp y correo de soporte en Landing y Dashboard con copy cercano (*"Soporte Directo con el Desarrollador"*) para resolución inmediata de incidencias.
- [ ] App: web | Tarea [GTM-2.2] (Blindaje Legal Beta): Añadir checkbox obligatorio (Opt-In) en el formulario de registro/"Únete" donde el usuario acepta que el aplicativo está en fase Beta experimental (*As-Is*), sin SLA ni garantías operativas durante el periodo gratuito.
- [ ] App: web | Tarea [GTM-2.3] (Señalética Fase de Pruebas): Incluir badges contextuales discretos de *"Versión Beta"* en el encabezado del Dashboard y vistas clave, gobernados por la variable `NEXT_PUBLIC_IS_BETA_PHASE`.
- [ ] App: web | Tarea [GTM-2.4] (Estrategia de Billeteras): Destacar **Yape** y **Lemon (Plin)** como 100% operativas y marcar el resto de billeteras premapeadas como *"Bajo Demanda / En Validación"*, incluyendo botón *"Solicitar Activación"* que redirija al WhatsApp del fundador con mensaje pre-redactado.

#### Grupo 3: Claridad Comercial y Documentación (Prioridad Media — Requiere Profundización Previa al Iniciar)
- [ ] App: web | Tarea [GTM-3.1] (Cómo Funciona y FAQ): Diseñar e integrar secciones explicativas "Cómo funciona" y "Preguntas Frecuentes (FAQ)" en el Landing Page. *(Definir estructura detallada al iniciar iteración)*.
- [ ] App: web | Tarea [GTM-3.2] (Actualización PricingCards): Actualizar descripciones y beneficios de planes en `PricingCards.tsx`, especificando el alcance de Webhooks/WebSockets. *(Refinar textos al iniciar iteración)*.
- [ ] App: web | Tarea [GTM-3.3] (Manual de Uso): Elaborar guía rápida / manual de usuario accesible desde la web para el flujo de pruebas y operación regular. *(Definir formato web/PDF al iniciar iteración)*.

#### Grupo 4: Ajustes de Interfaz Web / UI Tweaks (Prioridad Media-Baja — Requiere Profundización Previa al Iniciar)
- [x] App: web | Tarea [GTM-4.1] (Refinamiento Navbar): Centrar barra de navegación superior, implementar *scroll-to-top* al pulsar la vista activa y agrupar el botón *Theme Toggle* a la derecha de la barra central.
- [ ] App: web | Tarea [GTM-4.2] (Componentes Promocionales Modulares): Diseñar variantes reutilizables de banners/tarjetas promocionales para el Landing Page. *(Definir diseños al iniciar iteración)*.
- [ ] App: web | Tarea [GTM-4.3] (Hero Media en Uso Real & Variante Minimizada de HeroTrialBadge - Producción): Incorporar composición visual de las aplicaciones en uso real (fotografías editadas / mockups de operación o fondos SVG a medida ocupando el bloque principal del Hero) y adaptar `<HeroTrialBadge />` a una versión minimizada/compacta ubicada en una esquina sobre o junto al nuevo arte final. *(Ejecutar en fase de Producción una vez elaboradas las piezas gráficas)*.

#### Grupo 5: Deuda Técnica y Legal Post-Adquisición (Prioridad Baja — Requiere Profundización Previa al Iniciar)
- [ ] App: db/web | Tarea [GTM-5.1] (Refinamiento Payload Webhooks): Optimizar y estandarizar la estructura del JSON emitido en el flujo de Webhooks/WebSockets para integraciones B2B. *(Analizar contrato JSON antes de implementar)*.
- [ ] App: db/web | Tarea [GTM-5.2] (Eliminación Legal de Datos): Implementar RPC en Supabase y opción en el panel web para el borrado automatizado de cuenta y datos a solicitud del titular. *(Analizar reglas de cascada y retención legal antes de implementar)*.

## 📌 Tareas Programadas para Siguiente Iteración (Onboarding y UX)

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
- [x] App: viewer | Tarea (DevOps): Configuración de 'release-please' con manifiesto 1.0.1, sincronización con Gradle, UI dinámica de versión y auto-deploy con PAT a Google Play.
- [ ] App: admin | Tarea (DevOps): Replicar configuración de 'release-please' (manifiesto 1.0.1, sincronización con Gradle, PAT y auto-deploy a Google Play).
- [ ] App: admin/viewer | Tarea (DevOps): Automatizar el llenado de 'Notas de la Versión' en Google Play. (Modificar el Action de Google Play Upload para que envíe el extracto del CHANGELOG.md a la consola usando Fastlane o las capacidades nativas del action).
- [ ] App: specs | Tarea (Knowledge): Crear la skill 'skill_versioning_and_releases' para los agentes de desarrollo. Definirá las reglas estrictas de Conventional Commits, la jerarquía de SemVer (1.X.X para features, 1.0.X para parches), y el flujo de cuándo generar un release en lugar de solo acumular commits.
- [ ] App: viewer | Tarea (DevOps): Desacoplar modo 'Pre-producción (Solo Fixes/Patches)' y reactivar SemVer completo (feat/fix) tras el lanzamiento oficial a Producción.
- [ ] App: admin | Tarea (DevOps): Desacoplar modo 'Pre-producción (Solo Fixes/Patches)' y reactivar SemVer completo (feat/fix) tras el lanzamiento oficial a Producción.



