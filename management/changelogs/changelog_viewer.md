# Changelog de AplicaciÃÂ³n Viewer

Este archivo contiene el historial de cambios a nivel de UI, lÃÂ³gica y configuraciÃÂ³n de la aplicaciÃÂ³n mÃÂ³vil **NotificaPe Viewer**.

---
### [2026-09-04 15:05] | App/Componente: viewer | Autor: AGENT_ROLE

* **Descripción:** Solución integral a fuga de datos entre sesiones y estabilización de conteo tras swipe (1 -> 3 -> 2).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [AuthIdentityManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/AuthIdentityManager.kt), [AuthRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/AuthRepositoryImpl.kt), [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [PagosRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/domain/repository/PagosRepository.kt), [PagosRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/PagosRepositoryImpl.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeScreen.kt), [MainActivity.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/MainActivity.kt), [HomePaymentsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomePaymentsManager.kt), [HomeStateProvider.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeStateProvider.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Purga total de memoria en AuthIdentityManager y desconexión activa de Realtime al desautenticar o cambiar de caja.
  - [x] AC 2: Aislamiento estricto de participaciones (mochila) por IdDispositivo mediante relación interna con NotificacionesXDispositivo.
  - [x] AC 3: Recreación limpia de HomeScreen en MainActivity mediante key(state.idAutorizacion, state.idDispositivo) y reset en onDispose.
  - [x] AC 4: Homologación de filtros REST y memoria en HomePaymentsManager evitando retención de pagos privados o cerrados.
  - [x] AC 5: Alineación de resumenVentas con misVentas y visualización de banner/badge interactivo en ControlTab cuando existen pagos en revisión activa.
  - [x] AC 6: Compilación exitosa bajo Android SDK Platform 36 (Android 16).
---
---
### [2026-09-04 14:05] | App/Componente: viewer | Autor: AGENT_ROLE

* **Descripción:** Actualización obligatoria de compileSdk y targetSdk a API 36 (Android 16) para cumplimiento de normativas de Google Play Store.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [app/build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: compileSdk y targetSdk actualizados a 36 en viewer/app/build.gradle.kts.
  - [x] AC 2: Despliegue automático de Release Please y subida exitosa de paquete AAB con targetSdk 36 a Google Play Console (Prueba Interna).
---
---
### 2026-07-21 22:24 | App/Componente: viewer | Autor: AGENT_ROLE

* **DescripciÃ³n:** CorrecciÃ³n de tema oscuro en barra de navegaciÃ³n del sistema (flecha, cÃ­rculo, cuadrado) y habilitaciÃ³n de edge-to-edge.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [themes.xml](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/res/values/themes.xml), [MainActivity.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/MainActivity.kt), [Theme.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/theme/Theme.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La app hereda de `Theme.AppCompat.DayNight.NoActionBar` permitiendo la adaptaciÃ³n al tema oscuro/claro del sistema Android.
  - [x] AC 2: Se invoca `enableEdgeToEdge()` en `MainActivity` y se configura `SideEffect` en `NotificaPeTheme` para controlar dinÃ¡micamente el color de fondo y de Ã­conos de la barra de navegaciÃ³n del sistema.
---
### 2026-07-08 12:50 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** RemociÃÂ³n de la verificaciÃÂ³n y solicitud obligatoria de optimizaciÃÂ³n de baterÃÂ­a para cumplir con las polÃÂ­ticas de Google Play Store.
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [PermissionGuard.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/PermissionGuard.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se remueve la verificaciÃÂ³n de optimizaciÃÂ³n de baterÃÂ­a del guardiÃÂ¡n de permisos (`PermissionGuard.kt`), eliminando el bloqueo que impedÃÂ­a el ingreso al dashboard sin desactivar el ahorro de energÃÂ­a.
  - [x] AC 2: Se remueve el ÃÂ­tem "Sin RestricciÃÂ³n de BaterÃÂ­a" en la interfaz grÃÂ¡fica del onboarding de permisos.
  - [x] AC 3: Se elimina por completo el banner de advertencia `BatteryOptimizationShield` de la interfaz de configuraciÃÂ³n del sistema (`SistemaComponents.kt`).
  - [x] AC 4: La compilaciÃÂ³n del cÃÂ³digo Kotlin de la aplicaciÃÂ³n mÃÂ³vil se completa exitosamente sin errores sintÃÂ¡cticos o referencias huÃÂ©rfanas.
---

---
### 2026-07-08 13:00 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** CorrecciÃÂ³n de firmado digital en configuraciÃÂ³n Gradle para resolver BadPaddingException.
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se sustituye el keystore incorrecto `key1.jks` por `key_viewer.jks` en la configuraciÃÂ³n de `signingConfigs` y `buildTypes` (debug/release) del mÃÂ³dulo de la aplicaciÃÂ³n.
  - [x] AC 2: Se confirma que el descifrado de las credenciales configuradas en `local.properties` funciona correctamente, resolviendo el error `BadPaddingException` durante el empaquetado y firmado de la APK.
---
---
### 2026-07-12 15:40 | App/Componente: NotificaPe_Admin / NotificaPe_Viewer | Autor: AGENT_ROLE (Arquitecto/DevOps)

* **DescripciÃÂ³n:** ImplementaciÃÂ³n de pipeline de CI/CD automatizado con autoincremento de versionCode en GitHub Actions para despliegue en Google Play Store.
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [deploy.yml (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/deploy.yml), [release-please.yml (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/release-please.yml), [deploy.yml (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/.github/workflows/deploy.yml), [release-please.yml (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/.github/workflows/release-please.yml), [build.gradle.kts (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/build.gradle.kts), [build.gradle.kts (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Configurado el pipeline `deploy.yml` para compilar el bundle AAB firmado y subir de forma automatizada al canal de Pruebas Internas de Google Play Store.
  - [x] AC 2: Implementado script de Python nativo en el workflow que consulta a la API de Google Play la ÃÂºltima versiÃÂ³n cargada en el track y realiza el autoincremento dinÃÂ¡mico de `versionCode` (+1) en caliente para evitar errores de duplicidad.
  - [x] AC 3: Configurado el pipeline `release-please.yml` para automatizar la gestiÃÂ³n de versiones pÃÂºblicas e historial de cambios a partir de Conventional Commits.
  - [x] AC 4: Subido exitosamente a la Google Play Store mediante ejecuciÃÂ³n manual en GitHub Actions (`versionCode = 3`).
---

---
### 2026-07-14 12:10 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** Mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃÂ³stico remoto [CR-003].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [LoginScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/login/LoginScreen.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se refactorizÃÂ³ el bloque `catch` de `GetCredentialException` para interceptar de forma explÃÂ­cita las subclases `GetCredentialCancellationException`, `NoCredentialException`, `GetCredentialInterruptedException` y `GetCredentialProviderConfigurationException`.
  - [x] AC 2: Se proveen mensajes detallados y especÃÂ­ficos en pantalla de error en lugar del texto genÃÂ©rico estÃÂ¡tico de cancelaciÃÂ³n para facilitar el soporte remoto en dispositivos como Magic OS.
  - [x] AC 3: La compilaciÃÂ³n del cÃÂ³digo Kotlin se completa exitosamente tras la integraciÃÂ³n sintÃÂ¡ctica.
---

---
### 2026-07-14 12:35 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** ImplementaciÃÂ³n de resiliencia de Realtime, reconexiÃÂ³n fÃÂ­sica de red y sincronizaciÃÂ³n delta dinÃÂ¡mica [CR-004].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Creados:** [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/util/NetworkMonitor.kt)
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [SyncScavenger.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/SyncScavenger.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se integrÃÂ³ `NetworkMonitor` para registrar cambios de red fÃÂ­sica a nivel de sistema operativo y forzar `hardReset()` al recuperar internet.
  - [x] AC 2: Se implementÃÂ³ un reset preventivo automÃÂ¡tico (`hardReset()`) al volver a primer plano tras inactividad prolongada (>15s) para limpiar canales zombis.
  - [x] AC 3: Se desacoplÃÂ³ la sincronizaciÃÂ³n delta (`performDeltaSync`) del cambio sÃÂ­ncrono de visibilidad, gatillÃÂ¡ndose ahora ÃÂºnicamente tras el ÃÂ©xito del estado `SUBSCRIBED` del canal de notificaciones.
  - [x] AC 4: Se calcula de forma dinÃÂ¡mica el buffer de tiempo en el Scavenger segÃÂºn los segundos transcurridos en background (con un piso mÃÂ­nimo de 5 minutos).
  - [x] AC 5: La compilaciÃÂ³n del mÃÂ³dulo Android finalizÃÂ³ exitosamente sin errores de inyecciÃÂ³n Hilt.
---

---
### 2026-07-14 13:10 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** Robustecimiento de reconexiÃÂ³n Realtime mediante exclusiÃÂ³n mutua, auto-suscripciÃÂ³n y desconexiÃÂ³n preventiva [CR-004 v2].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se integrÃÂ³ `profileMutex: Mutex` para encapsular de forma atÃÂ³mica y secuencial el cambio de perfiles en `setProfile` y la ejecuciÃÂ³n de `hardReset()`.
  - [x] AC 2: Se implementÃÂ³ un observador en `observeSocketStatus` que detecta la reconexiÃÂ³n fÃÂ­sica del socket de Supabase (`CONNECTED`) y gatilla de forma proactiva `hardReset()`, asegurando que todos los canales se re-suscriban en el servidor.
  - [x] AC 3: Se programÃÂ³ una desconexiÃÂ³n preventiva del socket WebSocket mediante `supabaseClient.realtime.disconnect()` al perder la red fÃÂ­sica (`isOnline == false`) para mantener en sincronÃÂ­a la mÃÂ¡quina de estados local con el hardware.
  - [x] AC 4: Se removiÃÂ³ la variable miembro obsoleta `profileJob`.
  - [x] AC 5: CompilaciÃÂ³n exitosa del build debug sin errores de Kotlin, dependencias Hilt o sintaxis.
---

---
### 2026-07-14 13:30 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** IntegraciÃÂ³n de Offline Banner animado superior para visibilidad de conectividad [CR-004 v2.1].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [HomeNavigationComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/HomeNavigationComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se integrÃÂ³ `AnimatedVisibility` con efectos de deslizamiento/expansiÃÂ³n vertical en `HomeTopBar` para mostrar/ocultar el banner de red.
  - [x] AC 2: Se escucha el estado de `connectionStatus` para pintar el banner en color rojo ("Sin conexiÃÂ³n a Internet") en `DISCONNECTED` y amarillo/secundario ("Restableciendo enlace...") en `CONNECTING`.
  - [x] AC 3: El banner se oculta por completo de forma limpia en el estado `CONNECTED` o `SYNCING`, eliminando bloqueos visuales molestos.
  - [x] AC 4: Se respeta el padding superior de la barra de estado del sistema (`statusBarsPadding()`) evitando superposiciones.
  - [x] AC 5: CompilaciÃÂ³n Gradle debug exitosa en 1m 7s.
---

---
### 2026-07-14 14:00 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** SoluciÃÂ³n definitiva de bucles de reconexiÃÂ³n y estabilizaciÃÂ³n de perfiles al regresar de background [CR-004 v2.2].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se implementÃÂ³ un debounce temporal de 2000ms en `hardReset()` mediante la propiedad `lastResetTime` para descartar resets concurrentes y redundantes.
  - [x] AC 2: Se aÃÂ±adiÃÂ³ el parÃÂ¡metro opcional `forceProfile` a `hardReset()`. Al volver de background, se fuerza el perfil completo `RealtimeProfile.OPERATIONAL_FULL` para asegurar que no se quede estancado en el perfil de ahorro `CENTINELA_MINIMAL`.
  - [x] AC 3: Se introdujo la variable de estado miembro de clase `wasConnectedOnce` para discernir reconexiones fÃÂ­sicas genuinas del socket de la primera conexiÃÂ³n inicial limpia.
  - [x] AC 4: Se limpia `wasConnectedOnce = false` al apagar la sesiÃÂ³n en `detenerTodo()`.
  - [x] AC 5: CompilaciÃÂ³n exitosa del build debug en 1m 50s.
---

---
### 2026-07-14 15:05 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** ImplementaciÃÂ³n de observaciones y justificaciones en el flujo de reclamos y disputas.
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** HabilitaciÃÂ³n de `p_justificacion` en la llamada de la RPC `reclamar_notificacion_v2`.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Habilitado el envÃÂ­o de `"p_justificacion"` en la llamada del RPC en `reclamarPago` de `PagosRemoteDataSource.kt`.
  - [x] AC 2: Se calcula dinÃÂ¡micamente `EsPropietario` en `obtenerMisConflictos` determinando el primer reclamante en base a la `FechaReg` mÃÂ­nima, resolviendo el valor nulo de `IdUsuarioGanador` en disputas.
  - [x] AC 3: Agregado un `OutlinedTextField` opcional en `ConfirmacionReclamoDialog` que pasa la observaciÃÂ³n ingresada al reclamo inicial.
  - [x] AC 4: Se actualizaron etiquetas, placeholders e informaciÃÂ³n del modal de disputas en `ControlComponents.kt` para reflejar con precisiÃÂ³n el rol y permitir el ingreso de descargos (defensas) para dueÃÂ±os originales e impugnadores.
  - [x] AC 5: CompilaciÃÂ³n Gradle exitosa en 1m 53s.
---

---
### 2026-07-14 15:15 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** Persistencia real y visualizaciÃÂ³n de observaciones en el detalle de ventas cobradas [CR-004 v2.3].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [PagosRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/domain/repository/PagosRepository.kt), [PagosRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/data/repository/PagosRepositoryImpl.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeScreen.kt)
  - **Base de Datos:** CreaciÃÂ³n de la RPC `actualizar_observacion_reclamo`.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se integrÃÂ³ la RPC `actualizar_observacion_reclamo` con `SECURITY DEFINER` para actualizar la columna `Observacion` en `NotificacionesAUsuarios` sin restricciones de estado (funciona en `'APROBADO'`).
  - [x] AC 2: Se implementÃÂ³ un cruce de datos en lote en `obtenerPagosDelDia` para poblar en memoria la propiedad `Observacion` del objeto de dominio `Notificacion` leyendo de `NotificacionesAUsuarios`.
  - [x] AC 3: Se habilitÃÂ³ la persistencia real del TextField de observaciÃÂ³n en el modal de detalle de venta del dashboard en la pestaÃÂ±a "Ventas", redireccionÃÂ¡ndolo a la nueva RPC de actualizaciÃÂ³n.
  - [x] AC 4: CompilaciÃÂ³n Gradle debug exitosa en 3m 23s.
---

---
### 2026-07-14 15:50 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** SoluciÃÂ³n a defensas de dueÃÂ±os en disputas, visibilidad de ventas resueltas y resoluciÃÂ³n del limbo transaccional en anulaciÃÂ³n de reclamos [CR-004 v2.4].
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [HomeStateProvider.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeStateProvider.kt)
  - **Base de Datos:** CreaciÃÂ³n de la RPC `actualizar_justificacion_reclamo` e implementaciÃÂ³n de la RPC `retirar_reclamo_v4` en el script `0029_rpc_observacion_justificacion_reclamos.sql` en specs.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: Se implementÃÂ³ la RPC `actualizar_justificacion_reclamo` con `SECURITY DEFINER` para permitir el guardado de defensas (justificaciones de conflicto) en la columna `JustificacionConflicto` evitando bloqueos por RLS de `UPDATE`.
  - [x] AC 2: Se modificÃÂ³ la query en `actualizarJustificacion` para utilizar la nueva RPC en lugar de la consulta REST directa.
  - [x] AC 3: Se corrigiÃÂ³ el filtro de `misVentas` en `HomeStateProvider.kt` sustituyendo `!it.enDisputa` por `it.EstadoProgreso != "REVISION"`. Esto permite volver a listar en la pestaÃÂ±a "Ventas" aquellos pagos cuyas disputas fueron resueltas a favor del usuario (`COMPLETADO`).
  - [x] AC 4: Se diseÃÂ±ÃÂ³ e implementÃÂ³ la RPC `retirar_reclamo_v4` para solventar el limbo transaccional: si el dueÃÂ±o original o el impugnante anula su participaciÃÂ³n, el pago se reasigna automÃÂ¡ticamente al participante restante (completando la venta a su favor) o se libera completamente a `PENDIENTE` si no queda nadie.
  - [x] AC 5: CompilaciÃÂ³n Gradle debug exitosa en 1m 39s.
---

---
### 2026-07-21 00:23 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃÂ³n:** RefactorizaciÃÂ³n a Foreground Service con START_STICKY, Bypass de OptimizaciÃÂ³n de BaterÃÂ­a, telemetrÃÂ­a y Text-To-Speech (TTS) nativo.
* **Detalles TÃÂ©cnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/AndroidManifest.xml), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [UserPreferencesRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/UserPreferencesRepository.kt), [PermissionGuard.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/PermissionGuard.kt)
  - **Archivos Creados:** [TtsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/manager/TtsManager.kt), [BootReceiver.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/BootReceiver.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃÂ³n (AC) Validados:**
  - [x] AC 1: CentinelaService migrado a Foreground Service (LifecycleService) con START_STICKY.
  - [x] AC 2: TelemetrÃÂ­a de DiagnosticsManager integrada y mostrada en NotificaciÃÂ³n Persistente.
  - [x] AC 3: TtsManager y Vibrator implementados para notificar en vivo pagos recibidos.
  - [x] AC 4: BootReceiver implementado para auto-reconexiÃÂ³n tras reinicio.
  - [x] AC 5: Controles de UI para TTS y VibraciÃÂ³n en SistemaTab, y peticiÃÂ³n nativa de Bypass de baterÃÂ­a.
------
### 2026-07-21 22:30 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** RestauraciÃ³n del flujo de eventos Insert en RealtimeCoordinator (cumpleFiltro) para reparar las alertas en segundo plano (TTS y VibraciÃ³n) de nuevas notificaciones [CR-008].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: `cumpleFiltro` en `RealtimeCoordinator.kt` restituye la validaciÃ³n de igualdad (`value == targetValue`), permitiendo el flujo de eventos `PostgresAction.Insert`.
  - [x] AC 2: Se verificÃ³ que las inserciones ahora pasan la validaciÃ³n, desencadenando notificaciones, TTS y VibraciÃ³n mediante `CentinelaRealtimeManager` incluso con la aplicaciÃ³n en segundo plano.
  - [x] AC 3: CompilaciÃ³n Gradle debug exitosa confirmada.
---

### [2026-07-21 13:00] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE

* **DescripciÃ³n:** Fijado de notificaciÃ³n persistente, soluciÃ³n a colapso de canal y fixes de rÃ¡fagas TTS.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [TtsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/manager/TtsManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La notificaciÃ³n se mantiene expandida y el Foreground Service es resiliente en background.
  - [x] AC 2: Las notificaciones en rÃ¡fagas de pruebas generan mÃºltiples mensajes TTS sin cortarse.
---

### [2026-07-21 16:00] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** SoluciÃ³n a alertas duplicadas por reconexiÃ³n/Delta Sync, fix de crash por permiso de vibraciÃ³n, desactivaciÃ³n inmediata de TTS y silenciado de burbujas heads-up. ImplementaciÃ³n de vibraciÃ³n sincronizada a la voz (UtteranceProgressListener) y cola secuencial de vibraciÃ³n asÃ­ncrona (Voz OFF). CorrecciÃ³n del estado "Sincronizando..." atascado al minimizar (unsubscription asÃ­ncrona), traslado de la notificaciÃ³n persistente fuera de la secciÃ³n de silenciosas (Canal v3 con IMPORTANCE_DEFAULT), visualizaciÃ³n del Pulso Global en el Panel de DiagnÃ³stico, y limpieza de cachÃ© de pagos notificados al desvincular.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/AndroidManifest.xml), [MainActivity.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/MainActivity.kt), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [DiagnosticsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/DiagnosticsManager.kt), [RealtimeDiagnostics.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/model/RealtimeDiagnostics.kt), [TtsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/manager/TtsManager.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [UserPreferencesRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/UserPreferencesRepository.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [RealtimeAuditDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/realtime/components/RealtimeAuditDialog.kt), [AuthRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/AuthRepositoryImpl.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: El apagado de TTS detiene la reproducciÃ³n actual y limpia la cola de inmediato.
  - [x] AC 2: La vibraciÃ³n se sincroniza al habla (*Vibra â Voz Pago A â Vibra â Voz Pago B*) cuando ambos switches estÃ¡n encendidos.
  - [x] AC 3: Con la Voz desactivada y VibraciÃ³n activa, los pagos consecutivos generan vibraciones secuenciales limpias (separadas por 1.5s).
  - [x] AC 4: El cache de deduplicaciÃ³n de IDs de pago (hasta 100) en DataStore previene duplicaciÃ³n en reconexiones.
  - [x] AC 5: Al desvincular la caja, se limpia el historial de duplicados para permitir re-testeo limpio.
  - [x] AC 6: Al minimizar la app o hacer swipe, la notificaciÃ³n persistente cambia a "Conectado â" de inmediato (no se queda en Sincronizando...).
  - [x] AC 7: La notificaciÃ³n persistente ahora aparece en la secciÃ³n Activa del panel de Android (fuera de Silenciosas) gracias al canal v3 con IMPORTANCE_DEFAULT.
  - [x] AC 8: El Panel de DiagnÃ³stico muestra la mÃ©trica "PULSO: Xs" en tiempo real al igual que en Admin.
---

### [2026-07-21 17:30] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** SoluciÃ³n al bug de des-registro de IDs de dispositivo y usuario al minimizar la app (`setAppVisibility`). GarantÃ­a de inmutabilidad del canal de notificaciones en background sin reinicios ni caÃ­das a 'Sincronizando...'.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Al pasar a segundo plano (`CENTINELA_MINIMAL`), se preserva el `idDispositivo` activo, evitando reconstruir o cancelar la suscripciÃ³n a `NotificacionesXDispositivo`.
  - [x] AC 2: La notificaciÃ³n persistente mantiene su estado en `En LÃ­nea â` (o `Conectado â`) al minimizar.
  - [x] AC 3: Los pagos generados desde el Admin se escuchan y notifican instantÃ¡neamente sin retrasos ni colas diferidas en segundo plano.
---

### [2026-07-21 17:45] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** SoluciÃ³n al bucle de desintegraciÃ³n de socket provocado por `hardReset()` en `observeSocketStatus()`, y homologaciÃ³n exacta de los textos de la notificaciÃ³n persistente con la pÃ­ldora de la UI (`En LÃ­nea`, `Conectando`, `Sincronizando`, `Sin Red`).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La notificaciÃ³n persistente usa exactamente los textos del PIL (`En LÃ­nea â`, `Sin Red â ï¸`, `Conectando... ð`, `Sincronizando... ð`).
  - [x] AC 2: Se eliminÃ³ el bucle recursivo de `hardReset()` al conectar el socket; las reconexiones verdaderas re-suscriben canales in-place sin tirar abajo el socket.
  - [x] AC 3: Al cambiar de app o minimizar, el Viewer se mantiene `En LÃ­nea â` y procesa los eventos entrantes sin latencia ni pÃ©rdida de notificaciones.
---

### [2026-07-21 18:45] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** CorrecciÃ³n de condiciÃ³n de carrera en el inicio del socket y alineaciÃ³n estricta con el patrÃ³n pasivo de la app Admin. `setProfile` queda como Ãºnico dueÃ±o de la suscripciÃ³n de canales; se removiÃ³ la re-suscripciÃ³n paralela desde `observeSocketStatus`.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Al iniciar la app, la conexiÃ³n completa limpia a `En LÃ­nea` sin caer en `Sin Red` ni `Sin conexiÃ³n a Internet`.
  - [x] AC 2: `observeSocketStatus` opera como observador pasivo de salud (igual que en Admin `setupStatusMonitoring`), sin disputar llamadas a `iniciarCanal`.
  - [x] AC 3: La notificaciÃ³n persistente y el PIL de UI muestran cadenas sobrias exactas (`En LÃ­nea`, `Conectando...`, `Sincronizando...`, `Sin Red`) sin emojis.
---

### [2026-07-21 21:50] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** SoluciÃ³n integral al filtrado de eventos `DELETE` en Realtime y sincronizaciÃ³n automÃ¡tica de UI al regresar a primer plano. Ajuste en `RealtimeCoordinator.cumpleFiltro` para permitir eventos `PostgresAction.Delete` aun cuando la columna de filtro no estÃ© en `oldRecord` (debido a `REPLICA IDENTITY DEFAULT`), e integraciÃ³n de resincronizaciÃ³n silenciosa HTTP (`refrescarSilencioso`) en `HomeScreen` ante el evento de ciclo de vida `ON_RESUME`.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeScreen.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: `RealtimeCoordinator.cumpleFiltro` permite el paso de `PostgresAction.Delete` aunque `value` sea nulo, permitiendo que `HomePaymentsManager.eliminarNotificacion` remueva las notificaciones borradas de la interfaz en tiempo real.
  - [x] AC 2: `HomeViewModel` expone `refrescarSilencioso()`, ejecutando `sincronizarPagosInterno()` por HTTP REST sin mostrar spinners invasivos de carga.
  - [x] AC 3: `HomeScreen` reacciona a `Lifecycle.Event.ON_RESUME` mediante `DisposableEffect`, resincronizando la lista de pagos de forma transparente cada vez que la app vuelve a primer plano.
---

### [2026-07-21 21:21] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** ImplementaciÃ³n de sincronizaciÃ³n por Catch-Up automÃ¡tico en segundo plano ante desconexiones o arranque en frÃ­o. DetecciÃ³n automÃ¡tica al conectarse/reconectarse a la red mediante consulta HTTP REST (`obtenerPagosDelDia`), filtrado de pagos no procesados a travÃ©s de `userPrefs.notificadosIds` y lectura secuencial de los mismos.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: `CentinelaRealtimeManager` observa transiciones a `ConnectionStatus.CONNECTED` del socket para disparar Catch-Up.
  - [x] AC 2: Se consulta a la base de datos vÃ­a HTTP REST (`obtenerPagosDelDia`) para recopilar las notificaciones del dÃ­a.
  - [x] AC 3: Los pagos pendientes se filtran contra la cachÃ© DataStore persistente local, asegurando procesar Ãºnicamente aquellos omitidos durante el periodo offline.
  - [x] AC 4: Los pagos omitidos se reproducen secuencialmente (vibraciÃ³n y voz en cola) de forma inmediata al recuperar la red.
---










 
 
---
### [2026-07-24 20:25] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Optimización y Estabilización del Orquestador Realtime para evitar bucles infinitos de reconexión y cierres silenciosos (OOM/ANR).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La reconexión delega en el backoff exponencial de Supabase evitando bucles de hardReset automáticos en background.
  - [x] AC 2: Se despiertan los canales ZOMBIE correctamente al pasar a Foreground.
  - [x] AC 3: El canal de vibración y voz no acumula elementos infinitos ni produce ANR.
---

---
### [2026-07-24 21:30] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Implementación de opción configurable para Notificaciones Emergentes Pop-Up (Heads-Up) sobre otras aplicaciones.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [UserPreferencesRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/UserPreferencesRepository.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeScreen.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Adición del Switch  Alertas Emergentes Pop-Up en la pestaña de Configuración.
  - [x] AC 2: Creación del canal de alta importancia (ALERTS_HEADS_UP_CHANNEL_ID) para proyectar tarjetas flotantes sobre otras apps.
  - [x] AC 3: Preservación de la preferencia persistente en DataStore (isHeadsUpEnabled).
---

---
### [2026-07-24 22:10] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Rediseño UI/UX con Carrusel de Encabezado con flechas e íconos de información contextual (i) con diálogos modales.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CommonHomeComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/CommonHomeComponents.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Creación de CarouselHeader e InfoExplanationDialog en CommonHomeComponents.kt.
  - [x] AC 2: Reemplazo de sub-pestañas en Notificaciones por carrusel navegable con títulos explicativos ( Disponibles para Reclamar y Tomadas por Otros Vendedores).
  - [x] AC 3: Renombrado de pestañas principales en Mi Registro (Mis Ventas y Pagos en Conflicto) y carrusel de sub-estados (En Revisión por Admin, Resueltos a Mi Favor, Asignados a Otro Vendedor).
---

---
### [2026-07-24 22:21] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Refinamiento de diseño UI/UX: Carrusel Full-Width de borde a borde (sin márgenes ni aspecto de botón) y unificación total en Mi Registro.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CommonHomeComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/CommonHomeComponents.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Rediseño de CarouselHeader para extenderse de borde a borde de la pantalla (full-width).
  - [x] AC 2: Eliminación de TabRow tradicional en Mi Registro e integración de carrusel Nivel 1 ( Mis Ventas del Día vs Pagos en Conflicto).
  - [x] AC 3: Mantenimiento de carrusel Nivel 2 en Pagos en Conflicto con diálogos informativos contextuales.
---

---
### [2026-07-24 22:33] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Eliminación de ícono (i), aplicación de color morado temático en Nivel 1 de Mi Registro y solución a bug de visibilidad de notificaciones por isNullOrBlank.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CommonHomeComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/CommonHomeComponents.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt), [HomeStateProvider.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeStateProvider.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Eliminación del botón (i) y ventana modal InfoExplanationDialog en CarouselHeader.
  - [x] AC 2: Aplicación del color morado (primary) en el carrusel de nivel 1 de Mi Registro.
  - [x] AC 3: Corrección de la validación IdUsuarioGanador.isNullOrBlank() en HomeStateProvider.kt haciendo visibles los pagos disponibles.
---

---
### [2026-07-24 23:12] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Ajustes de UI: Color azul en Pagos en Conflicto y expansión de ancho de modales HomeDetailModal a casi todo el ancho de pantalla.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt), [CommonHomeComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/CommonHomeComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Aplicación del color azul (0xFF2196F3) a Pagos en Conflicto en el nivel 1 de Mi Registro.
  - [x] AC 2: Configuración de DialogProperties(usePlatformDefaultWidth = false) en HomeDetailModal expandiendo el ancho con márgenes de 20dp.
---

---
### [2026-07-24 23:26] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Reordenamiento de navegacion principal (Notificaciones primero por defecto, Mi Registro segundo) y hardware de dispositivo actual en Configuración.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [HomeNavigationComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/HomeNavigationComponents.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeScreen.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Reordenamiento de barra de navegación: Notificaciones (0), Mi Registro (1), Configuración (2).
  - [x] AC 2: Notificaciones se establece como la vista inicial por defecto al ingresar a la pantalla principal.
  - [x] AC 3: Hardware en Información del Sistema muestra la marca y modelo en vivo del dispositivo en uso (Build.MANUFACTURER y Build.MODEL).
---

---
### [2026-07-24 23:36] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Adición de indicador de vista/página tipo pill (1/2, 2/2 en Nivel 1 y 1/3, 2/3, 3/3 en Nivel 2) en todos los carruseles.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CommonHomeComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/CommonHomeComponents.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Implementación del parámetro pageIndicator en CarouselHeader renderizando una pill discreta.
  - [x] AC 2: Notificaciones muestra 1/2 y 2/2.
  - [x] AC 3: Mi Registro Nivel 1 muestra 1/2 y 2/2; Nivel 2 muestra 1/3, 2/3 y 3/3.
---

---
### [2026-07-25 08:03] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Reemplazo de indicadores numericos (1/2, 1/3) por iconos tematicos al inicio del titulo en los carruseles.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CommonHomeComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/CommonHomeComponents.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Reemplazo del parámetro pageIndicator por leadingIcon: ImageVector en CarouselHeader.
  - [x] AC 2: Notificaciones asigna Notifications y Person.
  - [x] AC 3: Mi Registro asigna ShoppingCart, Warning en Nivel 1 y Refresh, CheckCircle, Close en Nivel 2.
---

---
### [2026-07-26 14:45] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripcin:** Implementacin de cola unificada de notificaciones, ritmo dinmico, catch-up silencioso, escrituras en batch DataStore, modo tradicional de notificaciones en cortina Android y auto-limpieza/reset del badge al abrir el app.
* **Detalles Tcnicos:**
  - **Archivos Modificados:** [NotificationQueueManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/NotificationQueueManager.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt), [UserPreferencesRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/UserPreferencesRepository.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt)
  - **Base de Datos:** Ninguno (Optimizacin DataStore local batch).
* **Criterios de Aceptacin (AC) Validados:**
  - [x] AC 1: Catch-Up silencioso de pagos del da al reconectar sin sonar ni generar pop-ups.
  - [x] AC 2: Ritmo dinmico TTS y Pop-Up autocancelable que degrada a cortina de notificaciones.
  - [x] AC 3: Modo tradicional instantneo para Voz OFF y Pop-Up OFF con vibracin controlada con debounce.
  - [x] AC 4: Guardado masivo batch en DataStore y ejecuciones en Dispatchers.IO evitando congelamientos UI y deadlocks.
  - [x] AC 5: Auto-limpieza de notificaciones de alerta y reset a 0 del globo contador (badge) al abrir o ingresar a la app.
---
---
### 2026-07-31 12:45 | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Migración del Foreground Service de dataSync a specialUse para evadir restricciones de 6 horas en Android 14.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/AndroidManifest.xml), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Compilación exitosa del build de Debug.
  - [x] AC 2: Prevención del crash ForegroundServiceDidNotStopException.
---

---
### [2026-07-31 23:45] | App/Componente: Viewer | Autor: AGENT_ROLE

* **DescripciÃ³n:** ImplementaciÃ³n de resiliencia en reconexiÃ³n de Realtime (Doze Mode) y cambio de tÃ­tulo de notificaciÃ³n persistente.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeIntegrityManager.kt](file:///../viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeIntegrityManager.kt), [CentinelaService.kt](file:///../viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt), [RealtimeCoordinator.kt](file:///../viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [CentinelaNotificationManager.kt](file:///../viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La app reconecta exitosamente el socket tras la expiraciÃ³n del JWT en Doze mode.
  - [x] AC 2: La notificaciÃ³n persistente muestra ""NotificaPe Viewer: [Caja]"".
---

---
### [2026-08-04 17:16] | App/Componente: viewer | Autor: AGENT_ROLE

* **DescripciÃ³n:** Se hizo opcional la restricciÃ³n obligatoria de optimizaciÃ³n de baterÃ­a en la pantalla de Permisos CrÃ­ticos (PermissionGuard), aÃ±adiendo un botÃ³n "Omitir" con confirmaciÃ³n y persistencia local, homÃ³logo al desarrollo en la app Admin.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PermissionGuard.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/PermissionGuard.kt)
  - **Base de Datos:** Ninguno (Uso de SharedPreferences "viewer_prefs")
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La pantalla de permisos permite acceder al flujo principal si se omite la restricciÃ³n de baterÃ­a.
  - [x] AC 2: Se lanza un AlertDialog solicitando confirmaciÃ³n explÃ­cita para omitir.
  - [x] AC 3: El botÃ³n "Omitir" respeta la guÃ­a visual oscura y las dimensiones del botÃ³n primario "Activar".
---
---
### [2026-08-17 15:00] | App/Componente: viewer | Autor: AGENT_ROLE

* **DescripciÃ³n:** ImplementaciÃ³n de flujo alternativo de Login Manual para revisiÃ³n en Google Play Console.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/domain/repository/AuthRepository.kt), [AuthRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/AuthRepositoryImpl.kt), [LoginViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/login/LoginViewModel.kt), [LoginScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/login/LoginScreen.kt)
  - **Base de Datos:** Se generÃ³ el script 0040_viewer_bypass_account.sql para inyectar la cuenta google-review@notificape.pe en auth.users, public.Usuarios y AutorizacionesXUsuario.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La UI de Login puede intercambiarse condicionalmente a una vista manual.
  - [x] AC 2: Se implementÃ³ autenticaciÃ³n por email con Supabase Auth respetando el enrutamiento reactivo de la app.
---

---
### [2026-08-17 16:40] | App/Componente: Viewer | Autor: AGENT_ROLE

* **Descripción:** Refinamiento de acentos visuales y opacidades (Verde Esmeralda) en dashboard y componentes comunes para diferenciar identidad de Viewer.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [LoginScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/login/LoginScreen.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt), [BreakdownComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/BreakdownComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt), [VinculacionHeader.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/VinculacionHeader.kt), [CajasSelectorScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/vinculacion/CajasSelectorScreen.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Componentes seleccionados aplican color secundario (Verde) con contraste semántico.
  - [x] AC 2: Se mantiene el color primario morado en la estructura general y switches por defecto.
---
