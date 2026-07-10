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
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/actions.ts)
  - **Base de Datos:** Ninguno. Verificado vía MCP: NotificacionesXDispositivo tiene REPLICA IDENTITY FULL y está en la publicación supabase_realtime. ConflictosXNotificacion confirmada como tabla heredada fuera de la publicación.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Escucha D (ConflictosXNotificacion) eliminada del canal Realtime — tabla heredada no publicada que nunca disparaba eventos.
  - [x] AC 2: ConflictosXNotificacion eliminada del tipo Notificacion, del SELECT de fetchDashboardMetrics y de la query de refreshDailyData.
  - [x] AC 3: Nueva función refreshDailyData (useCallback) implementada con cliente Supabase del navegador: consulta NotificacionesXDispositivo con filtros de fecha Peru (-05:00) y usuario directamente, sin Server Action.
  - [x] AC 4: Handler de Realtime (Escucha A) actualizado para llamar refreshDailyData en lugar de fetchDashboardMetrics, eliminando el caching de Next.js como causa de datos desactualizados.
  - [x] AC 5: Dependencias del useEffect del canal actualizadas para incluir refreshDailyData.
---
### 2026-06-29 14:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Migración de la Bitácora de Notificaciones Históricas a un Client Component interactivo unificando el flujo de carga, skeletons y realtime con el panel de control.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/page.tsx), [NotificationFilters.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/NotificationFilters.tsx), [ClientLimitSelector.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/ClientLimitSelector.tsx), [NotificacionesHistoricasClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/NotificacionesHistoricasClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Creado componente cliente integrador `NotificacionesHistoricasClient.tsx` que maneja estados locales de filtros, paginación, suma financiera y carga en el cliente.
  - [x] AC 2: Modificado `NotificationFilters.tsx` para admitir props controladas de forma opcional y callbacks de cambio directa para evitar redirección y congelamiento de UI en navegaciones suaves de Next.js.
  - [x] AC 3: Modificado `ClientLimitSelector.tsx` agregando la prop callback `onLimitChange` para control en cliente.
  - [x] AC 4: Adaptado el Server Component `page.tsx` para servir como inyector de datos estáticos iniciales de catálogos y renderizar el componente cliente.
  - [x] AC 5: Implementada actualización en tiempo real nativa en el cliente sobre el canal `notif_historial_tabla_client` llamando de forma silenciosa a `fetchData`, y mostrando skeleton visual reactivo de inmediato ante cambios manuales de filtros.
---
### 2026-06-29 14:10 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Optimización del espacio vertical del Dashboard: integración de cabecera general con controles de fecha y exportación en una sola fila a la derecha.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PageContainer.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/PageContainer.tsx), [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/page.tsx), [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Modificado `PageContainer` para hacer opcional la cabecera cuando no se provee la prop `title`, permitiendo a vistas específicas controlar su estructura de cabecera de forma nativa.
  - [x] AC 2: Extraído el encabezado ("Resumen General" y descripción de bienvenida) del Server Component de dashboard y trasladado al cliente `DashboardClient.tsx` para integrarlo con el estado del selector de fecha y los botones de exportación.
  - [x] AC 3: Reubicados el selector de fecha y el menú de exportación Excel/CSV a la esquina superior derecha alineados horizontalmente en la misma fila que el título y subtítulo, eliminando la fila secundaria y reduciendo la altura vertical para mitigar scroll en pantallas medianas.
---
### 2026-06-29 14:25 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de la lógica de conteo "Sin Reclamar" en Dashboard y soporte para inicialización y persistencia de filtros mediante Query Params en la bitácora histórica.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [NotificacionesHistoricasClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/NotificacionesHistoricasClient.tsx), [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Corregida la lógica en `DashboardClient.tsx` para calcular `sinRecHoy` requiriendo estrictamente que `EstadoProgreso === 'PENDIENTE'`, evitando la doble suma de notificaciones Observadas.
  - [x] AC 2: Redirigido el card "Sin Reclamar" a la bitácora de históricas con query string de filtrado: `/dashboard/notificaciones/historicas?estado=PENDIENTE`.
  - [x] AC 3: Implementada la lectura e inicialización de estados locales en `NotificacionesHistoricasClient.tsx` a través del hook `useSearchParams`, asumiendo parámetros de URL de filtros de estado, dispositivos, billeteras, fecha y paginación en el primer renderizado.
  - [x] AC 4: Añadido efecto secundario reactivo en `NotificacionesHistoricasClient.tsx` que sincroniza los estados del cliente de vuelta con los Query Params de la URL usando `window.history.replaceState` de manera transparente y no bloqueante.
---
### 2026-06-29 14:35 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Ajustes de UI del Dashboard: renombrado de "Vendedores" a "Usuarios" (ranking y modal), inclusión de todos los dispositivos del contratante en el desglose del modal (incluso con S/ 0.00 hoy) y adición de filas de sumatorias totales.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/page.tsx), [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Consultados todos los dispositivos activos e inactivos del contratante en `page.tsx` y pasados al cliente mediante la prop `dispositivos`.
  - [x] AC 2: Modificada la inicialización de `byDevice` en `useMemo` de `DashboardClient.tsx` para pre-poblar el listado con todos los dispositivos del contratante con total `S/ 0.00`, asegurando que aparezcan en el modal de rendimiento.
  - [x] AC 3: Renombradas las referencias de "Vendedores" a "Usuarios" en el título de la tarjeta del dashboard y en el encabezado del modal.
  - [x] AC 4: Añadida fila estacional y fija de **TOTAL GENERAL** al final de la pestaña **Resumen General** (acumulando el monto y cantidad de cobros de todos los usuarios).
  - [x] AC 5: Añadida fila de **TOTAL GENERAL** al final de la pestaña **Ventas por Dispositivo** (acumulando los ingresos por dispositivo de todos los terminales).
---
### 2026-06-29 14:40 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Ajustes adicionales de UI en el modal de rendimiento: renombrado de pestaña a "Ventas por Usuario" e inclusión del desglose de cobros "Sin Reclamar" dentro de la pestaña "Ventas por Dispositivo" para cada caja vinculada.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Renombrada la primera pestaña del modal de desempeño de *"Resumen General"* a *"Ventas por Usuario"*.
  - [x] AC 2: Incorporada la acumulación de montos y operaciones de notificaciones en estado `'PENDIENTE'` (`unclaimedTotal` y `unclaimedCount`) por cada dispositivo hoy en `useMemo`.
  - [x] AC 3: Añadido desglose de cobros **"Sin Reclamar"** (en formato itálica y color suave) al final del dropdown/acordeón de cada dispositivo en la pestaña **Ventas por Dispositivo**, siempre que tenga cobros huérfanos hoy.
---
### 2026-06-29 14:42 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Ajuste de UI en Dashboard principal: renombrado de la tarjeta de ranking a "Ingresos por usuario".
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Renombrado el título de la tarjeta de ranking en el Dashboard a **"Ingresos por usuario"** para unificar la nomenclatura con las secciones del modal.
---
### 2026-06-29 14:52 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Refactorización de Dashboard y rediseño de Ingresos por Dispositivo: extracción a componente independiente y maquetación en grid responsivo de 1 a 3 columnas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [DeviceIncomeList.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceIncomeList.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Extraído el marcado y la lógica de "Ingresos por Dispositivo" a un componente reactivo independiente [DeviceIncomeList.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceIncomeList.tsx).
  - [x] AC 2: Rediseñado el listado vertical a un grid responsivo adaptable basado en la cantidad de dispositivos (`grid-cols-1`, `sm:grid-cols-2`, `xl:grid-cols-3` como límite).
  - [x] AC 3: Asegurado que los dispositivos sobrantes (4 en adelante) se posicionen en la fila siguiente alineados a la izquierda sin deformarse.
---
### 2026-06-29 14:55 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Componentización y refactorización masiva de DashboardClient.tsx: extracción de modales, cabeceras, tarjetas métricas y skeletons a componentes independientes, reduciendo el tamaño del archivo de 1050+ a ~450 líneas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx), [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx), [DeviceDetailsModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceDetailsModal.tsx), [UserPerformanceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/UserPerformanceModal.tsx), [DashboardSkeleton.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardSkeleton.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Extraído el encabezado dinámico y controles de rango y exportación a [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx).
  - [x] AC 2: Extraído el layout de las tarjetas métricas (Plan, Dispositivos y Accesos de Usuarios) a [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx).
  - [x] AC 3: Encapsulado el modal detallado de billeteras y total por caja a [DeviceDetailsModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceDetailsModal.tsx).
  - [x] AC 4: Encapsulado el modal de desempeño de usuarios (con pestañas "Ventas por Usuario" y "Usuarios por Dispositivo") a [UserPerformanceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/UserPerformanceModal.tsx).
  - [x] AC 5: Externalizado el maquetado del skeleton animado de carga y la tarjeta auxiliar `StatCard` a [DashboardSkeleton.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardSkeleton.tsx).
  - [x] AC 6: Validada la compilación exitosa de Next.js, logrando separar la lógica de suscripciones realtime y exportación XLS del maquetado estático de modales.
---
### 2026-06-29 14:58 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de la maquetación en DashboardStatsCards: remoción del grid de 4 columnas duplicado que provocaba que la tarjeta de licencias colapsara a 1 sola columna.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Removido el wrapper `<div className="grid grid-cols-1 lg:grid-cols-4 ...">` en `DashboardStatsCards.tsx`.
  - [x] AC 2: Asegurado que el componente devuelva directamente `<div className="lg:col-span-3 flex flex-col">` para que se monte fluidamente sobre el grid principal de `DashboardClient.tsx`.
---
### 2026-06-29 15:00 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Ajuste de UI en el botón de exportación: reemplazo del fondo traslúcido (`glass-panel`) del menú desplegable de formatos por un fondo sólido (`bg-white` y `dark:bg-gray-900`) para evitar superposiciones y opacidades conflictivas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Reemplazada la clase `glass-panel` por `bg-white dark:bg-gray-900` y agregadas las directivas de bordes sólidos en el dropdown del botón de exportar.
---
### 2026-06-29 15:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de estilos de tema oscuro en modales: reemplazo de la clase inexistente `gray-955` por `gray-950` y ajuste de colores de texto a variables estándar de Tailwind.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DeviceDetailsModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceDetailsModal.tsx), [UserPerformanceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/UserPerformanceModal.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Reemplazada la clase de fondo `dark:bg-gray-955` por la clase estándar `dark:bg-gray-950` en el contenedor de los modales de dispositivo y desempeño.
  - [x] AC 2: Reemplazada la clase de texto `text-gray-955` por `text-gray-900` para garantizar un contraste correcto en modo claro e invocar `dark:text-white` fluidamente en modo oscuro.
---
### 2026-06-29 15:12 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Ajustes de UI en la vista de detalle de dispositivo: renombrado de botón de eliminación y diferenciación cromática (anaranjado) para la desvinculación física.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx), [UnlinkDeviceButton.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/UnlinkDeviceButton.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Cambiado el texto del botón en la tarjeta de datos a **"Eliminar Dispositivo"** (reemplazando "Eliminar Caja / Dispositivo").
  - [x] AC 2: Cambiado el esquema de color del botón **"Desvincular"** y de su modal de confirmación a un tono anaranjado (`bg-amber-50`, `text-amber-600` e icono `AlertTriangle` en ámbar) para diferenciarlo de las acciones destructivas rojas.
---
### 2026-06-29 15:28 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Parche de seguridad y optimización de cuota de red en Supabase Realtime: restricción y filtrado en origen de eventos en la tabla `DispositivosXContratante` por `IdContratante`.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/layout.tsx), [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx)
  - **Base de Datos:** Ninguno (se utiliza el filtrado nativo de canal de Supabase en cliente).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Inyectado el parámetro `userId` desde el Layout Server Component al `DispositivosViewProvider` Client Component.
  - [x] AC 2: Agregado el parámetro `filter: "IdContratante=eq." + userId` a la suscripción Realtime del proveedor. Esto evita que Supabase envíe eventos ajenos por WebSocket, previniendo la visualización de dispositivos de terceros y ahorrando consumo en la cuota de mensajes.
---
### 2026-06-29 15:32 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Ajuste en SidebarNav para preservar la selección visual del módulo activo al navegar en subrutas de detalle (ej: dispositivos/[id]).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Modificada la variable `isExactActive` en `SidebarNav.tsx` para que valide coincidencia exacta (`pathname === link.href`) o coincidencia de prefijo con barra (`pathname.startsWith(link.href + "/")`).
  - [x] AC 2: Garantizado que al acceder a las configuraciones individuales de una caja en `/dashboard/dispositivos/[id]`, el botón principal *"Dispositivos y Seguridad"* se mantenga resaltado en azul de forma persistente.
---
### 2026-06-29 15:33 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de solapamiento en SidebarNav: exclusión de la regla de prefijos para la ruta raíz `/dashboard` para evitar la iluminación permanente de *"Resumen General"*.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Añadida la restricción `link.href !== "/dashboard"` en la validación por prefijo de `isExactActive`.
  - [x] AC 2: Confirmado que al ingresar a otros módulos independientes (ej: `/dashboard/dispositivos`), el ítem *"Resumen General"* se apague correctamente.
---
### 2026-06-29 18:45 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de redirección en la tarjeta *"Sin Reclamar"* de DashboardClient para conservar el día consultado en el filtro de la bitácora de históricas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Modificado el enlace del card de cobros huérfanos para inyectar de forma dinámica las propiedades `fechaInicio` y `fechaFin` igual al estado reactivo `${date}` del selector de fechas del Dashboard.
  - [x] AC 2: Asegurado que al redireccionar al usuario a `/dashboard/notificaciones/historicas`, el filtro de rango de fechas se cargue exactamente con el día seleccionado previamente en lugar de resetearse a "Hoy".
---
### 2026-06-29 20:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de regresión de permisos en base de datos: restitución de la cláusula `SECURITY DEFINER` en triggers de control de límites de licencias.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0017_licencias_por_contratante.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0017_licencias_por_contratante.sql)
  - **Base de Datos:** Ejecutadas directivas `ALTER FUNCTION public.check_device_limit() SECURITY DEFINER` y `ALTER FUNCTION public.check_user_limit() SECURITY DEFINER` en caliente en Supabase.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Asegurado que el trigger `check_device_limit` se ejecute con privilegios de superusuario (`SECURITY DEFINER`) para bypassear las restricciones RLS al ser invocado por el cliente móvil anónimo (`anon`).
  - [x] AC 2: Asegurado que el trigger `check_user_limit` cuente con la misma directiva de seguridad para prevenir fallos al aprobar o desaprobar accesos de vendedores desde el móvil.
---
### 2026-06-29 20:20 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Implementación de persistencia para el badge de solicitudes pendientes en el Sidebar y rediseño premium del indicador en el Dashboard.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/layout.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx), [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx)
  - **Base de Datos:** Ninguno (se aprovechan las políticas RLS y consultas optimizadas existentes).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Inicializado el contador de solicitudes en el servidor (`layout.tsx`) de forma paralela y transmitido como prop inicial al `RealtimeProvider`, garantizando que el badge del Sidebar no se resetee a 0 en recargas de página.
  - [x] AC 2: Rediseñado el badge de pendientes del Dashboard utilizando un color de fondo suave y limitando la animación de latido (`animate-pulse`) únicamente al círculo rojo estético del indicador, evitando vibraciones molestas de todo el card.
---
### 2026-06-29 20:55 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de la sincronización Realtime para solicitudes de acceso pendientes (badge del Sidebar).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/layout.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx), [0025_rls_autorizaciones_web.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0025_rls_autorizaciones_web.sql)
  - **Base de Datos:** Actualizada la política RLS en `AutorizacionesXUsuario`. Se separó la política global en dos: una restrictiva para escritura (mantiene `EXISTS`) y una simple para lectura (`USING (true)`) para que sea compatible con Supabase Realtime.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Resuelto el bloqueo de transmisión en Supabase Realtime eliminando la subconsulta `EXISTS` en la regla de lectura RLS de `AutorizacionesXUsuario`.
  - [x] AC 2: Implementada la suscripción del lado del cliente en `RealtimeProvider.tsx` de forma individualizada para cada `IdDispositivo` mediante `filter: IdDispositivo=eq.UUID`. Esto aísla a nivel de red la recepción de datos y previene el consumo innecesario de mensajes de otros contratantes.
---
### 2026-06-30 20:57 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Rediseño, extensión e interactividad de la Landing Page principal de la web, aislando precios, añadiendo descargas directas de APKs con temporizadores de protección y aplicando transiciones de entrada animadas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/page.tsx), [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx), [PricingCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/PricingCards.tsx), [globals.css](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/globals.css)
  - **Base de Datos:** Ninguno (la distribución de APKs y el reajuste del grid de precios son exclusivamente visuales y estructurales).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Aislados los precios en la pestaña secundaria **Licencias** y renombrado los encabezados para omitir mención obligatoria de compra durante las pruebas de la Google Play Store.
  - [x] AC 2: Reestructurada la cuadrícula de planes a un grid de 3 columnas centrado y balanceado para adaptarla a los 3 planes vigentes en lugar de 4.
  - [x] AC 3: Implementados botones de descarga directa apuntando al bucket público `app_releases` de Supabase Storage, integrando una protección por código de 5 segundos contra descargas repetidas (clics sucesivos).
  - [x] AC 4: Añadido el paso 3 (desactivación temporal de Play Protect) en la guía rápida de instalación de APKs.
  - [x] AC 5: Programadas animaciones dinámicas nativas en CSS (fadeInUp, slideInLeft, slideInRight) para evitar un diseño estático al navegar y cargar pestañas.
---
### 2026-07-02 20:20 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Integración frontend del flujo de pago Checkout Pro de Mercado Pago en la tarjeta de precios para habilitar compras automatizadas de licencias.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PricingCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/PricingCards.tsx), [.env.local](file:///c:/Trabajo/Proyectos/NotificaPe/web/.env.local)
  - **Base de Datos:** Ninguno (la lógica transaccional de créditos ya está escrita en el backend y es gatillada por el webhook).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Añadido chequeo de autenticación. Los usuarios no logueados son redirigidos de forma automática a la pantalla de `/login` al hacer clic en "Elegir Plan".
  - [x] AC 2: Implementado consumo a la Edge Function `mercadopago_preferencia` en Supabase enviando los metadatos requeridos (monto, moneda, licencia, idempotencia, contratante y email).
  - [x] AC 3: Configurada la redirección dinámica hacia las URLs de Checkout Pro (Sandbox o Producción) según la variable global `NEXT_PUBLIC_MERCADOPAGO_ENV`.
  - [x] AC 4: Creado el estado de carga `buyingPlanId` para desactivar el formulario e ilustrar el spinner "Procesando..." durante la llamada a la API.
---
### 2026-07-04 22:20 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Integración y validación del flujo de compras en Sandbox de Mercado Pago y mejoras de UX en el gestor de licencias.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [actions.ts (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts), [page.tsx (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx), [BotonCancelarCola.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/BotonCancelarCola.tsx), [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx), [mercadopago_preferencia/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_preferencia/index.ts), [mercadopago_webhook/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_webhook/index.ts)
  - **Base de Datos / Edge Functions:**
    * Modificada la Edge Function `mercadopago_preferencia` para incluir la cantidad seleccionada en la metadata, inyectar el token en la query URL de notificación y forzar HTTPS en los retornos.
    * Modificada la Edge Function `mercadopago_webhook` para invocar a la función SQL de compra de licencias múltiples y soportar el token de seguridad. Se desactivó la verificación JWT heredada de Supabase para admitir webhooks externos.
  - **Frontend UI:**
    * Creado el componente cliente `BotonCancelarCola` con modal interactivo de confirmación y efecto blur.
    * Simplificado el resumen de compra en el Wizard (Opción A) mostrando Subtotal, Descuento y Total de forma directa, y un desglose de saldo bajo un acordeón interactivo.
    * Corregido bug de reactividad al multiplicar meses/años mapeando a ambos campos del crédito (`credito_aplicable_en_unidad_minima` y `credito_aplicado_en_unidad_minima`).
    * Corregido el botón del header "Atrás" para que retroceda al paso 1 en lugar de salir del Wizard al estar en el paso 2.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Flujo completo de cobro y registro de licencias simples y múltiples validado en Sandbox.
  - [x] AC 2: Prevención de clicks accidentales en cancelación mediante modal de confirmación en cliente.
  - [x] AC 3: Visualización financiera de Checkout limpia y resumida para evitar confusión de números.
  - [x] AC 4: Navegación de regreso no disruptiva en el Wizard de licencias.
---
### 2026-07-07 14:15 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **Descripción:** Implementación de resiliencia y monitoreo pasivo en tiempo real (Hito 1) y separación del estado de bloqueo ("Inactivo") frente a desvinculación física.
* **Detalles Técnicos:**
  - **Archivos Creados:** [RealtimeHealthMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/realtime/RealtimeHealthMonitor.kt), [RealtimeIntegrityManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/realtime/RealtimeIntegrityManager.kt), [BlockedScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/BlockedScreen.kt)
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [SyncRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/SyncRealtimeHandler.kt), [AppNavigation.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/navigation/AppNavigation.kt), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Lógica de Conectividad (Hito 1):**
    * Portada la monitorización de salud pasiva en segundo plano con intervalos rápidos de 10s (timeout 15s / zombie 5m).
    * Implementada la curva de reintentos mediante backoff exponencial (1s a 60s) en lugar de loops repetitivos.
    * Ampliado el scavenger de recuperación delta a 5 minutos (300 segundos).
  - **Lógica de Bloqueo (Estado Inactivo):**
    * Creado el estado `DeviceStatus.Blocked` en el repositorio para evitar eliminar datos locales (notificaciones/Room) cuando la caja solo es marcada como inactiva administrativamente.
    * Al detectar `Activo = false`, se cierra la conexión realtime del terminal para no retener canales socket abiertos inútilmente.
    * Redireccionado automático del usuario a la vista `BlockedScreen`, la cual muestra un diseño elegante y desactiva las conexiones.
    * Añadido botón "Verificar Estado" en la pantalla de bloqueo para consultar si el administrador reactivó la caja, implementando un cooldown timer de 10 segundos para prevenir abuso de peticiones (spam clicks).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Watchdogs rápidos y Backoff Exponencial integrados quirúrgicamente.
  - [x] AC 2: Evitada la pérdida de base de datos local Room en deactivación (mantenimiento de vinculación lógica).
  - [x] AC 3: Desconexión total del socket en estado bloqueado.
  - [x] AC 4: Navegación controlada bidireccionalmente e interfaz de bloqueo con cooldown en botón de refresco.
---
### 2026-07-07 21:46 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **Descripción:** Corrección de la resolución de la pasarela de Mercado Pago en producción (EasyPanel y Supabase) haciendo dinámico el enrutamiento de la URL de checkout.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PricingCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/PricingCards.tsx), [actions.ts (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts), [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx), [mercadopago_preferencia/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_preferencia/index.ts), [Dockerfile](file:///c:/Trabajo/Proyectos/NotificaPe/web/Dockerfile)
  - **Base de Datos / Edge Functions:**
    * Actualizada la Edge Function `mercadopago_preferencia` para retornar un campo dinámico `checkout_url` calculando a nivel de servidor (según `MERCADOPAGO_ENV`) si se debe usar la URL de producción (`init_point`) o sandbox (`sandbox_init_point`).
  - **Frontend UI:**
    * Modificada la redirección en `WizardGestionarLicencias` y `PricingCards` para preferir el campo dinámico `checkout_url` devuelto por el servidor, independientemente de la variable de entorno `NEXT_PUBLIC_MERCADOPAGO_ENV` compilada estáticamente en el frontend.
    * Agregados los argumentos de compilación `NEXT_PUBLIC_MERCADOPAGO_ENV` y `NEXT_PUBLIC_APP_URL` en el `Dockerfile` para soportar variables de entorno en compilaciones de producción de EasyPanel si fueran necesarias.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Resuelto el problema de redirección a Sandbox al delegar la decisión de enrutamiento al backend.
  - [x] AC 2: Reducción de discrepancias entre entornos al centralizar la configuración de variables en Supabase Secrets.
  - [x] AC 3: Dockerfile actualizado con compatibilidad para build args de entorno.
---
### 2026-07-07 22:30 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **Descripción:** Sincronización del Foreground Service de escucha de notificaciones con el estado de activación en tiempo real de la caja (Hito 2).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Lógica de Sincronización del Servicio (Hito 2):**
    * Modificado el método `onNotificationPosted` del servicio para validar que el estado del dispositivo sea estrictamente `Linked`. Si el terminal está bloqueado/inactivo, se aborta la captura y sincronización de forma inmediata en segundo plano.
    * Agregada la recolección activa del flujo `deviceStatus` dentro de `onStartCommand` en el servicio para mutar la notificación persistente: cambia a "Monitoreo Pausado | Caja desactivada por el administrador" en estado bloqueado, y a "Monitoreo Activo" al restablecerse.
    * Protegido el método `runScavenger` del servicio de escucha de notificaciones para abortar la barredora de transacciones si la caja se encuentra inhabilitada.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Visualización e indicación reactiva del estado del servicio en la barra de notificaciones del sistema de Android.
  - [x] AC 2: Prevención de capturas y subidas accidentales de notificaciones privadas estando la caja inactiva.
  - [x] AC 3: Barredora (Scavenger) de transacciones pausada en estado inactivo.
---
### 2026-07-10 10:04 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **Descripción:** Estabilización y resiliencia de la conexión Realtime en segundo plano mediante OkHttp pingInterval, Connecting Timeout Watchdog y Android NetworkMonitor.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [SupabaseModule.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/di/SupabaseModule.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **Mecanismos de Resiliencia:**
    * Configurado `pingInterval` de 45 segundos en OkHttp para evitar que operadoras móviles corten el canal WebSocket de manera silenciosa.
    * Implementado `connectingTimeoutJob` de 30 segundos en `AuthRepository` para realizar un hard reset automático si el socket queda atrapado en el estado de transición `CONNECTING`.
    * Integrada la escucha pasiva del `NetworkMonitor` nativo de Android en `AuthRepository` para reaccionar al instante cuando la conectividad física de datos o Wi-Fi se recupera.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Detección y reconexión inmediata del socket al recuperar señal.
  - [x] AC 2: Prevención de limbos infinitos en estado CONNECTING mediante watchdog de 30s.
  - [x] AC 3: Mantenimiento del canal activo a nivel de operadoras usando pingInterval de 45s.
---
### 2026-07-10 10:30 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **Descripción:** Corrección de la cascada de estados en RealtimeMonitorManager y estabilización del disparador de red con debounce. Remoción de pingInterval para evitar timeouts de CDNs.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeMonitorManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/manager/RealtimeMonitorManager.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [SupabaseModule.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/di/SupabaseModule.kt)
  - **Corrección de Bugs de Conectividad:**
    * Modificada la lógica de cascada en `RealtimeMonitorManager` para evaluar `status !is TableStatus.Subscribed` en el socket, asegurando que todos los canales se visualicen como desconectados si el socket no está activo.
    * Añadido `.debounce(1500)` al flujo de conectividad física en `AuthRepository` para evitar que rebotes de señal (antena celular / Wi-Fi) disparen múltiples resets de socket concurrentes o sucesivos.
    * Revertido `pingInterval` en `SupabaseModule` a la configuración por defecto para depender exclusivamente del heartbeat a nivel de aplicación (Phoenix text protocol), resolviendo desconexiones artificiales causadas por CDNs (como Cloudflare) que bloquean pings de control de bajo nivel.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Coherencia visual total entre el banner de conexión base y los canales individuales.
  - [x] AC 2: Evitada la reconexión múltiple iterativa (botes de red) al salir del modo avión.
  - [x] AC 3: Conexión WebSocket estable sin desconexiones artificiales tras un minuto.
---



