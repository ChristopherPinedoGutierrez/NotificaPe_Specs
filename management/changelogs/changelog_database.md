---
### 2026-06-28 14:45 | App/Componente: NotificaPe_Specs | Autor: AGENT_ROLE (Arquitecto)

* **Descripción:** Consolidación preliminar de Base de Datos y Handoff a Desarrollo.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0002_logica_disputas.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0002_logica_disputas.sql), [schema.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/schema.sql)
  - **Base de Datos:** Añadida vista (`view_notificaciones_disputadas`), función (`rpc_resolver_disputas`) y trigger preliminar para resolución de disputas. (Sujeto a validación MCP).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Scripts documentados y agregados como extensión.
  - [x] AC 2: Handoff de directorios ejecutado (Paso 3.4).
---
### 2026-06-28 16:27 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Validación exitosa en producción/desarrollo de la estructura de disputas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** Ninguno.
  - **Base de Datos:** Verificación de la vista `view_notificaciones_disputadas` y ejecución del RPC `resolver_disputa` (confirmada por el usuario en pruebas). La lógica de mediación de reclamantes y descarte de disputas opera correctamente desde el frontend Next.js.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Visualización correcta de justificaciones de múltiples reclamantes.
  - [x] AC 2: Aprobación y asignación del cobro al vendedor ganador mediante llamada segura al RPC.
  - [x] AC 3: Descarte exitoso para retornar cobro a estado PENDIENTE.
---
### 2026-06-28 21:30 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Implementación de borrado de dispositivos, límites de licencias en UI (dispositivos y usuarios), y optimización de resiliencia realtime.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0017_licencias_por_contratante.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0017_licencias_por_contratante.sql), [actions.ts (dispositivos/[id])](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/actions.ts), [page.tsx (dispositivos/[id])](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx), [DeviceCardGrid.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DeviceCardGrid.tsx), [page.tsx (accesos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/page.tsx), [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx)
  - **Base de Datos:** Actualizadas funciones `check_device_limit()` y `check_user_limit()` para evaluar únicamente elementos activos/aprobados. Creado trigger y función `enforce_downgrade_limits()` para desactivar/bloquear excedentes ante downgrades de plan en vivo.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Borrado físico seguro de dispositivos con eliminación de dependencias en cascada y advertencia detallada en la UI.
  - [x] AC 2: Control de límites activos en switches de cajas y aprobaciones de vendedores en UI con modal de reasignación rápida de cupos.
  - [x] AC 3: Indicador de uso `( X / Y )` y alerta persistente en el dashboard de Accesos ante downgrades.
  - [x] AC 4: Resiliencia de WebSockets al reanudar pestaña (Visibility API) con refresco automático de token JWT para prevenir caídas silenciosas.
---
### 2026-06-29 12:10 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Refinamiento de visualización del Ranking de Vendedores, acordeones de Dispositivos en el Modal y fix de scroll horizontal en hover.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Corrección de scrollbar horizontal mediante overflow-hidden en el card-botón de ingresos por dispositivo.
  - [x] AC 2: Contenedor estático del Ranking con un card clicable que posee filas fijas simétricas para el Top 1, Top 2 y Top 3 (rellenando vacíos con guiones y S/ 0.00).
  - [x] AC 3: Renombre de la pestaña del modal a "Ventas por Dispositivo" mostrando un listado de acordeones de Cajas (el primero abierto de forma reactiva al iniciar).
  - [x] AC 4: Listado unificado en "Resumen General" mostrando a todos los vendedores aprobados por orden de mayor a menor monto cobrado hoy.
  - [x] AC 5: Verificación sintáctica y tipado de TypeScript confirmada como 100% exitosa con next build.
---
### 2026-06-29 13:00 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Refinamientos de UX en el Dashboard: corrección de scrollbar, título del modal de dispositivos, ampliación de texto en cards de notificaciones y corrección de la lógica de contadores de alertas del día.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/actions.ts)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Eliminado scrollbar horizontal en la lista de Ingresos por Dispositivo al hacer hover (overflow-x-hidden).
  - [x] AC 2: Título del modal de detalle corregido de "Detalle de Caja" a "Detalle de Dispositivo".
  - [x] AC 3: Texto descriptivo de los 3 cards de Detalles de Notificaciones ampliado de text-[9px] a text-xs para mejorar legibilidad.
  - [x] AC 4: Campo ContadorReclamaciones agregado al SELECT de fetchDashboardMetrics para habilitar distinción entre Observadas y En Disputa.
  - [x] AC 5: Lógica de alertasHoy reescrita: Observadas = REVISION con ContadorReclamaciones 0/null; En Disputa = REVISION con ContadorReclamaciones >= 2; Sin Reclamar = sin NotificacionesAUsuarios.
---
### 2026-06-29 13:30 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de actualización en tiempo real del Dashboard: eliminación de listener muerto (ConflictosXNotificacion) y sustitución del Server Action por cliente Supabase directo en el handler Realtime para garantizar datos frescos sin caching de Next.js.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/actions.ts)
  - **Base de Datos:** Ninguno. Verificado vía MCP: NotificacionesXDispositivo tiene REPLICA IDENTITY FULL y está en la publicación supabase_realtime. ConflictosXNotificacion confirmada como tabla heredada fuera de la publicación.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Escucha D (ConflictosXNotificacion) eliminada del canal Realtime — tabla heredada no publicada que nunca disparaba eventos.
  - [x] AC 2: ConflictosXNotificacion eliminada del tipo Notificacion, del SELECT de fetchDashboardMetrics y de la query de refreshDailyData.
  - [x] AC 3: Nueva función refreshDailyData (useCallback) implementada con cliente Supabase del navegador: consulta NotificacionesXDispositivo con filtros de fecha Peru (-05:00) y usuario directamente, sin Server Action.
  - [x] AC 4: Handler de Realtime (Escucha A) actualizado para llamar refreshDailyData en lugar de fetchDashboardMetrics, eliminando el caching de Next.js como causa de datos desactualizados.
  - [x] AC 5: Dependencias del useEffect del canal actualizadas para incluir refreshDailyData.
---

