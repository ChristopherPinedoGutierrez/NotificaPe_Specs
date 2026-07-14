# Changelog de Aplicación Viewer

Este archivo contiene el historial de cambios a nivel de UI, lógica y configuración de la aplicación móvil **NotificaPe Viewer**.

---
### 2026-07-08 12:50 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Remoción de la verificación y solicitud obligatoria de optimización de batería para cumplir con las políticas de Google Play Store.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PermissionGuard.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/PermissionGuard.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se remueve la verificación de optimización de batería del guardián de permisos (`PermissionGuard.kt`), eliminando el bloqueo que impedía el ingreso al dashboard sin desactivar el ahorro de energía.
  - [x] AC 2: Se remueve el ítem "Sin Restricción de Batería" en la interfaz gráfica del onboarding de permisos.
  - [x] AC 3: Se elimina por completo el banner de advertencia `BatteryOptimizationShield` de la interfaz de configuración del sistema (`SistemaComponents.kt`).
  - [x] AC 4: La compilación del código Kotlin de la aplicación móvil se completa exitosamente sin errores sintácticos o referencias huérfanas.
---

---
### 2026-07-08 13:00 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Corrección de firmado digital en configuración Gradle para resolver BadPaddingException.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se sustituye el keystore incorrecto `key1.jks` por `key_viewer.jks` en la configuración de `signingConfigs` y `buildTypes` (debug/release) del módulo de la aplicación.
  - [x] AC 2: Se confirma que el descifrado de las credenciales configuradas en `local.properties` funciona correctamente, resolviendo el error `BadPaddingException` durante el empaquetado y firmado de la APK.
---
---
### 2026-07-12 15:40 | App/Componente: NotificaPe_Admin / NotificaPe_Viewer | Autor: AGENT_ROLE (Arquitecto/DevOps)

* **Descripción:** Implementación de pipeline de CI/CD automatizado con autoincremento de versionCode en GitHub Actions para despliegue en Google Play Store.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [deploy.yml (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/deploy.yml), [release-please.yml (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/release-please.yml), [deploy.yml (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/.github/workflows/deploy.yml), [release-please.yml (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/.github/workflows/release-please.yml), [build.gradle.kts (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/build.gradle.kts), [build.gradle.kts (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Configurado el pipeline `deploy.yml` para compilar el bundle AAB firmado y subir de forma automatizada al canal de Pruebas Internas de Google Play Store.
  - [x] AC 2: Implementado script de Python nativo en el workflow que consulta a la API de Google Play la última versión cargada en el track y realiza el autoincremento dinámico de `versionCode` (+1) en caliente para evitar errores de duplicidad.
  - [x] AC 3: Configurado el pipeline `release-please.yml` para automatizar la gestión de versiones públicas e historial de cambios a partir de Conventional Commits.
  - [x] AC 4: Subido exitosamente a la Google Play Store mediante ejecución manual en GitHub Actions (`versionCode = 3`).
---

---
### 2026-07-14 12:10 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnóstico remoto [CR-003].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [LoginScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/login/LoginScreen.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se refactorizó el bloque `catch` de `GetCredentialException` para interceptar de forma explícita las subclases `GetCredentialCancellationException`, `NoCredentialException`, `GetCredentialInterruptedException` y `GetCredentialProviderConfigurationException`.
  - [x] AC 2: Se proveen mensajes detallados y específicos en pantalla de error en lugar del texto genérico estático de cancelación para facilitar el soporte remoto en dispositivos como Magic OS.
  - [x] AC 3: La compilación del código Kotlin se completa exitosamente tras la integración sintáctica.
---

---
### 2026-07-14 12:35 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Implementación de resiliencia de Realtime, reconexión física de red y sincronización delta dinámica [CR-004].
* **Detalles Técnicos:**
  - **Archivos Creados:** [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/util/NetworkMonitor.kt)
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [SyncScavenger.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/SyncScavenger.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se integró `NetworkMonitor` para registrar cambios de red física a nivel de sistema operativo y forzar `hardReset()` al recuperar internet.
  - [x] AC 2: Se implementó un reset preventivo automático (`hardReset()`) al volver a primer plano tras inactividad prolongada (>15s) para limpiar canales zombis.
  - [x] AC 3: Se desacopló la sincronización delta (`performDeltaSync`) del cambio síncrono de visibilidad, gatillándose ahora únicamente tras el éxito del estado `SUBSCRIBED` del canal de notificaciones.
  - [x] AC 4: Se calcula de forma dinámica el buffer de tiempo en el Scavenger según los segundos transcurridos en background (con un piso mínimo de 5 minutos).
  - [x] AC 5: La compilación del módulo Android finalizó exitosamente sin errores de inyección Hilt.
---

---
### 2026-07-14 13:10 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Robustecimiento de reconexión Realtime mediante exclusión mutua, auto-suscripción y desconexión preventiva [CR-004 v2].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se integró `profileMutex: Mutex` para encapsular de forma atómica y secuencial el cambio de perfiles en `setProfile` y la ejecución de `hardReset()`.
  - [x] AC 2: Se implementó un observador en `observeSocketStatus` que detecta la reconexión física del socket de Supabase (`CONNECTED`) y gatilla de forma proactiva `hardReset()`, asegurando que todos los canales se re-suscriban en el servidor.
  - [x] AC 3: Se programó una desconexión preventiva del socket WebSocket mediante `supabaseClient.realtime.disconnect()` al perder la red física (`isOnline == false`) para mantener en sincronía la máquina de estados local con el hardware.
  - [x] AC 4: Se removió la variable miembro obsoleta `profileJob`.
  - [x] AC 5: Compilación exitosa del build debug sin errores de Kotlin, dependencias Hilt o sintaxis.
---

---
### 2026-07-14 13:30 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Integración de Offline Banner animado superior para visibilidad de conectividad [CR-004 v2.1].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [HomeNavigationComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/HomeNavigationComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se integró `AnimatedVisibility` con efectos de deslizamiento/expansión vertical en `HomeTopBar` para mostrar/ocultar el banner de red.
  - [x] AC 2: Se escucha el estado de `connectionStatus` para pintar el banner en color rojo ("Sin conexión a Internet") en `DISCONNECTED` y amarillo/secundario ("Restableciendo enlace...") en `CONNECTING`.
  - [x] AC 3: El banner se oculta por completo de forma limpia en el estado `CONNECTED` o `SYNCING`, eliminando bloqueos visuales molestos.
  - [x] AC 4: Se respeta el padding superior de la barra de estado del sistema (`statusBarsPadding()`) evitando superposiciones.
  - [x] AC 5: Compilación Gradle debug exitosa en 1m 7s.
---

---
### 2026-07-14 14:00 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Solución definitiva de bucles de reconexión y estabilización de perfiles al regresar de background [CR-004 v2.2].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se implementó un debounce temporal de 2000ms en `hardReset()` mediante la propiedad `lastResetTime` para descartar resets concurrentes y redundantes.
  - [x] AC 2: Se añadió el parámetro opcional `forceProfile` a `hardReset()`. Al volver de background, se fuerza el perfil completo `RealtimeProfile.OPERATIONAL_FULL` para asegurar que no se quede estancado en el perfil de ahorro `CENTINELA_MINIMAL`.
  - [x] AC 3: Se introdujo la variable de estado miembro de clase `wasConnectedOnce` para discernir reconexiones físicas genuinas del socket de la primera conexión inicial limpia.
  - [x] AC 4: Se limpia `wasConnectedOnce = false` al apagar la sesión en `detenerTodo()`.
  - [x] AC 5: Compilación exitosa del build debug en 1m 50s.
---

---
### 2026-07-14 15:05 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Implementación de observaciones y justificaciones en el flujo de reclamos y disputas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** Habilitación de `p_justificacion` en la llamada de la RPC `reclamar_notificacion_v2`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Habilitado el envío de `"p_justificacion"` en la llamada del RPC en `reclamarPago` de `PagosRemoteDataSource.kt`.
  - [x] AC 2: Se calcula dinámicamente `EsPropietario` en `obtenerMisConflictos` determinando el primer reclamante en base a la `FechaReg` mínima, resolviendo el valor nulo de `IdUsuarioGanador` en disputas.
  - [x] AC 3: Agregado un `OutlinedTextField` opcional en `ConfirmacionReclamoDialog` que pasa la observación ingresada al reclamo inicial.
  - [x] AC 4: Se actualizaron etiquetas, placeholders e información del modal de disputas en `ControlComponents.kt` para reflejar con precisión el rol y permitir el ingreso de descargos (defensas) para dueños originales e impugnadores.
  - [x] AC 5: Compilación Gradle exitosa en 1m 53s.
---

---
### 2026-07-14 15:15 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Persistencia real y visualización de observaciones en el detalle de ventas cobradas [CR-004 v2.3].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [PagosRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/domain/repository/PagosRepository.kt), [PagosRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/data/repository/PagosRepositoryImpl.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeScreen.kt)
  - **Base de Datos:** Creación de la RPC `actualizar_observacion_reclamo`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se integró la RPC `actualizar_observacion_reclamo` con `SECURITY DEFINER` para actualizar la columna `Observacion` en `NotificacionesAUsuarios` sin restricciones de estado (funciona en `'APROBADO'`).
  - [x] AC 2: Se implementó un cruce de datos en lote en `obtenerPagosDelDia` para poblar en memoria la propiedad `Observacion` del objeto de dominio `Notificacion` leyendo de `NotificacionesAUsuarios`.
  - [x] AC 3: Se habilitó la persistencia real del TextField de observación en el modal de detalle de venta del dashboard en la pestaña "Ventas", redireccionándolo a la nueva RPC de actualización.
  - [x] AC 4: Compilación Gradle debug exitosa en 3m 23s.
---

---
### 2026-07-14 15:50 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Solución a defensas de dueños en disputas, visibilidad de ventas resueltas y resolución del limbo transaccional en anulación de reclamos [CR-004 v2.4].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [HomeStateProvider.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeStateProvider.kt)
  - **Base de Datos:** Creación de la RPC `actualizar_justificacion_reclamo` e implementación de la RPC `retirar_reclamo_v4` en el script `0029_rpc_observacion_justificacion_reclamos.sql` en specs.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se implementó la RPC `actualizar_justificacion_reclamo` con `SECURITY DEFINER` para permitir el guardado de defensas (justificaciones de conflicto) en la columna `JustificacionConflicto` evitando bloqueos por RLS de `UPDATE`.
  - [x] AC 2: Se modificó la query en `actualizarJustificacion` para utilizar la nueva RPC en lugar de la consulta REST directa.
  - [x] AC 3: Se corrigió el filtro de `misVentas` en `HomeStateProvider.kt` sustituyendo `!it.enDisputa` por `it.EstadoProgreso != "REVISION"`. Esto permite volver a listar en la pestaña "Ventas" aquellos pagos cuyas disputas fueron resueltas a favor del usuario (`COMPLETADO`).
  - [x] AC 4: Se diseñó e implementó la RPC `retirar_reclamo_v4` para solventar el limbo transaccional: si el dueño original o el impugnante anula su participación, el pago se reasigna automáticamente al participante restante (completando la venta a su favor) o se libera completamente a `PENDIENTE` si no queda nadie.
  - [x] AC 5: Compilación Gradle debug exitosa en 1m 39s.
---







