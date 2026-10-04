---
### [2026-10-04 18:15] | App/Componente: database | Autor: AGENT_ROLE

* **Descripción:** Implementación de compuertas de seguridad en trigger fn_dispatch_fcm_viewer para suprimir falsos pagos por S/ 0.00 o en REVISION [TSK-033].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0046_fix_fcm_viewer_filters.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0046_fix_fcm_viewer_filters.sql)
  - **Base de Datos:** Modificada función `public.fn_dispatch_fcm_viewer()` condicionando `action = 'NEW_PAYMENT'` a `NEW."Privada" = false AND NEW."MontoCentimos" > 0 AND NEW."EstadoProgreso" = 'PENDIENTE'`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Despacho push suprimido (payload = NULL) para inserciones técnicas, promocionales o sin monto comercial.
  - [x] AC 2: Script 0046 ejecutado y verificado en Supabase en vivo mediante MCP execute_sql.
---
### 2026-06-28 14:45 | App/Componente: NotificaPe_Specs | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** ConsolidaciÃ³n preliminar de Base de Datos y Handoff a Desarrollo.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [0002_logica_disputas.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0002_logica_disputas.sql), [schema.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/schema.sql)
  - **Base de Datos:** AÃ±adida vista (`view_notificaciones_disputadas`), funciÃ³n (`rpc_resolver_disputas`) y trigger preliminar para resoluciÃ³n de disputas. (Sujeto a validaciÃ³n MCP).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Scripts documentados y agregados como extensiÃ³n.
  - [x] AC 2: Handoff de directorios ejecutado (Paso 3.4).
---
### 2026-06-28 16:27 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** ValidaciÃ³n exitosa en producciÃ³n/desarrollo de la estructura de disputas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** Ninguno.
  - **Base de Datos:** VerificaciÃ³n de la vista `view_notificaciones_disputadas` y ejecuciÃ³n del RPC `resolver_disputa` (confirmada por el usuario en pruebas). La lÃ³gica de mediaciÃ³n de reclamantes y descarte de disputas opera correctamente desde el frontend Next.js.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: VisualizaciÃ³n correcta de justificaciones de mÃºltiples reclamantes.
  - [x] AC 2: AprobaciÃ³n y asignaciÃ³n del cobro al vendedor ganador mediante llamada segura al RPC.
  - [x] AC 3: Descarte exitoso para retornar cobro a estado PENDIENTE.
---
### 2026-06-28 21:30 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** ImplementaciÃ³n de borrado de dispositivos, lÃ­mites de licencias en UI (dispositivos y usuarios), y optimizaciÃ³n de resiliencia realtime.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [0017_licencias_por_contratante.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0017_licencias_por_contratante.sql), [actions.ts (dispositivos/[id])](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/actions.ts), [page.tsx (dispositivos/[id])](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx), [DeviceCardGrid.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DeviceCardGrid.tsx), [page.tsx (accesos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/page.tsx), [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx)
  - **Base de Datos:** Actualizadas funciones `check_device_limit()` y `check_user_limit()` para evaluar Ãºnicamente elementos activos/aprobados. Creado trigger y funciÃ³n `enforce_downgrade_limits()` para desactivar/bloquear excedentes ante downgrades de plan en vivo.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Borrado fÃ­sico seguro de dispositivos con eliminaciÃ³n de dependencias en cascada y advertencia detallada en la UI.
  - [x] AC 2: Control de lÃ­mites activos en switches de cajas y aprobaciones de vendedores en UI con modal de reasignaciÃ³n rÃ¡pida de cupos.
  - [x] AC 3: Indicador de uso `( X / Y )` y alerta persistente en el dashboard de Accesos ante downgrades.
  - [x] AC 4: Resiliencia de WebSockets al reanudar pestaÃ±a (Visibility API) con refresco automÃ¡tico de token JWT para prevenir caÃ­das silenciosas.
---
### 2026-06-29 12:10 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Refinamiento de visualizaciÃ³n del Ranking de Vendedores, acordeones de Dispositivos en el Modal y fix de scroll horizontal en hover.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: CorrecciÃ³n de scrollbar horizontal mediante overflow-hidden en el card-botÃ³n de ingresos por dispositivo.
  - [x] AC 2: Contenedor estÃ¡tico del Ranking con un card clicable que posee filas fijas simÃ©tricas para el Top 1, Top 2 y Top 3 (rellenando vacÃ­os con guiones y S/ 0.00).
  - [x] AC 3: Renombre de la pestaÃ±a del modal a "Ventas por Dispositivo" mostrando un listado de acordeones de Cajas (el primero abierto de forma reactiva al iniciar).
  - [x] AC 4: Listado unificado en "Resumen General" mostrando a todos los vendedores aprobados por orden de mayor a menor monto cobrado hoy.
  - [x] AC 5: VerificaciÃ³n sintÃ¡ctica y tipado de TypeScript confirmada como 100% exitosa con next build.
---
### 2026-06-29 13:00 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Refinamientos de UX en el Dashboard: correcciÃ³n de scrollbar, tÃ­tulo del modal de dispositivos, ampliaciÃ³n de texto en cards de notificaciones y correcciÃ³n de la lÃ³gica de contadores de alertas del dÃ­a.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/actions.ts)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Eliminado scrollbar horizontal en la lista de Ingresos por Dispositivo al hacer hover (overflow-x-hidden).
  - [x] AC 2: TÃ­tulo del modal de detalle corregido de "Detalle de Caja" a "Detalle de Dispositivo".
  - [x] AC 3: Texto descriptivo de los 3 cards de Detalles de Notificaciones ampliado de text-[9px] a text-xs para mejorar legibilidad.
  - [x] AC 4: Campo ContadorReclamaciones agregado al SELECT de fetchDashboardMetrics para habilitar distinciÃ³n entre Observadas y En Disputa.
  - [x] AC 5: LÃ³gica de alertasHoy reescrita: Observadas = REVISION con ContadorReclamaciones 0/null; En Disputa = REVISION con ContadorReclamaciones >= 2; Sin Reclamar = sin NotificacionesAUsuarios.
---
### 2026-06-29 13:30 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de actualizaciÃ³n en tiempo real del Dashboard: eliminaciÃ³n de listener muerto (ConflictosXNotificacion) y sustituciÃ³n del Server Action por cliente Supabase directo en el handler Realtime para garantizar datos frescos sin caching de Next.js.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/actions.ts)
  - **Base de Datos:** Ninguno. Verificado vÃ­a MCP: NotificacionesXDispositivo tiene REPLICA IDENTITY FULL y estÃ¡ en la publicaciÃ³n supabase_realtime. ConflictosXNotificacion confirmada como tabla heredada fuera de la publicaciÃ³n.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Escucha D (ConflictosXNotificacion) eliminada del canal Realtime â€” tabla heredada no publicada que nunca disparaba eventos.
  - [x] AC 2: ConflictosXNotificacion eliminada del tipo Notificacion, del SELECT de fetchDashboardMetrics y de la query de refreshDailyData.
  - [x] AC 3: Nueva funciÃ³n refreshDailyData (useCallback) implementada con cliente Supabase del navegador: consulta NotificacionesXDispositivo con filtros de fecha Peru (-05:00) y usuario directamente, sin Server Action.
  - [x] AC 4: Handler de Realtime (Escucha A) actualizado para llamar refreshDailyData en lugar de fetchDashboardMetrics, eliminando el caching de Next.js como causa de datos desactualizados.
  - [x] AC 5: Dependencias del useEffect del canal actualizadas para incluir refreshDailyData.
---
### 2026-06-29 14:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** MigraciÃ³n de la BitÃ¡cora de Notificaciones HistÃ³ricas a un Client Component interactivo unificando el flujo de carga, skeletons y realtime con el panel de control.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/page.tsx), [NotificationFilters.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/NotificationFilters.tsx), [ClientLimitSelector.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/ClientLimitSelector.tsx), [NotificacionesHistoricasClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/NotificacionesHistoricasClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Creado componente cliente integrador `NotificacionesHistoricasClient.tsx` que maneja estados locales de filtros, paginaciÃ³n, suma financiera y carga en el cliente.
  - [x] AC 2: Modificado `NotificationFilters.tsx` para admitir props controladas de forma opcional y callbacks de cambio directa para evitar redirecciÃ³n y congelamiento de UI en navegaciones suaves de Next.js.
  - [x] AC 3: Modificado `ClientLimitSelector.tsx` agregando la prop callback `onLimitChange` para control en cliente.
  - [x] AC 4: Adaptado el Server Component `page.tsx` para servir como inyector de datos estÃ¡ticos iniciales de catÃ¡logos y renderizar el componente cliente.
  - [x] AC 5: Implementada actualizaciÃ³n en tiempo real nativa en el cliente sobre el canal `notif_historial_tabla_client` llamando de forma silenciosa a `fetchData`, y mostrando skeleton visual reactivo de inmediato ante cambios manuales de filtros.
---
### 2026-06-29 14:10 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** OptimizaciÃ³n del espacio vertical del Dashboard: integraciÃ³n de cabecera general con controles de fecha y exportaciÃ³n en una sola fila a la derecha.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PageContainer.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/PageContainer.tsx), [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/page.tsx), [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Modificado `PageContainer` para hacer opcional la cabecera cuando no se provee la prop `title`, permitiendo a vistas especÃ­ficas controlar su estructura de cabecera de forma nativa.
  - [x] AC 2: ExtraÃ­do el encabezado ("Resumen General" y descripciÃ³n de bienvenida) del Server Component de dashboard y trasladado al cliente `DashboardClient.tsx` para integrarlo con el estado del selector de fecha y los botones de exportaciÃ³n.
  - [x] AC 3: Reubicados el selector de fecha y el menÃº de exportaciÃ³n Excel/CSV a la esquina superior derecha alineados horizontalmente en la misma fila que el tÃ­tulo y subtÃ­tulo, eliminando la fila secundaria y reduciendo la altura vertical para mitigar scroll en pantallas medianas.
---
### 2026-06-29 14:25 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de la lÃ³gica de conteo "Sin Reclamar" en Dashboard y soporte para inicializaciÃ³n y persistencia de filtros mediante Query Params en la bitÃ¡cora histÃ³rica.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [NotificacionesHistoricasClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/historicas/NotificacionesHistoricasClient.tsx), [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Corregida la lÃ³gica en `DashboardClient.tsx` para calcular `sinRecHoy` requiriendo estrictamente que `EstadoProgreso === 'PENDIENTE'`, evitando la doble suma de notificaciones Observadas.
  - [x] AC 2: Redirigido el card "Sin Reclamar" a la bitÃ¡cora de histÃ³ricas con query string de filtrado: `/dashboard/notificaciones/historicas?estado=PENDIENTE`.
  - [x] AC 3: Implementada la lectura e inicializaciÃ³n de estados locales en `NotificacionesHistoricasClient.tsx` a travÃ©s del hook `useSearchParams`, asumiendo parÃ¡metros de URL de filtros de estado, dispositivos, billeteras, fecha y paginaciÃ³n en el primer renderizado.
  - [x] AC 4: AÃ±adido efecto secundario reactivo en `NotificacionesHistoricasClient.tsx` que sincroniza los estados del cliente de vuelta con los Query Params de la URL usando `window.history.replaceState` de manera transparente y no bloqueante.
---
### 2026-06-29 14:35 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Ajustes de UI del Dashboard: renombrado de "Vendedores" a "Usuarios" (ranking y modal), inclusiÃ³n de todos los dispositivos del contratante en el desglose del modal (incluso con S/ 0.00 hoy) y adiciÃ³n de filas de sumatorias totales.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/page.tsx), [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Consultados todos los dispositivos activos e inactivos del contratante en `page.tsx` y pasados al cliente mediante la prop `dispositivos`.
  - [x] AC 2: Modificada la inicializaciÃ³n de `byDevice` en `useMemo` de `DashboardClient.tsx` para pre-poblar el listado con todos los dispositivos del contratante con total `S/ 0.00`, asegurando que aparezcan en el modal de rendimiento.
  - [x] AC 3: Renombradas las referencias de "Vendedores" a "Usuarios" en el tÃ­tulo de la tarjeta del dashboard y en el encabezado del modal.
  - [x] AC 4: AÃ±adida fila estacional y fija de **TOTAL GENERAL** al final de la pestaÃ±a **Resumen General** (acumulando el monto y cantidad de cobros de todos los usuarios).
  - [x] AC 5: AÃ±adida fila de **TOTAL GENERAL** al final de la pestaÃ±a **Ventas por Dispositivo** (acumulando los ingresos por dispositivo de todos los terminales).
---
### 2026-06-29 14:40 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Ajustes adicionales de UI en el modal de rendimiento: renombrado de pestaÃ±a a "Ventas por Usuario" e inclusiÃ³n del desglose de cobros "Sin Reclamar" dentro de la pestaÃ±a "Ventas por Dispositivo" para cada caja vinculada.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Renombrada la primera pestaÃ±a del modal de desempeÃ±o de *"Resumen General"* a *"Ventas por Usuario"*.
  - [x] AC 2: Incorporada la acumulaciÃ³n de montos y operaciones de notificaciones en estado `'PENDIENTE'` (`unclaimedTotal` y `unclaimedCount`) por cada dispositivo hoy en `useMemo`.
  - [x] AC 3: AÃ±adido desglose de cobros **"Sin Reclamar"** (en formato itÃ¡lica y color suave) al final del dropdown/acordeÃ³n de cada dispositivo en la pestaÃ±a **Ventas por Dispositivo**, siempre que tenga cobros huÃ©rfanos hoy.
---
### 2026-06-29 14:42 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Ajuste de UI en Dashboard principal: renombrado de la tarjeta de ranking a "Ingresos por usuario".
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Renombrado el tÃ­tulo de la tarjeta de ranking en el Dashboard a **"Ingresos por usuario"** para unificar la nomenclatura con las secciones del modal.
---
### 2026-06-29 14:52 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** RefactorizaciÃ³n de Dashboard y rediseÃ±o de Ingresos por Dispositivo: extracciÃ³n a componente independiente y maquetaciÃ³n en grid responsivo de 1 a 3 columnas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [DeviceIncomeList.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceIncomeList.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: ExtraÃ­do el marcado y la lÃ³gica de "Ingresos por Dispositivo" a un componente reactivo independiente [DeviceIncomeList.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceIncomeList.tsx).
  - [x] AC 2: RediseÃ±ado el listado vertical a un grid responsivo adaptable basado en la cantidad de dispositivos (`grid-cols-1`, `sm:grid-cols-2`, `xl:grid-cols-3` como lÃ­mite).
  - [x] AC 3: Asegurado que los dispositivos sobrantes (4 en adelante) se posicionen en la fila siguiente alineados a la izquierda sin deformarse.
---
### 2026-06-29 14:55 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** ComponentizaciÃ³n y refactorizaciÃ³n masiva de DashboardClient.tsx: extracciÃ³n de modales, cabeceras, tarjetas mÃ©tricas y skeletons a componentes independientes, reduciendo el tamaÃ±o del archivo de 1050+ a ~450 lÃ­neas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx), [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx), [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx), [DeviceDetailsModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceDetailsModal.tsx), [UserPerformanceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/UserPerformanceModal.tsx), [DashboardSkeleton.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardSkeleton.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: ExtraÃ­do el encabezado dinÃ¡mico y controles de rango y exportaciÃ³n a [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx).
  - [x] AC 2: ExtraÃ­do el layout de las tarjetas mÃ©tricas (Plan, Dispositivos y Accesos de Usuarios) a [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx).
  - [x] AC 3: Encapsulado el modal detallado de billeteras y total por caja a [DeviceDetailsModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceDetailsModal.tsx).
  - [x] AC 4: Encapsulado el modal de desempeÃ±o de usuarios (con pestaÃ±as "Ventas por Usuario" y "Usuarios por Dispositivo") a [UserPerformanceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/UserPerformanceModal.tsx).
  - [x] AC 5: Externalizado el maquetado del skeleton animado de carga y la tarjeta auxiliar `StatCard` a [DashboardSkeleton.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardSkeleton.tsx).
  - [x] AC 6: Validada la compilaciÃ³n exitosa de Next.js, logrando separar la lÃ³gica de suscripciones realtime y exportaciÃ³n XLS del maquetado estÃ¡tico de modales.
---
### 2026-06-29 14:58 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de la maquetaciÃ³n en DashboardStatsCards: remociÃ³n del grid de 4 columnas duplicado que provocaba que la tarjeta de licencias colapsara a 1 sola columna.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Removido el wrapper `<div className="grid grid-cols-1 lg:grid-cols-4 ...">` en `DashboardStatsCards.tsx`.
  - [x] AC 2: Asegurado que el componente devuelva directamente `<div className="lg:col-span-3 flex flex-col">` para que se monte fluidamente sobre el grid principal de `DashboardClient.tsx`.
---
### 2026-06-29 15:00 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Ajuste de UI en el botÃ³n de exportaciÃ³n: reemplazo del fondo traslÃºcido (`glass-panel`) del menÃº desplegable de formatos por un fondo sÃ³lido (`bg-white` y `dark:bg-gray-900`) para evitar superposiciones y opacidades conflictivas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Reemplazada la clase `glass-panel` por `bg-white dark:bg-gray-900` y agregadas las directivas de bordes sÃ³lidos en el dropdown del botÃ³n de exportar.
---
### 2026-06-29 15:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de estilos de tema oscuro en modales: reemplazo de la clase inexistente `gray-955` por `gray-950` y ajuste de colores de texto a variables estÃ¡ndar de Tailwind.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DeviceDetailsModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DeviceDetailsModal.tsx), [UserPerformanceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/UserPerformanceModal.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Reemplazada la clase de fondo `dark:bg-gray-955` por la clase estÃ¡ndar `dark:bg-gray-950` en el contenedor de los modales de dispositivo y desempeÃ±o.
  - [x] AC 2: Reemplazada la clase de texto `text-gray-955` por `text-gray-900` para garantizar un contraste correcto en modo claro e invocar `dark:text-white` fluidamente en modo oscuro.
---
### 2026-06-29 15:12 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Ajustes de UI en la vista de detalle de dispositivo: renombrado de botÃ³n de eliminaciÃ³n y diferenciaciÃ³n cromÃ¡tica (anaranjado) para la desvinculaciÃ³n fÃ­sica.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx), [UnlinkDeviceButton.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/UnlinkDeviceButton.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Cambiado el texto del botÃ³n en la tarjeta de datos a **"Eliminar Dispositivo"** (reemplazando "Eliminar Caja / Dispositivo").
  - [x] AC 2: Cambiado el esquema de color del botÃ³n **"Desvincular"** y de su modal de confirmaciÃ³n a un tono anaranjado (`bg-amber-50`, `text-amber-600` e icono `AlertTriangle` en Ã¡mbar) para diferenciarlo de las acciones destructivas rojas.
---
### 2026-06-29 15:28 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Parche de seguridad y optimizaciÃ³n de cuota de red en Supabase Realtime: restricciÃ³n y filtrado en origen de eventos en la tabla `DispositivosXContratante` por `IdContratante`.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/layout.tsx), [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx)
  - **Base de Datos:** Ninguno (se utiliza el filtrado nativo de canal de Supabase en cliente).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Inyectado el parÃ¡metro `userId` desde el Layout Server Component al `DispositivosViewProvider` Client Component.
  - [x] AC 2: Agregado el parÃ¡metro `filter: "IdContratante=eq." + userId` a la suscripciÃ³n Realtime del proveedor. Esto evita que Supabase envÃ­e eventos ajenos por WebSocket, previniendo la visualizaciÃ³n de dispositivos de terceros y ahorrando consumo en la cuota de mensajes.
---
### 2026-06-29 15:32 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Ajuste en SidebarNav para preservar la selecciÃ³n visual del mÃ³dulo activo al navegar en subrutas de detalle (ej: dispositivos/[id]).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Modificada la variable `isExactActive` en `SidebarNav.tsx` para que valide coincidencia exacta (`pathname === link.href`) o coincidencia de prefijo con barra (`pathname.startsWith(link.href + "/")`).
  - [x] AC 2: Garantizado que al acceder a las configuraciones individuales de una caja en `/dashboard/dispositivos/[id]`, el botÃ³n principal *"Dispositivos y Seguridad"* se mantenga resaltado en azul de forma persistente.
---
### 2026-06-29 15:33 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de solapamiento en SidebarNav: exclusiÃ³n de la regla de prefijos para la ruta raÃ­z `/dashboard` para evitar la iluminaciÃ³n permanente de *"Resumen General"*.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: AÃ±adida la restricciÃ³n `link.href !== "/dashboard"` en la validaciÃ³n por prefijo de `isExactActive`.
  - [x] AC 2: Confirmado que al ingresar a otros mÃ³dulos independientes (ej: `/dashboard/dispositivos`), el Ã­tem *"Resumen General"* se apague correctamente.
---
### 2026-06-29 18:45 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de redirecciÃ³n en la tarjeta *"Sin Reclamar"* de DashboardClient para conservar el dÃ­a consultado en el filtro de la bitÃ¡cora de histÃ³ricas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Modificado el enlace del card de cobros huÃ©rfanos para inyectar de forma dinÃ¡mica las propiedades `fechaInicio` y `fechaFin` igual al estado reactivo `${date}` del selector de fechas del Dashboard.
  - [x] AC 2: Asegurado que al redireccionar al usuario a `/dashboard/notificaciones/historicas`, el filtro de rango de fechas se cargue exactamente con el dÃ­a seleccionado previamente en lugar de resetearse a "Hoy".
---
### 2026-06-29 20:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de regresiÃ³n de permisos en base de datos: restituciÃ³n de la clÃ¡usula `SECURITY DEFINER` en triggers de control de lÃ­mites de licencias.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [0017_licencias_por_contratante.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0017_licencias_por_contratante.sql)
  - **Base de Datos:** Ejecutadas directivas `ALTER FUNCTION public.check_device_limit() SECURITY DEFINER` y `ALTER FUNCTION public.check_user_limit() SECURITY DEFINER` en caliente en Supabase.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Asegurado que el trigger `check_device_limit` se ejecute con privilegios de superusuario (`SECURITY DEFINER`) para bypassear las restricciones RLS al ser invocado por el cliente mÃ³vil anÃ³nimo (`anon`).
  - [x] AC 2: Asegurado que el trigger `check_user_limit` cuente con la misma directiva de seguridad para prevenir fallos al aprobar o desaprobar accesos de vendedores desde el mÃ³vil.
---
### 2026-06-29 20:20 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** ImplementaciÃ³n de persistencia para el badge de solicitudes pendientes en el Sidebar y rediseÃ±o premium del indicador en el Dashboard.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/layout.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx), [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx)
  - **Base de Datos:** Ninguno (se aprovechan las polÃ­ticas RLS y consultas optimizadas existentes).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Inicializado el contador de solicitudes en el servidor (`layout.tsx`) de forma paralela y transmitido como prop inicial al `RealtimeProvider`, garantizando que el badge del Sidebar no se resetee a 0 en recargas de pÃ¡gina.
  - [x] AC 2: RediseÃ±ado el badge de pendientes del Dashboard utilizando un color de fondo suave y limitando la animaciÃ³n de latido (`animate-pulse`) Ãºnicamente al cÃ­rculo rojo estÃ©tico del indicador, evitando vibraciones molestas de todo el card.
---
### 2026-06-29 20:55 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de la sincronizaciÃ³n Realtime para solicitudes de acceso pendientes (badge del Sidebar).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/layout.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx), [0025_rls_autorizaciones_web.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0025_rls_autorizaciones_web.sql)
  - **Base de Datos:** Actualizada la polÃ­tica RLS en `AutorizacionesXUsuario`. Se separÃ³ la polÃ­tica global en dos: una restrictiva para escritura (mantiene `EXISTS`) y una simple para lectura (`USING (true)`) para que sea compatible con Supabase Realtime.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Resuelto el bloqueo de transmisiÃ³n en Supabase Realtime eliminando la subconsulta `EXISTS` en la regla de lectura RLS de `AutorizacionesXUsuario`.
  - [x] AC 2: Implementada la suscripciÃ³n del lado del cliente en `RealtimeProvider.tsx` de forma individualizada para cada `IdDispositivo` mediante `filter: IdDispositivo=eq.UUID`. Esto aÃ­sla a nivel de red la recepciÃ³n de datos y previene el consumo innecesario de mensajes de otros contratantes.
---
### 2026-06-30 20:57 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** RediseÃ±o, extensiÃ³n e interactividad de la Landing Page principal de la web, aislando precios, aÃ±adiendo descargas directas de APKs con temporizadores de protecciÃ³n y aplicando transiciones de entrada animadas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/page.tsx), [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx), [PricingCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/PricingCards.tsx), [globals.css](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/globals.css)
  - **Base de Datos:** Ninguno (la distribuciÃ³n de APKs y el reajuste del grid de precios son exclusivamente visuales y estructurales).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Aislados los precios en la pestaÃ±a secundaria **Licencias** y renombrado los encabezados para omitir menciÃ³n obligatoria de compra durante las pruebas de la Google Play Store.
  - [x] AC 2: Reestructurada la cuadrÃ­cula de planes a un grid de 3 columnas centrado y balanceado para adaptarla a los 3 planes vigentes en lugar de 4.
  - [x] AC 3: Implementados botones de descarga directa apuntando al bucket pÃºblico `app_releases` de Supabase Storage, integrando una protecciÃ³n por cÃ³digo de 5 segundos contra descargas repetidas (clics sucesivos).
  - [x] AC 4: AÃ±adido el paso 3 (desactivaciÃ³n temporal de Play Protect) en la guÃ­a rÃ¡pida de instalaciÃ³n de APKs.
  - [x] AC 5: Programadas animaciones dinÃ¡micas nativas en CSS (fadeInUp, slideInLeft, slideInRight) para evitar un diseÃ±o estÃ¡tico al navegar y cargar pestaÃ±as.
---
### 2026-07-02 20:20 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** IntegraciÃ³n frontend del flujo de pago Checkout Pro de Mercado Pago en la tarjeta de precios para habilitar compras automatizadas de licencias.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PricingCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/PricingCards.tsx), [.env.local](file:///c:/Trabajo/Proyectos/NotificaPe/web/.env.local)
  - **Base de Datos:** Ninguno (la lÃ³gica transaccional de crÃ©ditos ya estÃ¡ escrita en el backend y es gatillada por el webhook).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: AÃ±adido chequeo de autenticaciÃ³n. Los usuarios no logueados son redirigidos de forma automÃ¡tica a la pantalla de `/login` al hacer clic en "Elegir Plan".
  - [x] AC 2: Implementado consumo a la Edge Function `mercadopago_preferencia` en Supabase enviando los metadatos requeridos (monto, moneda, licencia, idempotencia, contratante y email).
  - [x] AC 3: Configurada la redirecciÃ³n dinÃ¡mica hacia las URLs de Checkout Pro (Sandbox o ProducciÃ³n) segÃºn la variable global `NEXT_PUBLIC_MERCADOPAGO_ENV`.
  - [x] AC 4: Creado el estado de carga `buyingPlanId` para desactivar el formulario e ilustrar el spinner "Procesando..." durante la llamada a la API.
---
### 2026-07-04 22:20 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** IntegraciÃ³n y validaciÃ³n del flujo de compras en Sandbox de Mercado Pago y mejoras de UX en el gestor de licencias.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [actions.ts (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts), [page.tsx (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx), [BotonCancelarCola.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/BotonCancelarCola.tsx), [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx), [mercadopago_preferencia/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_preferencia/index.ts), [mercadopago_webhook/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_webhook/index.ts)
  - **Base de Datos / Edge Functions:**
    * Modificada la Edge Function `mercadopago_preferencia` para incluir la cantidad seleccionada en la metadata, inyectar el token en la query URL de notificaciÃ³n y forzar HTTPS en los retornos.
    * Modificada la Edge Function `mercadopago_webhook` para invocar a la funciÃ³n SQL de compra de licencias mÃºltiples y soportar el token de seguridad. Se desactivÃ³ la verificaciÃ³n JWT heredada de Supabase para admitir webhooks externos.
  - **Frontend UI:**
    * Creado el componente cliente `BotonCancelarCola` con modal interactivo de confirmaciÃ³n y efecto blur.
    * Simplificado el resumen de compra en el Wizard (OpciÃ³n A) mostrando Subtotal, Descuento y Total de forma directa, y un desglose de saldo bajo un acordeÃ³n interactivo.
    * Corregido bug de reactividad al multiplicar meses/aÃ±os mapeando a ambos campos del crÃ©dito (`credito_aplicable_en_unidad_minima` y `credito_aplicado_en_unidad_minima`).
    * Corregido el botÃ³n del header "AtrÃ¡s" para que retroceda al paso 1 en lugar de salir del Wizard al estar en el paso 2.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Flujo completo de cobro y registro de licencias simples y mÃºltiples validado en Sandbox.
  - [x] AC 2: PrevenciÃ³n de clicks accidentales en cancelaciÃ³n mediante modal de confirmaciÃ³n en cliente.
  - [x] AC 3: VisualizaciÃ³n financiera de Checkout limpia y resumida para evitar confusiÃ³n de nÃºmeros.
  - [x] AC 4: NavegaciÃ³n de regreso no disruptiva en el Wizard de licencias.
---
### 2026-07-07 14:15 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** ImplementaciÃ³n de resiliencia y monitoreo pasivo en tiempo real (Hito 1) y separaciÃ³n del estado de bloqueo ("Inactivo") frente a desvinculaciÃ³n fÃ­sica.
* **Detalles TÃ©cnicos:**
  - **Archivos Creados:** [RealtimeHealthMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/realtime/RealtimeHealthMonitor.kt), [RealtimeIntegrityManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/realtime/RealtimeIntegrityManager.kt), [BlockedScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/BlockedScreen.kt)
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [SyncRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/SyncRealtimeHandler.kt), [AppNavigation.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/navigation/AppNavigation.kt), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **LÃ³gica de Conectividad (Hito 1):**
    * Portada la monitorizaciÃ³n de salud pasiva en segundo plano con intervalos rÃ¡pidos de 10s (timeout 15s / zombie 5m).
    * Implementada la curva de reintentos mediante backoff exponencial (1s a 60s) en lugar de loops repetitivos.
    * Ampliado el scavenger de recuperaciÃ³n delta a 5 minutos (300 segundos).
  - **LÃ³gica de Bloqueo (Estado Inactivo):**
    * Creado el estado `DeviceStatus.Blocked` en el repositorio para evitar eliminar datos locales (notificaciones/Room) cuando la caja solo es marcada como inactiva administrativamente.
    * Al detectar `Activo = false`, se cierra la conexiÃ³n realtime del terminal para no retener canales socket abiertos inÃºtilmente.
    * Redireccionado automÃ¡tico del usuario a la vista `BlockedScreen`, la cual muestra un diseÃ±o elegante y desactiva las conexiones.
    * AÃ±adido botÃ³n "Verificar Estado" en la pantalla de bloqueo para consultar si el administrador reactivÃ³ la caja, implementando un cooldown timer de 10 segundos para prevenir abuso de peticiones (spam clicks).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Watchdogs rÃ¡pidos y Backoff Exponencial integrados quirÃºrgicamente.
  - [x] AC 2: Evitada la pÃ©rdida de base de datos local Room en deactivaciÃ³n (mantenimiento de vinculaciÃ³n lÃ³gica).
  - [x] AC 3: DesconexiÃ³n total del socket en estado bloqueado.
  - [x] AC 4: NavegaciÃ³n controlada bidireccionalmente e interfaz de bloqueo con cooldown en botÃ³n de refresco.
---
### 2026-07-07 21:46 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de la resoluciÃ³n de la pasarela de Mercado Pago en producciÃ³n (EasyPanel y Supabase) haciendo dinÃ¡mico el enrutamiento de la URL de checkout.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PricingCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/PricingCards.tsx), [actions.ts (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts), [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx), [mercadopago_preferencia/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_preferencia/index.ts), [Dockerfile](file:///c:/Trabajo/Proyectos/NotificaPe/web/Dockerfile)
  - **Base de Datos / Edge Functions:**
    * Actualizada la Edge Function `mercadopago_preferencia` para retornar un campo dinÃ¡mico `checkout_url` calculando a nivel de servidor (segÃºn `MERCADOPAGO_ENV`) si se debe usar la URL de producciÃ³n (`init_point`) o sandbox (`sandbox_init_point`).
  - **Frontend UI:**
    * Modificada la redirecciÃ³n en `WizardGestionarLicencias` y `PricingCards` para preferir el campo dinÃ¡mico `checkout_url` devuelto por el servidor, independientemente de la variable de entorno `NEXT_PUBLIC_MERCADOPAGO_ENV` compilada estÃ¡ticamente en el frontend.
    * Agregados los argumentos de compilaciÃ³n `NEXT_PUBLIC_MERCADOPAGO_ENV` y `NEXT_PUBLIC_APP_URL` en el `Dockerfile` para soportar variables de entorno en compilaciones de producciÃ³n de EasyPanel si fueran necesarias.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Resuelto el problema de redirecciÃ³n a Sandbox al delegar la decisiÃ³n de enrutamiento al backend.
  - [x] AC 2: ReducciÃ³n de discrepancias entre entornos al centralizar la configuraciÃ³n de variables en Supabase Secrets.
  - [x] AC 3: Dockerfile actualizado con compatibilidad para build args de entorno.
---
### 2026-07-07 22:30 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** SincronizaciÃ³n del Foreground Service de escucha de notificaciones con el estado de activaciÃ³n en tiempo real de la caja (Hito 2).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **LÃ³gica de SincronizaciÃ³n del Servicio (Hito 2):**
    * Modificado el mÃ©todo `onNotificationPosted` del servicio para validar que el estado del dispositivo sea estrictamente `Linked`. Si el terminal estÃ¡ bloqueado/inactivo, se aborta la captura y sincronizaciÃ³n de forma inmediata en segundo plano.
    * Agregada la recolecciÃ³n activa del flujo `deviceStatus` dentro de `onStartCommand` en el servicio para mutar la notificaciÃ³n persistente: cambia a "Monitoreo Pausado | Caja desactivada por el administrador" en estado bloqueado, y a "Monitoreo Activo" al restablecerse.
    * Protegido el mÃ©todo `runScavenger` del servicio de escucha de notificaciones para abortar la barredora de transacciones si la caja se encuentra inhabilitada.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: VisualizaciÃ³n e indicaciÃ³n reactiva del estado del servicio en la barra de notificaciones del sistema de Android.
  - [x] AC 2: PrevenciÃ³n de capturas y subidas accidentales de notificaciones privadas estando la caja inactiva.
  - [x] AC 3: Barredora (Scavenger) de transacciones pausada en estado inactivo.
---
### 2026-07-10 10:04 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** EstabilizaciÃ³n y resiliencia de la conexiÃ³n Realtime en segundo plano mediante OkHttp pingInterval, Connecting Timeout Watchdog y Android NetworkMonitor.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [SupabaseModule.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/di/SupabaseModule.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **Mecanismos de Resiliencia:**
    * Configurado `pingInterval` de 45 segundos en OkHttp para evitar que operadoras mÃ³viles corten el canal WebSocket de manera silenciosa.
    * Implementado `connectingTimeoutJob` de 30 segundos en `AuthRepository` para realizar un hard reset automÃ¡tico si el socket queda atrapado en el estado de transiciÃ³n `CONNECTING`.
    * Integrada la escucha pasiva del `NetworkMonitor` nativo de Android en `AuthRepository` para reaccionar al instante cuando la conectividad fÃ­sica de datos o Wi-Fi se recupera.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: DetecciÃ³n y reconexiÃ³n inmediata del socket al recuperar seÃ±al.
  - [x] AC 2: PrevenciÃ³n de limbos infinitos en estado CONNECTING mediante watchdog de 30s.
  - [x] AC 3: Mantenimiento del canal activo a nivel de operadoras usando pingInterval de 45s.
---
### 2026-07-10 10:30 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** CorrecciÃ³n de la cascada de estados en RealtimeMonitorManager y estabilizaciÃ³n del disparador de red con debounce. RemociÃ³n de pingInterval para evitar timeouts de CDNs.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeMonitorManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/manager/RealtimeMonitorManager.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [SupabaseModule.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/di/SupabaseModule.kt)
  - **CorrecciÃ³n de Bugs de Conectividad:**
    * Modificada la lÃ³gica de cascada en `RealtimeMonitorManager` para evaluar `status !is TableStatus.Subscribed` en el socket, asegurando que todos los canales se visualicen como desconectados si el socket no estÃ¡ activo.
    * AÃ±adido `.debounce(1500)` al flujo de conectividad fÃ­sica en `AuthRepository` para evitar que rebotes de seÃ±al (antena celular / Wi-Fi) disparen mÃºltiples resets de socket concurrentes o sucesivos.
    * Revertido `pingInterval` en `SupabaseModule` a la configuraciÃ³n por defecto para depender exclusivamente del heartbeat a nivel de aplicaciÃ³n (Phoenix text protocol), resolviendo desconexiones artificiales causadas por CDNs (como Cloudflare) que bloquean pings de control de bajo nivel.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Coherencia visual total entre el banner de conexiÃ³n base y los canales individuales.
  - [x] AC 2: Evitada la reconexiÃ³n mÃºltiple iterativa (botes de red) al salir del modo aviÃ³n.
  - [x] AC 3: ConexiÃ³n WebSocket estable sin desconexiones artificiales tras un minuto.
---
### 2026-07-10 10:50 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** SoluciÃ³n al limbo de vinculaciÃ³n sin red, feedback dinÃ¡mico en la notificaciÃ³n del Foreground Service y fin al bucle de Joining timeout (parpadeo en diagnÃ³stico).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [RealtimeMonitorManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/manager/RealtimeMonitorManager.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **EstabilizaciÃ³n de Segundo Plano y UI:**
    * Modificado `initializeDevice` para no expulsar al usuario si la peticiÃ³n falla por falta de internet; se restaura de forma local y offline el estado `DeviceStatus.Linked(localDevice)` basÃ¡ndose en las credenciales persistidas en `UserPreferences`.
    * Ajustada la inicializaciÃ³n de `lastActivity` en `RealtimeMonitorManager` para actualizarse ante estados `Joining` y `Subscribed`. Esto previene que el monitor de salud (`RealtimeHealthMonitor`) calcule timeouts obsoletos al reintentar la suscripciÃ³n, rompiendo el bucle infinito de resets de canal (parpadeo).
    * Inyectado `RealtimeMonitorManager` en `NotificationReceiverService` para recolectar el flujo de estados del socket y reflejar en la barra de notificaciones del celular el estado dinÃ¡mico actual ("En LÃ­nea", "Conectando...", "Sin conexiÃ³n / Reconectando...").
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: NavegaciÃ³n preservada (modo offline) al iniciar la app sin conexiÃ³n de internet.
  - [x] AC 2: NotificaciÃ³n persistente del sistema con feedback dinÃ¡mico del estado de conexiÃ³n realtime.
  - [x] AC 3: Canales estables al reconectarse sin bucles iterativos de resincronizaciÃ³n.
---
### 2026-07-10 11:15 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** SoluciÃ³n a desincronizaciÃ³n de estado de socket en UI, estabilizaciÃ³n de NetworkMonitor (eliminaciÃ³n de race conditions en capabilities) e implementaciÃ³n de timestamp de actividad en notificaciÃ³n.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/NetworkMonitor.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **SincronizaciÃ³n de UI y DiagnÃ³stico:**
    * Modificado `NetworkMonitor` para remover la escucha en `onCapabilitiesChanged`, previniendo que los retrasos en la validaciÃ³n de red del sistema de Android emitan falsos negativos y dejen el banner "Sin conexiÃ³n a Internet" congelado en la UI.
    * Corregida desincronizaciÃ³n en `AuthRepository`: al recuperar internet fÃ­sico, si el socket de la SDK ya se encuentra conectado (`CONNECTED`), se fuerza de inmediato la actualizaciÃ³n de la UI a `TableStatus.Subscribed` y se enciende el `healthMonitor`.
    * Modificado `NotificationReceiverService` para observar `lastGlobalActivity` y aÃ±adir el timestamp formateado (HH:mm:ss) de la Ãºltima acciÃ³n recibida en la notificaciÃ³n persistente del Foreground Service (ej: `"Estado: En LÃ­nea | Actividad: 11:15:23"`).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Banner "Sin conexiÃ³n a Internet" desaparece de forma consistente al recuperar internet.
  - [x] AC 2: TelemetrÃ­a de socket en la UI alineada 100% con la conectividad real del canal de datos.
  - [x] AC 3: NotificaciÃ³n de segundo plano con timestamp dinÃ¡mico de Ãºltima actividad en tiempo real.
---
### 2026-07-10 11:55 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** CorrecciÃ³n en el NetworkMonitor global para evitar falsos negativos en la transiciÃ³n multirred (Wi-Fi <-> Datos MÃ³viles).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/NetworkMonitor.kt)
  - **DetecciÃ³n de Red FÃ­sica Global:**
    * Modificada la callback `ConnectivityManager.NetworkCallback` para evaluar siempre `connectivityManager.activeNetwork` de manera global en los eventos `onAvailable`, `onLost` y `onCapabilitiesChanged`. Esto previene falsos negativos de internet que congelan el banner de "Sin conexiÃ³n" cuando un adaptador de red secundario se apaga (ej: datos mÃ³viles desactivÃ¡ndose al entrar Wi-Fi).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Estabilidad total en transiciones rÃ¡pidas de red Wi-Fi y Datos MÃ³viles.
  - [x] AC 2: Banner de sin conexiÃ³n y telemetrÃ­a de socket coherentes y sincronizados.
---
### 2026-07-10 12:20 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** Aislamiento absoluto del estado Bloqueado (prevenciÃ³n de fugas de datos), persistencia local de estado de activaciÃ³n y botÃ³n de desvinculaciÃ³n en BlockedScreen.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [BlockedScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/BlockedScreen.kt)
  - **Aislamiento y UX de Bloqueo:**
    * AÃ±adido `IS_DEVICE_ACTIVE` en `UserPreferences` para guardar localmente si la caja estÃ¡ activa o bloqueada. En inicio offline (`initializeDevice`), si el Ãºltimo estado conocido fue bloqueado, se mantiene el bloqueo local previniendo el bypass del dashboard offline.
    * Incorporadas guardas estrictas en `connectRealtime()`, `hardResetSocket()`, `triggerSmartReconnect()` y en el receptor de estado `DISCONNECTED`. Si la caja estÃ¡ bloqueada, cualquier intento de levantar/conectar el socket o reintentar es abortado inmediatamente, deteniendo cualquier flujo de billeteras o reglas.
    * Modificada la funciÃ³n `unbindDevice()` para tolerar caÃ­das de red fÃ­sicas y forzar siempre `localCleanup()`, permitiendo que el usuario libere la app a nivel local si estÃ¡ offline.
    * Implementado el botÃ³n "DESVINCULAR EQUIPO" con diÃ¡logo de confirmaciÃ³n en la vista de bloqueo `BlockedScreen.kt` para facilitar la desvinculaciÃ³n directa.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Dispositivo bloqueado mantiene el bloqueo offline al iniciar la app sin conexiÃ³n.
  - [x] AC 2: Cero reconexiones o fugas de datos de billeteras/reglas cuando el estado es Blocked.
  - [x] AC 3: BotÃ³n de desvinculaciÃ³n completamente funcional (online y offline) en BlockedScreen.
---
### 2026-07-10 12:35 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** MigraciÃ³n a `registerDefaultNetworkCallback` nativo para resolver reinicios de socket espurios causados por handovers e interfaces secundarias.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/NetworkMonitor.kt)
  - **DetecciÃ³n de Red por DefaultCallback:**
    * Modificado `NetworkMonitor` para registrar la callback de red mediante `registerDefaultNetworkCallback` (API 24+). Esto restringe las notificaciones de red exclusivamente a la interfaz default por la que el sistema operativo Android enruta el trÃ¡fico principal.
    * Eliminada la escucha de fluctuaciones de seÃ±al (`onCapabilitiesChanged`) y caÃ­das de interfaces secundarias (ej: corte de Mobile Data en segundo plano al entrar a Wi-Fi), erradicando micro-caÃ­das y reconexiones iterativas innecesarias del socket.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Estabilidad continua del socket y los canales en reposo (sin micro-resets).
  - [x] AC 2: Conectividad fÃ­sica reportada a la UI estable y libre de ruidos por fluctuaciÃ³n de seÃ±al.
---
### 2026-07-10 12:45 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** ParalelizaciÃ³n de tareas de foreground en `onStart` para eliminar latencia y asegurar conectividad inmediata al regresar de background.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **ParalelizaciÃ³n de Ciclo de Vida Foreground:**
    * Modificada la callback `onStart` del `DefaultLifecycleObserver` para lanzar de manera paralela y no bloqueante las tres tareas de retorno: `connectRealtime()` + `observeLinkingStatus()`, `refreshDeviceStatus()` (consulta REST) y el `Delta Sync` de base de datos.
    * Esto elimina el retardo de 2-3 segundos (latencia de red) que causaba que la UI quedara en un estado intermedio inactivo o desincronizado al regresar de aplicaciones externas (ej: WhatsApp).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: ReconexiÃ³n del socket y canales instantÃ¡nea (milisegundos) al volver a foreground.
  - [x] AC 2: ValidaciÃ³n de bloqueo REST y sincronizaciÃ³n delta ejecutadas concurrentemente en segundo plano sin bloquear la UI.
---
### 2026-07-10 13:00 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** CorrecciÃ³n en el enrutamiento de desvinculaciÃ³n (BlockedScreen), alineaciÃ³n estÃ©tica al MaterialTheme de fondos oscuros y diagnÃ³stico de red dinÃ¡mico en el estado del dispositivo.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [BlockedScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/BlockedScreen.kt)
  - **CorrecciÃ³n de Enrutamiento y DiagnÃ³stico:**
    * Actualizado `unbindDevice()` y `deleteDevicePermanently()` en `AuthRepository.kt` para forzar la mutaciÃ³n de `_deviceStatus.value` a `DeviceStatus.Unlinked`, lo que activa la guardia de navegaciÃ³n de `MainActivityContent` para redirigir a `intro` tras desvincular.
    * Cambiado el retorno de `refreshDeviceStatus()` a `Result<Boolean>` para propagar excepciones de conectividad en lugar de silenciarlas con un retorno `false` genÃ©rico.
    * RediseÃ±ada la vista `BlockedScreen.kt` sustituyendo los gradientes y contenedores morados codificados por los colores nativos de `MaterialTheme.colorScheme` (grises y negros modernos de la app).
    * Actualizado el botÃ³n "Verificar Estado" para mostrar Toasts dinÃ¡micos que diferencien entre inactividad fÃ­sica en el Panel Web (`Result.success(false)`) y fallas de red/conexiÃ³n con Supabase (`Result.failure`).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: RedirecciÃ³n inmediata a Onboarding al presionar "Desvincular Equipo" en BlockedScreen.
  - [x] AC 2: Aspecto visual de la pantalla de bloqueo armÃ³nico con los colores oscuros de la app.
  - [x] AC 3: El botÃ³n "Verificar Estado" discrimina fallas de red de la inactividad real para una mejor UX.
---
### 2026-07-10 13:10 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** ImplementaciÃ³n de amortiguaciÃ³n de estado de conexiÃ³n (dampenStatus) en la UI y notificaciones para filtrar oscilaciones visuales transitorias.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeMonitorManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/manager/RealtimeMonitorManager.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **AmortiguaciÃ³n de Estados de Red (Dampening):**
    * Creado el operador personalizado `Flow<TableStatus>.dampenStatus(delayMs = 4000L)`. Este operador implementa un retardo asimÃ©trico de 4 segundos antes de propagar estados caÃ­dos (`Disconnected`/`Zombie`/`Connecting`) si venÃ­amos de estar conectados (`Subscribed`), cancelando y silenciando el cambio visual si el socket se recupera dentro de ese umbral. Las transiciones exitosas a `Subscribed` se emiten de forma instantÃ¡nea.
    * Aplicado el operador `dampenStatus()` al flujo `globalRealtimeStatus` en `DashboardViewModel.kt`, eliminando el parpadeo del banner del Dashboard durante hangups de red o transiciones mÃ³viles normales.
    * Aplicado el operador `dampenStatus()` al flujo del estado de la notificaciÃ³n persistente en `NotificationReceiverService.kt`, estabilizando el feedback del Foreground Service en background.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La UI y las notificaciones no parpadean ni muestran alertas rojas durante micro-cortes menores a 4 segundos.
  - [x] AC 2: Las desconexiones reales y permanentes (ej: Modo AviÃ³n) se reportan a la UI de forma precisa tras el umbral de 4 segundos.
  - [x] AC 3: La reconexiÃ³n exitosa del socket se muestra en verde de forma inmediata en la UI.
---
### 2026-07-10 13:25 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** SoluciÃ³n al desfase de reloj (clock-drift) en sincronizaciÃ³n diferencial y prevenciÃ³n de marcas temporales futuras en el laboratorio de pruebas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [SyncRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/SyncRepository.kt), [TestLabHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **SoluciÃ³n a Reloj Futuro e Integridad de Sync:**
    * Modificada la consulta de sincronizaciÃ³n en `performFullSync()` para fijar el lÃ­mite superior `endTimeIso` al final del dÃ­a actual (23:59:59.999 UTC) en lugar del dinÃ¡mico `Instant.now()`. Esto elimina el bug de producciÃ³n donde dispositivos con relojes retrasados ignoran notificaciones reciÃ©n insertadas en la nube.
    * Corregido el laboratorio de pruebas en `TestLabHandler.kt` para restar el `uniqueOffset` en lugar de sumarlo. Esto asegura que la dispersiÃ³n aleatoria de marcas temporales (necesaria para la unicidad determinista del MD5 de la notificaciÃ³n) se realice siempre hacia el pasado, eliminando la creaciÃ³n accidental de registros con fechas futuras en la base de datos de Supabase.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Dispositivos con relojes ligeramente retrasados descargan la totalidad de notificaciones del dÃ­a durante el delta sync inicial.
  - [x] AC 2: La generaciÃ³n de rÃ¡fagas en el laboratorio crea notificaciones en el pasado del dÃ­a seleccionado, sin generar fechas futuras.
  - [x] AC 3: SincronizaciÃ³n Ã­ntegra tras la re-vinculaciÃ³n de un dispositivo a su caja original.
---
### 2026-07-10 13:40 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** OptimizaciÃ³n de la experiencia de usuario (UX) al desvincular el dispositivo desde la vista BlockedScreen.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [BlockedScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/BlockedScreen.kt)
  - **OptimizaciÃ³n de UX en DiÃ¡logo de DesvinculaciÃ³n:**
    * Eliminada la variable de estado local redundante `isUnlinking` y sustituida por el colector del flujo global `authRepository.isUnlinking` (`isUnlinkingGlobal`).
    * Configurado el cierre inmediato del `AlertDialog` de confirmaciÃ³n (`showUnlinkDialog = false`) al hacer clic en "Confirmar". Esto erradica la duplicidad visual de spinners al evitar que se dibuje el loader del botÃ³n sobre el `UnlinkingOverlay` global de `MainActivityContent`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: El diÃ¡logo de confirmaciÃ³n se oculta instantÃ¡neamente al presionar "Confirmar".
  - [x] AC 2: Se visualiza Ãºnicamente el overlay global `UnlinkingOverlay` durante la desvinculaciÃ³n asÃ­ncrona, eliminando ruidos y redundancia de interfaces.
---
### 2026-07-10 13:50 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** ImplementaciÃ³n de sincronizaciÃ³n inicial y visualizaciÃ³n de skeletons al abrir el Dashboard por primera vez o tras vincularse.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt)
  - **SincronizaciÃ³n de Carga Inicial con Skeletons:**
    * Modificado el bloque `init` del `DashboardViewModel.kt` para lanzar una corrutina paralela que configure `walletActionHandler.setSyncing(-1)` (activando `isSyncing = true`) y ejecute la sincronizaciÃ³n REST HTTP inicial mediante `syncPendingNotifications()` y `syncFromCloud()`.
    * Esto soluciona la ausencia de skeletons visuales (y la consiguiente apariciÃ³n abrupta de registros) durante la primera carga tras la vinculaciÃ³n, ya que anteriormente la sincronizaciÃ³n delta inicial corrÃ­a silenciosamente en segundo plano a nivel de repositorio sin notificar al ViewModel.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: VisualizaciÃ³n de skeletons animados al iniciar la app o tras vincularse mientras se descargan las notificaciones de hoy.
  - [x] AC 2: La carga finaliza y reemplaza ordenadamente los skeletons por la lista de movimientos o el mensaje de historial vacÃ­o sin saltos bruscos.
---
### 2026-07-10 15:00 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** SoluciÃ³n al bucle de reconexiÃ³n infinita mediante el desacoplamiento de observadores y robustecimiento de guardas en las suscripciones a canales.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **ResoluciÃ³n de Conflictos en la MÃ¡quina de Estados de ConexiÃ³n:**
    * RediseÃ±ada la funciÃ³n `setupDeviceIdObserver()` para observar Ãºnicamente los cambios en `deviceId`. Se eliminÃ³ la observaciÃ³n a `realtime.status` en este colector, delegando la reconexiÃ³n exclusivamente a `setupStatusMonitoring()` para erradicar las llamadas concurrentes a `realtime.connect()`.
    * Modificada la callback de socket `CONNECTED` en `setupStatusMonitoring()` para cancelar cualquier corrutina de reconexiÃ³n en espera (`reconnectJob?.cancel()`) e iniciar de forma inmediata la suscripciÃ³n a canales (`observeLinkingStatus()`).
    * Robustecidas las guardas en `ensureDeviceSubscription()`, `ensureNotificationsSubscription()`, `ensureRulesSubscription()` y `ensureWalletsSubscription()`. Ahora las tareas de suscripciÃ³n retornan de inmediato sin modificar ni reiniciar los flujos Ktor si la corrutina recolectora estÃ¡ activa, a menos que el socket estÃ© conectado y el canal especÃ­fico se encuentre en estado `Zombie` o `Disconnected` (evitando colisionar con el mecanismo interno de auto-reconexiÃ³n de la librerÃ­a Supabase-kt).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La reconexiÃ³n ante caÃ­das de seÃ±al es gestionada en un Ãºnico hilo con backoff incremental, sin generar bucles de conexiÃ³n infinitos.
  - [x] AC 2: La librerÃ­a Supabase-kt recupera automÃ¡ticamente los canales al reanudarse el socket gracias al cese de reinicios asÃ­ncronos concurrentes.
---
### 2026-07-11 00:20 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** SoluciÃ³n de robustecimiento contra congelamientos de red de fondo y loops infinitos en modo Release.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/NetworkMonitor.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt)
  - **Robustecimiento del Monitor de Red y AutocuraciÃ³n:**
    * Implementado un *ticker* de re-verificaciÃ³n activa cada 60s en `NetworkMonitor` y la funciÃ³n rÃ¡pida `isInternetOk()` para evitar el congelamiento de callbacks de conectividad en segundo plano (Doze Mode).
    * Removido el `throw e` en `connectRealtime()` de `AuthRepository.kt` y agregados bloques `try-catch` defensivos en `setupStatusMonitoring()` and `setupDeviceIdObserver()` para evitar la muerte permanente de las corrutinas colectoras de red.
    * Implementado el watchdog local `setupProcessWatchdog()` para forzar un reinicio del proceso si el socket estÃ¡ desconectado con internet real activo por mÃ¡s de 5 minutos, reparando deadlocks en el pool de OkHttp/Ktor.
    * Desacoplado el indicador visual de conexiÃ³n y el banner de offline de la UI de forma que no marquen "Sin conexiÃ³n" si el socket estÃ¡ verificado en `Subscribed`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La reconexiÃ³n se recupera de manera automÃ¡tica tras periodos prolongados en Doze Mode (reposo profundo).
  - [x] AC 2: Las corrutinas colectoras sobreviven a excepciones transitorias del WebSocket sin morir en memoria.
  - [x] AC 3: El watchdog autolimpia el proceso de fondo si el socket queda atascado con internet presente, reiniciando la app limpiamente.
---
### 2026-07-12 14:02 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Arquitecto)

* **DescripciÃ³n:** EstabilizaciÃ³n definitiva de reconexiÃ³n, remociÃ³n de watchdog destructivo y delta sync REST en reconexiÃ³n.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/AuthRealtimeHandler.kt), [SyncRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/SyncRealtimeHandler.kt), [RuleRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/RuleRepository.kt), [WalletRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt), [RealtimeHealthMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/realtime/RealtimeHealthMonitor.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
  - **Detalles de Resiliencia:**
    * Removida la lÃ³gica destructiva de `killProcess` y el temporizador `continuousDisconnectStart` en `AuthRepository.kt`, garantizando reintentos infinitos con backoff exponencial.
    * Incorporado Delta Sync REST diferencial automÃ¡tico (`syncRules()`, `syncWalletsFromCloud()`, `syncPendingNotifications()`) al conectarse el socket para evitar desincronizaciones del negocio.
    * Eliminados watchdogs por silencio de transacciones y silencio global de `RealtimeHealthMonitor.kt`, previniendo reconexiones artificiales cÃ­clicas cada 5 minutos.
    * Corregidas fugas de memoria (leaks) de suscripciones duplicadas lanzando `realtime.removeChannel(channel)` de forma asÃ­ncrona suspendida en el `awaitClose` de cada flow de Realtime.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La inactividad o silencio comercial prolongado no degrada la conexiÃ³n ni fuerza reconexiones artificiales.
  - [x] AC 2: Se limpia el canal de Phoenix al cerrarse/recrearse las suscripciones para evitar fugas de memoria.
  - [x] AC 3: Se sincronizan los datos de billeteras y reglas diferencialmente de manera automÃ¡tica mediante REST tras recuperar conectividad.
------
### 2026-07-13 16:45 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** ImplementaciÃ³n de variables de entorno para las URLs de Google Play Store en el Landing Page y adiciÃ³n de menÃº desplegable unificado para descarga de APK directo.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx), [.env.local](file:///c:/Trabajo/Proyectos/NotificaPe/web/.env.local), [Dockerfile](file:///c:/Trabajo/Proyectos/NotificaPe/web/Dockerfile)
  - **Cambios Realizados:**
    * Vinculados los botones de redirecciÃ³n a Google Play Store a las variables de entorno `NEXT_PUBLIC_PLAY_STORE_ADMIN_URL` y `NEXT_PUBLIC_PLAY_STORE_VIEWER_URL` para permitir cambios dinÃ¡micos sin modificar cÃ³digo.
    * Habilitados los enlaces con la leyenda "Play Store (Pruebas Internas)".
    * Ocultados los botones de descarga de APK directo tras un botÃ³n interactivo de texto secundario ("Ver mÃ¡s formas de descargar") mediante el estado reactivo unificado `showApkDownloads`, permitiendo que la interacciÃ³n en cualquiera de las tarjetas despliegue o colapse las descargas directas en ambas aplicaciones de forma simultÃ¡nea.
    * Corregido el `Dockerfile` declarando `ARG` y `ENV` para `NEXT_PUBLIC_PLAY_STORE_ADMIN_URL` y `NEXT_PUBLIC_PLAY_STORE_VIEWER_URL` para asegurar que Next.js las inyecte de manera estÃ¡tica en el cliente durante el build-time de Docker en producciÃ³n (EasyPanel).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: El botÃ³n principal de Play Store abre en una pestaÃ±a nueva la URL de pruebas internas especificada en las variables de entorno.
  - [x] AC 2: La descarga directa de APK se encuentra oculta inicialmente. Al hacer clic en "Ver mÃ¡s formas de descargar" en cualquier tarjeta se revela el botÃ³n secundario en ambas de forma sincronizada.
  - [x] AC 3: CompilaciÃ³n y validaciÃ³n de tipado TypeScript exitosas en local (`npx tsc --noEmit`).
  - [x] AC 4: Modificado el Dockerfile para exponer los argumentos de compilaciÃ³n y permitir la inyecciÃ³n de las variables en producciÃ³n (EasyPanel).
---

---
### 2026-07-13 17:00 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** ImplementaciÃ³n de autoarranque resiliente en reinicios (Boot Receiver) para el Foreground Service.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/AndroidManifest.xml), [BootReceiver.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/BootReceiver.kt)
  - **Base de Datos:** Ninguno.
  - **Detalles de ImplementaciÃ³n:**
    * Declarado el permiso `RECEIVE_BOOT_COMPLETED` y registrado `.service.BootReceiver` en el manifiesto.
    * Implementado `BootReceiver` para capturar `BOOT_COMPLETED` y `QUICKBOOT_POWERON`.
    * La clase consulta de forma bloqueante rÃ¡pida el `deviceId` persistente en las preferencias. Si estÃ¡ vinculado, levanta `NotificationReceiverService` usando `startForegroundService()` de Android. Si no estÃ¡ vinculado, no inicia el servicio para evitar procesos innecesarios.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: El permiso de arranque y el receptor estÃ¡n debidamente configurados en el manifest de la aplicaciÃ³n.
  - [x] AC 2: La clase `BootReceiver` ejecuta la consulta de vinculaciÃ³n de forma sÃ­ncrona en el boot del telÃ©fono antes de arrancar.
  - [x] AC 3: CompilaciÃ³n Gradle exitosa sin errores de dependencias o tipado Kotlin (`BUILD SUCCESSFUL`).
---

---
### 2026-07-13 17:10 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** OptimizaciÃ³n de UX para la solicitud de permisos de optimizaciÃ³n de baterÃ­a redirigiendo a App Info.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno.
  - **Detalles de ImplementaciÃ³n:**
    * Modificada la callback `onGrantBattery` del overlay de permisos para utilizar la intenciÃ³n `Settings.ACTION_APPLICATION_DETAILS_SETTINGS` en lugar de `Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS`.
    * Esto envÃ­a al usuario directamente a la pantalla de Ajustes de NotificaPe Admin, permitiÃ©ndole ir a "BaterÃ­a" y activar "Sin restricciones", ademÃ¡s de habilitar "Inicio automÃ¡tico" si estÃ¡ en un equipo con capas de fabricante restrictivas.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La redirecciÃ³n abre los detalles de la aplicaciÃ³n NotificaPe Admin de forma directa.
  - [x] AC 2: CompilaciÃ³n Gradle exitosa sin errores de importaciÃ³n o tipado Kotlin (`BUILD SUCCESSFUL`).
---
### 2026-07-17 15:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** ImplementaciÃ³n de la Ã‰pica de Cumplimiento Legal PerÃº y Consola de Superadministrador en el portal web.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados/Creados:** [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx), [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx), [terminos-condiciones/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/terminos-condiciones/page.tsx), [politica-privacidad/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/politica-privacidad/page.tsx), [libro-reclamaciones/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/libro-reclamaciones/page.tsx), [enviar_correo_reclamacion/index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/enviar_correo_reclamacion/index.ts), [superadmin/layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/layout.tsx), [superadmin/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/page.tsx), [superadmin/contratantes/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/contratantes/page.tsx), [superadmin/disputas/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/disputas/page.tsx), [superadmin/reclamaciones/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/reclamaciones/page.tsx), [superadmin/regex/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/regex/page.tsx)
  - **Base de Datos:** Se consume e interactÃºa de forma segura con las tablas `Superadministradores` y `Reclamaciones` por polÃ­ticas RLS y la funciÃ³n RPC `registrar_tx_credito` y `resolver_disputa`. Adicionalmente, se inyecta dinÃ¡micamente el botÃ³n de 'Consola Superadmin' en el SidebarNav clÃ¡sico si el usuario posee privilegios administrativos de base de datos.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Footer y pÃ¡ginas estÃ¡ticas legales totalmente operativas con modo oscuro.
  - [x] AC 2: Formulario de Libro de Reclamaciones inserta registros en caliente y autogenera cÃ³digos en formato legal peruano.
  - [x] AC 3: Edge Function despacha confirmaciones por correo (o simula en local) sin interrumpir la interfaz.
  - [x] AC 4: Acceso a `/superadmin/*` securizado en el servidor mediante Layout de Next.js.
  - [x] AC 5: Funcionalidad del panel general, gestiÃ³n de licencias/dispositivos, abonos de crÃ©ditos y simulaciÃ³n regex validada localmente.
  - [x] AC 6: IntegraciÃ³n del botÃ³n de superadministrador en el menÃº superior de la Landing Page condicionado a privilegios, con color degradado rojo-Ã¡mbar resplandeciente.
  - [x] AC 7: Marcado visual de color rojo distintivo para el botÃ³n 'Consola Superadmin' en el menÃº de navegaciÃ³n del Dashboard clÃ¡sico.
---
### 2026-07-17 17:15 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Refinamiento visual de la barra lateral de Superadmin, redirecciÃ³n automatizada 403 con temporizador de 5 segundos y utilitarios SQL.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados/Creados:** [SuperadminSidebar.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SuperadminSidebar.tsx), [AccessDenied.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/AccessDenied.tsx), [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/superadmin/layout.tsx), [utilidades_superadmin.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/utilidades_superadmin.sql)
  - **Base de Datos:** Se crea un script de utilidades SQL para asociar/remover administradores buscando dinÃ¡micamente por correo electrÃ³nico.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Acceso no autenticado redirige instantÃ¡neamente al login en el servidor.
  - [x] AC 2: Acceso de usuario autenticado sin permisos renderiza componente `AccessDenied`, muestra temporizador interactivo de 5s decreciente y realiza `router.push("/dashboard")` al expirar.
  - [x] AC 3: El menÃº lateral del Superadmin (`SuperadminSidebar`) ahora destaca el enlace de la vista activa en color rojo y aÃ±ade botones explÃ­citos de "Volver al Dashboard" y "Cerrar SesiÃ³n" en la parte inferior.
---
### 2026-07-17 18:30 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** ImplementaciÃ³n de Split Button en la cabecera y reestructuraciÃ³n del footer en dos secciones (superior e inferior).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados/Creados:** [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx), [.env.local](file:///c:/Trabajo/Proyectos/NotificaPe/web/.env.local)
  - **Base de Datos:** Se inyecta la variable de entorno de Next.js `NEXT_PUBLIC_DEVELOPER_URL` para parametrizar el link hacia RYCTECH CORP.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: BotÃ³n de usuario transformado en un Split Button (botÃ³n Dashboard izquierdo directo, flecha desplegable derecha para Superadmin y Cerrar SesiÃ³n).
  - [x] AC 2: OpciÃ³n de Cerrar SesiÃ³n en la Landing Page levanta un modal de confirmaciÃ³n antes de desloguear.
  - [x] AC 3: Footer de dos secciones implementado de forma responsiva (horizontal en desktop, vertical en mobile, colores adaptables en la secciÃ³n superior y negro absoluto inalterable en la secciÃ³n inferior de copyright).
---
### 2026-07-17 20:05 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** CorrecciÃ³n de enlaces y textos de tÃ©rminos y condiciones y polÃ­ticas de privacidad en la pÃ¡gina de login.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/login/page.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Enlace de "TÃ©rminos de servicio" corregido a "TÃ©rminos y condiciones" y modificado para utilizar el componente Link de Next.js apuntando a `/terminos-condiciones`.
  - [x] AC 2: Enlace de "PolÃ­ticas de privacidad" modificado para utilizar el componente Link apuntando a `/politica-privacidad`.
  - [x] AC 3: RemociÃ³n de las etiquetas de hipervÃ­nculo plano <a> por componentes Link para optimizar navegaciÃ³n nativa.
---
### 2026-07-17 20:15 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** RemociÃ³n de marcas de billeteras y parametrizaciÃ³n del correo de soporte en pÃ¡ginas legales y variables de entorno.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/terminos-condiciones/page.tsx), [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/politica-privacidad/page.tsx), [.env.local](file:///c:/Trabajo/Proyectos/NotificaPe/web/.env.local)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Removidas referencias literales a Yape y Plin en los TÃ©rminos y Condiciones, cambiÃ¡ndolas por "billeteras digitales".
  - [x] AC 2: Removidas referencias a Yape y Plin en la PolÃ­tica de Privacidad, cambiÃ¡ndolas por "billeteras digitales".
  - [x] AC 3: Variable `NEXT_PUBLIC_SUPPORT_EMAIL` agregada al archivo `.env.local` y consumida dinÃ¡micamente en el frontend.
---
### 2026-07-19 11:45 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Hotfix RLS para el registro de quejas pÃºblicas anÃ³nimas en el Libro de Reclamaciones.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/libro-reclamaciones/page.tsx)
  - **Base de Datos:** CreaciÃ³n de la funciÃ³n SQL `registrar_reclamacion_publica` con privilegios `SECURITY DEFINER` (Script [0031_registrar_reclamacion_publica_rpc.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0031_registrar_reclamacion_publica_rpc.sql)).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: EvasiÃ³n de la restricciÃ³n de RLS de SELECT para el pÃºblico anÃ³nimo sin vulnerar la privacidad de los datos.
  - [x] AC 2: Retorno seguro del cÃ³digo correlativo de reclamaciÃ³n generado por el trigger a la interfaz de Next.js.
  - [x] AC 3: ValidaciÃ³n tipogrÃ¡fica exitosa mediante compilador de Next.js (`npx tsc --noEmit`).
---
### 2026-07-19 11:55 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Despliegue de la Edge Function enviar_correo_reclamacion y parametrizaciÃ³n de remitente dinÃ¡mico.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/enviar_correo_reclamacion/index.ts)
  - **Base de Datos/Edge Functions:** Despliegue formal de la Edge Function a producciÃ³n y actualizaciÃ³n de la propiedad `from` de la API de Resend para consumir la variable `SUPPORT_EMAIL` (`servicios@send.ryctech.dev`) en lugar de estar hardcodeada a `@notificape.pe`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Despliegue de la Edge Function en producciÃ³n confirmado mediante listado de Supabase.
  - [x] AC 2: CorrecciÃ³n del remitente de envÃ­o de Resend para autorizar de forma legÃ­tima el despacho de correos en base al dominio verificado (`send.ryctech.dev`).
---
### 2026-07-19 20:40 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Redespliegue de la Edge Function enviar_correo_reclamacion con logs de depuraciÃ³n detallada HTTP.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/enviar_correo_reclamacion/index.ts)
  - **Base de Datos/Edge Functions:** InyecciÃ³n de logs detallados en la consola de Supabase para visualizar el formato exacto de la cabecera Authorization y el JSON payload que se despacha a la API de Resend. IncorporaciÃ³n del mÃ©todo `.trim()` al secreto para prevenir espacios en blanco residuales.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Redespliegue a la versiÃ³n 8 en el servidor de producciÃ³n.
  - [x] AC 2: Formateo correcto y transparente de las llamadas API a Resend para depuraciÃ³n de fallos de autorizaciÃ³n por el cliente.
---
### 2026-07-19 20:46 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Redespliegue de la Edge Function enviar_correo_reclamacion con inyecciÃ³n de User-Agent.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/enviar_correo_reclamacion/index.ts)
  - **Base de Datos/Edge Functions:** IncorporaciÃ³n de la cabecera `User-Agent: supabase-edge-runtime/1.0` en la peticiÃ³n fetch de Deno hacia la API de Resend para descartar bloqueos de seguridad por WAF y bots.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Redespliegue a la versiÃ³n 10 en producciÃ³n.
  - [x] AC 2: EvasiÃ³n de bloqueos sintÃ¡cticos por falta de User-Agent en peticiones HTTP nativas en Resend.
---
### 2026-07-19 20:56 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Redespliegue de la Edge Function enviar_correo_reclamacion con marcadores de reemplazo de HTML.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/enviar_correo_reclamacion/index.ts)
  - **Base de Datos/Edge Functions:** SustituciÃ³n de los template literals de ES6 en el HTML por marcadores planos `{{}}` y la aplicaciÃ³n del encadenamiento de funciones `.replace()` para inyectar dinÃ¡micamente las propiedades del cliente sin el uso del caracter `$` en el string del HTML, erradicando cualquier problema de escape sintÃ¡ctico en la compilaciÃ³n de Deno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Redespliegue a la versiÃ³n 12 en producciÃ³n.
  - [x] AC 2: CorrecciÃ³n definitiva de la visualizaciÃ³n de los datos dinÃ¡micos en el cuerpo del correo de confirmaciÃ³n.
---
### 2026-07-19 21:04 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Desarrollador Web)

* **DescripciÃ³n:** Hotfix del Authorization Header en Edge Function para evitar validaciÃ³n fallida en API de Resend.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/enviar_correo_reclamacion/index.ts)
  - **Base de Datos/Edge Functions:** CorrecciÃ³n de un escape accidental generado en el string interpolado del Bearer Token en Deno, reemplazÃ¡ndolo por una concatenaciÃ³n clÃ¡sica estricta (`"Bearer " + token`) para erradicar cualquier fallo sintÃ¡ctico por los motores de Deno/Supabase al leer template literals con el signo `$`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Redespliegue a la versiÃ³n 13 en producciÃ³n.
  - [x] AC 2: CorrecciÃ³n del header HTTP corrupto que provocaba un "API Key Invalid" falso positivo en Resend.
------
### 2026-07-20 15:00 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Orquestador SDD)

* **DescripciÃ³n:** ImplementaciÃ³n de resiliencia proactiva en primer plano y reducciÃ³n de timeout de reconexiÃ³n.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **Base de Datos/Realtime:** Se aÃ±ade un heurÃ­stico de inactividad de background (`lastBackgroundTime`) de 30s. Si el tiempo en background supera este umbral, al volver a foreground y tener internet se fuerza un `hardResetSocket()` del WebSocket para descartar sockets zombies. Se reduce el timeout del estado CONNECTING de 30s a 10s en `startConnectingTimeout()`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: HeurÃ­stico de tiempo en background implementado en el ciclo de vida del componente `lifecycleObserver`.
  - [x] AC 2: ReducciÃ³n del timeout de conexiÃ³n a 10 segundos para mejorar la experiencia de usuario y resiliencia local.
---
### 2026-07-20 15:10 | App/Componente: NotificaPe_Specs / db | Autor: AGENT_ROLE (Orquestador SDD)

* **DescripciÃ³n:** Hotfix de base de datos para eliminar recursiÃ³n infinita en polÃ­ticas RLS de DispositivosXContratante.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** Ninguno (CorrecciÃ³n directa en la base de datos en vivo de Supabase).
  - **Base de Datos:** EliminaciÃ³n de la polÃ­tica RLS obsoleta/redundante `App_Vincular_Y_Actualizar` y actualizaciÃ³n de la polÃ­tica `AdminApp_Update_Restricted` en la tabla `DispositivosXContratante` para usar `WITH CHECK (true)`, eliminando subconsultas recursivas sobre la misma tabla durante la vinculaciÃ³n de dispositivos en rol `anon`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: EliminaciÃ³n de la polÃ­tica recursiva redundante confirmada.
  - [x] AC 2: CorrecciÃ³n de la polÃ­tica `AdminApp_Update_Restricted` aplicada en caliente y verificada.
---
### 2026-07-20 18:05 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Orquestador SDD)

* **DescripciÃ³n:** ImplementaciÃ³n de banner amarillo y diÃ¡logo modal con checklist de configuraciÃ³n para dispositivos OEM restrictivos.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [OemConfigDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/OemConfigDialog.kt)
  - **Base de Datos/Preferencias:** AdiciÃ³n de la llave de preferencia `isOemBannerDismissed` en DataStore. DetecciÃ³n de fabricante y simulaciÃ³n activa para testing. Intents nativos para configurar Inicio AutomÃ¡tico y desactivar ahorro de baterÃ­a propietario.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Banner amarillo integrado y desplegado correctamente mediante flag de simulaciÃ³n en Motorola.
  - [x] AC 2: DiÃ¡logo modal con checklist y botones de redirecciÃ³n a ajustes funcionales.
  - [x] AC 3: Persistencia del descarte mediante botÃ³n "Ocultar siempre" verificado en DataStore.
---
### 2026-07-21 20:08 | App/Componente: NotificaPe_Admin | Autor: AGENT_ROLE (Orquestador SDD)

* **DescripciÃ³n:** InclusiÃ³n de timestamp en el hashing MD5 de IdSync para evitar deduplicaciÃ³n errÃ³nea de notificaciones.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [ExtractPaymentUseCase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/domain/usecase/ExtractPaymentUseCase.kt)
  - **Base de Datos:** Ninguno. Se usa la estructura existente (Room local y Supabase) que maneja el ID como cadena de texto, sin requerir cambios de esquema.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: ParÃ¡metro `timestamp` incorporado en la firma y cuerpo de `generateDeterministicId`.
  - [x] AC 2: Llamadas actualizadas en coincidencia de expresiones regulares y fallback en `ExtractPaymentUseCase`.
  - [x] AC 3: CompilaciÃ³n exitosa del mÃ³dulo admin verificada con Gradle.
---
### 2026-07-21 21:38 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Orquestador SDD)

* **DescripciÃ³n:** RemociÃ³n temporal de la fila de Estado de ConexiÃ³n en el detalle de dispositivo fÃ­sico y registro de CR-009 para rediseÃ±o con Heartbeat / Presencia hÃ­brida.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/%5Bid%5D/page.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Ocultamiento del campo "Estado de ConexiÃ³n" en el modal/secciÃ³n de Dispositivo FÃ­sico en la vista de detalle.
  - [x] AC 2: Registro del Change Request [CR-009] en el backlog global para implementar el mecanismo definitivo (Heartbeat/Presencia hÃ­brida).
---
### 2026-07-22 11:52 | App/Componente: NotificaPe_Web | Autor: AGENT_ROLE (Orquestador SDD)

* **DescripciÃ³n:** ImplementaciÃ³n del Estado de ConexiÃ³n en tiempo real en el detalle del dispositivo fÃ­sico usando Supabase Realtime Presence [CR-009].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DeviceConnectionStatus.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/%5Bid%5D/DeviceConnectionStatus.tsx), [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/%5Bid%5D/page.tsx)
  - **Base de Datos:** Ninguno. Se utiliza la capa en memoria de Supabase Realtime Presence aprovechando la conexiÃ³n WebSocket 24/7 que mantiene la app Admin mediante `AuthRealtimeHandler.kt` en su canal `device_auth_$deviceId`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: CreaciÃ³n del componente reactivo `DeviceConnectionStatus` que se suscribe al canal broadcast de la app Admin.
  - [x] AC 2: DetecciÃ³n instantÃ¡nea (< 1s) de conexiÃ³n cuando la app Admin estÃ¡ activa.
  - [x] AC 3: DetecciÃ³n automÃ¡tica (5-30s) de desconexiÃ³n al cerrar app, apagar el celular o desinstalar la app sin necesidad de escribir en la Base de Datos Postgres.
---


---
### [2026-07-26 09:20] | App/Componente: db | Autor: AGENT_ROLE

* **DescripciÃ³n:** AdiciÃ³n de campo ColorHex a Billeteras y registro de Lemon Cash.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [0018_billeteras_color_lemon.sql](file:///../NotificaPe_Specs/management/database/scripts/0018_billeteras_color_lemon.sql), [schema.sql](file:///../NotificaPe_Specs/management/database/schema.sql)
  - **Base de Datos:** AÃ±adida columna ColorHex en Billeteras. Insertado Lemon (me.lemon.ar).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La migraciÃ³n fue exitosa y la columna existe.
---
---
### [2026-08-04 14:15] | App/Componente: db | Autor: AGENT_ROLE

* **Descripción:** Modificación de prorrateo para add-ons en licencias, compras mixtas y motor de colas pg_cron.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0036_fix_compras_y_motor_colas.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0036_fix_compras_y_motor_colas.sql), [schema.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/schema.sql)
  - **Base de Datos:** Añadidas columnas ExtraUsuarios y ExtraDispositivos a LicenciasCola. Actualizadas RPC previsualizar_compra_licencia y ejecutar_compra_licencia_multiple. Creada RPC procesar_licencias_cola programada diariamente a las 00:01 con pg_cron.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La actualización del código de prorrateo no borra los valores de extras previos y retrocompatibilidad con apps Android verificada.
  - [x] AC 2: El motor de colas con pg_cron quedó instalado y programado correctamente a las 00:01 en Supabase.
---

---
### [2026-08-09 14:00] | App/Componente: db | Autor: Antigravity

* **DescripciÃ³n:** Hard delete de Agora e inyecciÃ³n de reglas de inclusiÃ³n V2 y exclusiones categorizadas (6 registros) para Yape.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [0037_filtros_v2_exclusiones_agora.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0037_filtros_v2_exclusiones_agora.sql)
  - **Base de Datos:** Eliminados registros de Agora (IdBilletera=7) en BilleterasXDispositivo, FiltrosXBilletera y Billeteras. Insertados 14 registros en FiltrosXBilletera (8 INCLUSION V2, 6 EXCLUSION V2).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La base de datos no contiene referencias a la billetera inactiva Agora.
  - [x] AC 2: Se registraron exclusiones categorizadas para evitar ruido de Yape.
---


---
### 2026-09-13 12:03 | App/Componente: db | Autor: AGENT_ROLE

* **DescripciÃ³n:** ImplementaciÃ³n de Triggers FCM y columna FcmToken para el motor Push-to-Pull del Viewer.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [schema.sql](file:///../management/database/schema.sql)
  - **Base de Datos:** AÃ±adida columna FcmToken en tabla Usuarios. Creado script  044_fcm_tokens_viewer.sql con funciÃ³n n_dispatch_fcm_viewer y triggers para sincronizar autorizaciones, pagos, reclamos y billeteras vÃ­a la Edge Function cm-dispatcher.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La columna FcmToken estÃ¡ lista para recibir el token de Google.
  - [x] AC 2: Los triggers de cruce aseguran enviar notificaciones solo a cajeros aprobados.
---

---
### [2026-09-18 13:29] | App/Componente: Supabase BD | Autor: Orquestador SDD

* **Descripción:** Inyección de payload detallado en el trigger de autorizaciones para Viewer.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0044_fcm_tokens_viewer.sql](file:///C:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0044_fcm_tokens_viewer.sql)
  - **Base de Datos:** Modificación in-place de la función fn_dispatch_fcm_viewer para incluir jsonb data_payload.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: SYNC_AUTH notifica estado, id de dispositivo y autorización afectados.
---


---
### [2026-09-18 13:48] | App/Componente: Supabase BD | Autor: Orquestador SDD

* **Descripción:** Enriquecimiento del payload FCM con nombres de negocio y dispositivo.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0044_fcm_tokens_viewer.sql](file:///C:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0044_fcm_tokens_viewer.sql)
  - **Base de Datos:** SELECT JOIN añadido para extraer AliasDispositivo y NombreNegocio de la caja afectada.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: SYNC_AUTH envía información contextual completa.
---

