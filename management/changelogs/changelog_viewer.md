# Changelog de AplicaciÃ³n Viewer

Este archivo contiene el historial de cambios a nivel de UI, lÃ³gica y configuraciÃ³n de la aplicaciÃ³n mÃ³vil **NotificaPe Viewer**.

---
### 2026-07-08 12:50 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** RemociÃ³n de la verificaciÃ³n y solicitud obligatoria de optimizaciÃ³n de baterÃ­a para cumplir con las polÃ­ticas de Google Play Store.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PermissionGuard.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/PermissionGuard.kt), [SistemaComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/SistemaComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se remueve la verificaciÃ³n de optimizaciÃ³n de baterÃ­a del guardiÃ¡n de permisos (`PermissionGuard.kt`), eliminando el bloqueo que impedÃ­a el ingreso al dashboard sin desactivar el ahorro de energÃ­a.
  - [x] AC 2: Se remueve el Ã­tem "Sin RestricciÃ³n de BaterÃ­a" en la interfaz grÃ¡fica del onboarding de permisos.
  - [x] AC 3: Se elimina por completo el banner de advertencia `BatteryOptimizationShield` de la interfaz de configuraciÃ³n del sistema (`SistemaComponents.kt`).
  - [x] AC 4: La compilaciÃ³n del cÃ³digo Kotlin de la aplicaciÃ³n mÃ³vil se completa exitosamente sin errores sintÃ¡cticos o referencias huÃ©rfanas.
---

---
### 2026-07-08 13:00 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** CorrecciÃ³n de firmado digital en configuraciÃ³n Gradle para resolver BadPaddingException.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se sustituye el keystore incorrecto `key1.jks` por `key_viewer.jks` en la configuraciÃ³n de `signingConfigs` y `buildTypes` (debug/release) del mÃ³dulo de la aplicaciÃ³n.
  - [x] AC 2: Se confirma que el descifrado de las credenciales configuradas en `local.properties` funciona correctamente, resolviendo el error `BadPaddingException` durante el empaquetado y firmado de la APK.
---
---
### 2026-07-12 15:40 | App/Componente: NotificaPe_Admin / NotificaPe_Viewer | Autor: AGENT_ROLE (Arquitecto/DevOps)

* **DescripciÃ³n:** ImplementaciÃ³n de pipeline de CI/CD automatizado con autoincremento de versionCode en GitHub Actions para despliegue en Google Play Store.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [deploy.yml (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/deploy.yml), [release-please.yml (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/release-please.yml), [deploy.yml (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/.github/workflows/deploy.yml), [release-please.yml (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/.github/workflows/release-please.yml), [build.gradle.kts (admin)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/build.gradle.kts), [build.gradle.kts (viewer)](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Configurado el pipeline `deploy.yml` para compilar el bundle AAB firmado y subir de forma automatizada al canal de Pruebas Internas de Google Play Store.
  - [x] AC 2: Implementado script de Python nativo en el workflow que consulta a la API de Google Play la Ãºltima versiÃ³n cargada en el track y realiza el autoincremento dinÃ¡mico de `versionCode` (+1) en caliente para evitar errores de duplicidad.
  - [x] AC 3: Configurado el pipeline `release-please.yml` para automatizar la gestiÃ³n de versiones pÃºblicas e historial de cambios a partir de Conventional Commits.
  - [x] AC 4: Subido exitosamente a la Google Play Store mediante ejecuciÃ³n manual en GitHub Actions (`versionCode = 3`).
---

---
### 2026-07-14 12:10 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** Mapeo detallado de excepciones de Credential Manager en pantalla de Login para diagnÃ³stico remoto [CR-003].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [LoginScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/login/LoginScreen.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se refactorizÃ³ el bloque `catch` de `GetCredentialException` para interceptar de forma explÃ­cita las subclases `GetCredentialCancellationException`, `NoCredentialException`, `GetCredentialInterruptedException` y `GetCredentialProviderConfigurationException`.
  - [x] AC 2: Se proveen mensajes detallados y especÃ­ficos en pantalla de error en lugar del texto genÃ©rico estÃ¡tico de cancelaciÃ³n para facilitar el soporte remoto en dispositivos como Magic OS.
  - [x] AC 3: La compilaciÃ³n del cÃ³digo Kotlin se completa exitosamente tras la integraciÃ³n sintÃ¡ctica.
---

---
### 2026-07-14 12:35 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** ImplementaciÃ³n de resiliencia de Realtime, reconexiÃ³n fÃ­sica de red y sincronizaciÃ³n delta dinÃ¡mica [CR-004].
* **Detalles TÃ©cnicos:**
  - **Archivos Creados:** [NetworkMonitor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/util/NetworkMonitor.kt)
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [SyncScavenger.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/SyncScavenger.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se integrÃ³ `NetworkMonitor` para registrar cambios de red fÃ­sica a nivel de sistema operativo y forzar `hardReset()` al recuperar internet.
  - [x] AC 2: Se implementÃ³ un reset preventivo automÃ¡tico (`hardReset()`) al volver a primer plano tras inactividad prolongada (>15s) para limpiar canales zombis.
  - [x] AC 3: Se desacoplÃ³ la sincronizaciÃ³n delta (`performDeltaSync`) del cambio sÃ­ncrono de visibilidad, gatillÃ¡ndose ahora Ãºnicamente tras el Ã©xito del estado `SUBSCRIBED` del canal de notificaciones.
  - [x] AC 4: Se calcula de forma dinÃ¡mica el buffer de tiempo en el Scavenger segÃºn los segundos transcurridos en background (con un piso mÃ­nimo de 5 minutos).
  - [x] AC 5: La compilaciÃ³n del mÃ³dulo Android finalizÃ³ exitosamente sin errores de inyecciÃ³n Hilt.
---

---
### 2026-07-14 13:10 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** Robustecimiento de reconexiÃ³n Realtime mediante exclusiÃ³n mutua, auto-suscripciÃ³n y desconexiÃ³n preventiva [CR-004 v2].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se integrÃ³ `profileMutex: Mutex` para encapsular de forma atÃ³mica y secuencial el cambio de perfiles en `setProfile` y la ejecuciÃ³n de `hardReset()`.
  - [x] AC 2: Se implementÃ³ un observador en `observeSocketStatus` que detecta la reconexiÃ³n fÃ­sica del socket de Supabase (`CONNECTED`) y gatilla de forma proactiva `hardReset()`, asegurando que todos los canales se re-suscriban en el servidor.
  - [x] AC 3: Se programÃ³ una desconexiÃ³n preventiva del socket WebSocket mediante `supabaseClient.realtime.disconnect()` al perder la red fÃ­sica (`isOnline == false`) para mantener en sincronÃ­a la mÃ¡quina de estados local con el hardware.
  - [x] AC 4: Se removiÃ³ la variable miembro obsoleta `profileJob`.
  - [x] AC 5: CompilaciÃ³n exitosa del build debug sin errores de Kotlin, dependencias Hilt o sintaxis.
---

---
### 2026-07-14 13:30 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** IntegraciÃ³n de Offline Banner animado superior para visibilidad de conectividad [CR-004 v2.1].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [HomeNavigationComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/HomeNavigationComponents.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se integrÃ³ `AnimatedVisibility` con efectos de deslizamiento/expansiÃ³n vertical en `HomeTopBar` para mostrar/ocultar el banner de red.
  - [x] AC 2: Se escucha el estado de `connectionStatus` para pintar el banner en color rojo ("Sin conexiÃ³n a Internet") en `DISCONNECTED` y amarillo/secundario ("Restableciendo enlace...") en `CONNECTING`.
  - [x] AC 3: El banner se oculta por completo de forma limpia en el estado `CONNECTED` o `SYNCING`, eliminando bloqueos visuales molestos.
  - [x] AC 4: Se respeta el padding superior de la barra de estado del sistema (`statusBarsPadding()`) evitando superposiciones.
  - [x] AC 5: CompilaciÃ³n Gradle debug exitosa en 1m 7s.
---

---
### 2026-07-14 14:00 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** SoluciÃ³n definitiva de bucles de reconexiÃ³n y estabilizaciÃ³n de perfiles al regresar de background [CR-004 v2.2].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se implementÃ³ un debounce temporal de 2000ms en `hardReset()` mediante la propiedad `lastResetTime` para descartar resets concurrentes y redundantes.
  - [x] AC 2: Se aÃ±adiÃ³ el parÃ¡metro opcional `forceProfile` a `hardReset()`. Al volver de background, se fuerza el perfil completo `RealtimeProfile.OPERATIONAL_FULL` para asegurar que no se quede estancado en el perfil de ahorro `CENTINELA_MINIMAL`.
  - [x] AC 3: Se introdujo la variable de estado miembro de clase `wasConnectedOnce` para discernir reconexiones fÃ­sicas genuinas del socket de la primera conexiÃ³n inicial limpia.
  - [x] AC 4: Se limpia `wasConnectedOnce = false` al apagar la sesiÃ³n en `detenerTodo()`.
  - [x] AC 5: CompilaciÃ³n exitosa del build debug en 1m 50s.
---

---
### 2026-07-14 15:05 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** ImplementaciÃ³n de observaciones y justificaciones en el flujo de reclamos y disputas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [NotificacionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/NotificacionComponents.kt), [ControlComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/components/ControlComponents.kt)
  - **Base de Datos:** HabilitaciÃ³n de `p_justificacion` en la llamada de la RPC `reclamar_notificacion_v2`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Habilitado el envÃ­o de `"p_justificacion"` en la llamada del RPC en `reclamarPago` de `PagosRemoteDataSource.kt`.
  - [x] AC 2: Se calcula dinÃ¡micamente `EsPropietario` en `obtenerMisConflictos` determinando el primer reclamante en base a la `FechaReg` mÃ­nima, resolviendo el valor nulo de `IdUsuarioGanador` en disputas.
  - [x] AC 3: Agregado un `OutlinedTextField` opcional en `ConfirmacionReclamoDialog` que pasa la observaciÃ³n ingresada al reclamo inicial.
  - [x] AC 4: Se actualizaron etiquetas, placeholders e informaciÃ³n del modal de disputas en `ControlComponents.kt` para reflejar con precisiÃ³n el rol y permitir el ingreso de descargos (defensas) para dueÃ±os originales e impugnadores.
  - [x] AC 5: CompilaciÃ³n Gradle exitosa en 1m 53s.
---

---
### 2026-07-14 15:15 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** Persistencia real y visualizaciÃ³n de observaciones en el detalle de ventas cobradas [CR-004 v2.3].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [PagosRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/domain/repository/PagosRepository.kt), [PagosRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/data/repository/PagosRepositoryImpl.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeScreen.kt)
  - **Base de Datos:** CreaciÃ³n de la RPC `actualizar_observacion_reclamo`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se integrÃ³ la RPC `actualizar_observacion_reclamo` con `SECURITY DEFINER` para actualizar la columna `Observacion` en `NotificacionesAUsuarios` sin restricciones de estado (funciona en `'APROBADO'`).
  - [x] AC 2: Se implementÃ³ un cruce de datos en lote en `obtenerPagosDelDia` para poblar en memoria la propiedad `Observacion` del objeto de dominio `Notificacion` leyendo de `NotificacionesAUsuarios`.
  - [x] AC 3: Se habilitÃ³ la persistencia real del TextField de observaciÃ³n en el modal de detalle de venta del dashboard en la pestaÃ±a "Ventas", redireccionÃ¡ndolo a la nueva RPC de actualizaciÃ³n.
  - [x] AC 4: CompilaciÃ³n Gradle debug exitosa en 3m 23s.
---

---
### 2026-07-14 15:50 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** SoluciÃ³n a defensas de dueÃ±os en disputas, visibilidad de ventas resueltas y resoluciÃ³n del limbo transaccional en anulaciÃ³n de reclamos [CR-004 v2.4].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PagosRemoteDataSource.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/datasource/PagosRemoteDataSource.kt), [HomeStateProvider.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/ui/home/HomeStateProvider.kt)
  - **Base de Datos:** CreaciÃ³n de la RPC `actualizar_justificacion_reclamo` e implementaciÃ³n de la RPC `retirar_reclamo_v4` en el script `0029_rpc_observacion_justificacion_reclamos.sql` en specs.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Se implementÃ³ la RPC `actualizar_justificacion_reclamo` con `SECURITY DEFINER` para permitir el guardado de defensas (justificaciones de conflicto) en la columna `JustificacionConflicto` evitando bloqueos por RLS de `UPDATE`.
  - [x] AC 2: Se modificÃ³ la query en `actualizarJustificacion` para utilizar la nueva RPC en lugar de la consulta REST directa.
  - [x] AC 3: Se corrigiÃ³ el filtro de `misVentas` en `HomeStateProvider.kt` sustituyendo `!it.enDisputa` por `it.EstadoProgreso != "REVISION"`. Esto permite volver a listar en la pestaÃ±a "Ventas" aquellos pagos cuyas disputas fueron resueltas a favor del usuario (`COMPLETADO`).
  - [x] AC 4: Se diseÃ±Ã³ e implementÃ³ la RPC `retirar_reclamo_v4` para solventar el limbo transaccional: si el dueÃ±o original o el impugnante anula su participaciÃ³n, el pago se reasigna automÃ¡ticamente al participante restante (completando la venta a su favor) o se libera completamente a `PENDIENTE` si no queda nadie.
  - [x] AC 5: CompilaciÃ³n Gradle debug exitosa en 1m 39s.
---

---
### 2026-07-21 00:23 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **DescripciÃ³n:** RefactorizaciÃ³n a Foreground Service con START_STICKY, Bypass de OptimizaciÃ³n de BaterÃ­a, telemetrÃ­a y Text-To-Speech (TTS) nativo.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/AndroidManifest.xml), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [UserPreferencesRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/UserPreferencesRepository.kt), [PermissionGuard.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/common/PermissionGuard.kt)
  - **Archivos Creados:** [TtsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/manager/TtsManager.kt), [BootReceiver.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/BootReceiver.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: CentinelaService migrado a Foreground Service (LifecycleService) con START_STICKY.
  - [x] AC 2: TelemetrÃ­a de DiagnosticsManager integrada y mostrada en NotificaciÃ³n Persistente.
  - [x] AC 3: TtsManager y Vibrator implementados para notificar en vivo pagos recibidos.
  - [x] AC 4: BootReceiver implementado para auto-reconexiÃ³n tras reinicio.
  - [x] AC 5: Controles de UI para TTS y VibraciÃ³n en SistemaTab, y peticiÃ³n nativa de Bypass de baterÃ­a.
------
### 2026-07-21 22:30 | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Restauración del flujo de eventos Insert en RealtimeCoordinator (cumpleFiltro) para reparar las alertas en segundo plano (TTS y Vibración) de nuevas notificaciones [CR-008].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: `cumpleFiltro` en `RealtimeCoordinator.kt` restituye la validación de igualdad (`value == targetValue`), permitiendo el flujo de eventos `PostgresAction.Insert`.
  - [x] AC 2: Se verificó que las inserciones ahora pasan la validación, desencadenando notificaciones, TTS y Vibración mediante `CentinelaRealtimeManager` incluso con la aplicación en segundo plano.
  - [x] AC 3: Compilación Gradle debug exitosa confirmada.
---

### [2026-07-21 13:00] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE

* **Descripción:** Fijado de notificación persistente, solución a colapso de canal y fixes de ráfagas TTS.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [TtsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/manager/TtsManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La notificación se mantiene expandida y el Foreground Service es resiliente en background.
  - [x] AC 2: Las notificaciones en ráfagas de pruebas generan múltiples mensajes TTS sin cortarse.
---

### [2026-07-21 16:00] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Solución a alertas duplicadas por reconexión/Delta Sync, fix de crash por permiso de vibración, desactivación inmediata de TTS y silenciado de burbujas heads-up. Implementación de vibración sincronizada a la voz (UtteranceProgressListener) y cola secuencial de vibración asíncrona (Voz OFF). Corrección del estado "Sincronizando..." atascado al minimizar (unsubscription asíncrona), traslado de la notificación persistente fuera de la sección de silenciosas (Canal v3 con IMPORTANCE_DEFAULT), visualización del Pulso Global en el Panel de Diagnóstico, y limpieza de caché de pagos notificados al desvincular.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/AndroidManifest.xml), [MainActivity.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/MainActivity.kt), [CentinelaService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaService.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt), [DiagnosticsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/DiagnosticsManager.kt), [RealtimeDiagnostics.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/model/RealtimeDiagnostics.kt), [TtsManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/manager/TtsManager.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [UserPreferencesRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/UserPreferencesRepository.kt), [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt), [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [RealtimeAuditDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/realtime/components/RealtimeAuditDialog.kt), [AuthRepositoryImpl.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/repository/AuthRepositoryImpl.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: El apagado de TTS detiene la reproducción actual y limpia la cola de inmediato.
  - [x] AC 2: La vibración se sincroniza al habla (*Vibra ➔ Voz Pago A ➔ Vibra ➔ Voz Pago B*) cuando ambos switches están encendidos.
  - [x] AC 3: Con la Voz desactivada y Vibración activa, los pagos consecutivos generan vibraciones secuenciales limpias (separadas por 1.5s).
  - [x] AC 4: El cache de deduplicación de IDs de pago (hasta 100) en DataStore previene duplicación en reconexiones.
  - [x] AC 5: Al desvincular la caja, se limpia el historial de duplicados para permitir re-testeo limpio.
  - [x] AC 6: Al minimizar la app o hacer swipe, la notificación persistente cambia a "Conectado ✅" de inmediato (no se queda en Sincronizando...).
  - [x] AC 7: La notificación persistente ahora aparece en la sección Activa del panel de Android (fuera de Silenciosas) gracias al canal v3 con IMPORTANCE_DEFAULT.
  - [x] AC 8: El Panel de Diagnóstico muestra la métrica "PULSO: Xs" en tiempo real al igual que en Admin.
---

### [2026-07-21 17:30] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Solución al bug de des-registro de IDs de dispositivo y usuario al minimizar la app (`setAppVisibility`). Garantía de inmutabilidad del canal de notificaciones en background sin reinicios ni caídas a 'Sincronizando...'.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Al pasar a segundo plano (`CENTINELA_MINIMAL`), se preserva el `idDispositivo` activo, evitando reconstruir o cancelar la suscripción a `NotificacionesXDispositivo`.
  - [x] AC 2: La notificación persistente mantiene su estado en `En Línea ✅` (o `Conectado ✅`) al minimizar.
  - [x] AC 3: Los pagos generados desde el Admin se escuchan y notifican instantáneamente sin retrasos ni colas diferidas en segundo plano.
---

### [2026-07-21 17:45] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Solución al bucle de desintegración de socket provocado por `hardReset()` en `observeSocketStatus()`, y homologación exacta de los textos de la notificación persistente con la píldora de la UI (`En Línea`, `Conectando`, `Sincronizando`, `Sin Red`).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La notificación persistente usa exactamente los textos del PIL (`En Línea ✅`, `Sin Red ⚠️`, `Conectando... 🔄`, `Sincronizando... 🔄`).
  - [x] AC 2: Se eliminó el bucle recursivo de `hardReset()` al conectar el socket; las reconexiones verdaderas re-suscriben canales in-place sin tirar abajo el socket.
  - [x] AC 3: Al cambiar de app o minimizar, el Viewer se mantiene `En Línea ✅` y procesa los eventos entrantes sin latencia ni pérdida de notificaciones.
---

### [2026-07-21 18:45] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Corrección de condición de carrera en el inicio del socket y alineación estricta con el patrón pasivo de la app Admin. `setProfile` queda como único dueño de la suscripción de canales; se removió la re-suscripción paralela desde `observeSocketStatus`.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [CentinelaNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaNotificationManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Al iniciar la app, la conexión completa limpia a `En Línea` sin caer en `Sin Red` ni `Sin conexión a Internet`.
  - [x] AC 2: `observeSocketStatus` opera como observador pasivo de salud (igual que en Admin `setupStatusMonitoring`), sin disputar llamadas a `iniciarCanal`.
  - [x] AC 3: La notificación persistente y el PIL de UI muestran cadenas sobrias exactas (`En Línea`, `Conectando...`, `Sincronizando...`, `Sin Red`) sin emojis.
---

### [2026-07-21 21:50] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Solución integral al filtrado de eventos `DELETE` en Realtime y sincronización automática de UI al regresar a primer plano. Ajuste en `RealtimeCoordinator.cumpleFiltro` para permitir eventos `PostgresAction.Delete` aun cuando la columna de filtro no esté en `oldRecord` (debido a `REPLICA IDENTITY DEFAULT`), e integración de resincronización silenciosa HTTP (`refrescarSilencioso`) en `HomeScreen` ante el evento de ciclo de vida `ON_RESUME`.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [RealtimeCoordinator.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/data/realtime/RealtimeCoordinator.kt), [HomeViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeViewModel.kt), [HomeScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/ui/home/HomeScreen.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: `RealtimeCoordinator.cumpleFiltro` permite el paso de `PostgresAction.Delete` aunque `value` sea nulo, permitiendo que `HomePaymentsManager.eliminarNotificacion` remueva las notificaciones borradas de la interfaz en tiempo real.
  - [x] AC 2: `HomeViewModel` expone `refrescarSilencioso()`, ejecutando `sincronizarPagosInterno()` por HTTP REST sin mostrar spinners invasivos de carga.
  - [x] AC 3: `HomeScreen` reacciona a `Lifecycle.Event.ON_RESUME` mediante `DisposableEffect`, resincronizando la lista de pagos de forma transparente cada vez que la app vuelve a primer plano.
---

### [2026-07-21 21:21] | App/Componente: NotificaPe_Viewer | Autor: AGENT_ROLE (Programador Especializado)

* **Descripción:** Implementación de sincronización por Catch-Up automático en segundo plano ante desconexiones o arranque en frío. Detección automática al conectarse/reconectarse a la red mediante consulta HTTP REST (`obtenerPagosDelDia`), filtrado de pagos no procesados a través de `userPrefs.notificadosIds` y lectura secuencial de los mismos.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CentinelaRealtimeManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/viewer/app/src/main/java/com/notificape/viewer/service/CentinelaRealtimeManager.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: `CentinelaRealtimeManager` observa transiciones a `ConnectionStatus.CONNECTED` del socket para disparar Catch-Up.
  - [x] AC 2: Se consulta a la base de datos vía HTTP REST (`obtenerPagosDelDia`) para recopilar las notificaciones del día.
  - [x] AC 3: Los pagos pendientes se filtran contra la caché DataStore persistente local, asegurando procesar únicamente aquellos omitidos durante el periodo offline.
  - [x] AC 4: Los pagos omitidos se reproducen secuencialmente (vibración y voz en cola) de forma inmediata al recuperar la red.
---









 
 