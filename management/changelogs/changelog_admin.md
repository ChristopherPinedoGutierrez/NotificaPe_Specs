---
### [2026-10-04 16:15] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Implementación de CropActivity con gestión dinámica de WindowInsets para resolver solapamiento Edge-to-Edge con la barra de estado y barra de navegación en recorte de QR de billeteras.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [CropActivity.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/crop/CropActivity.kt), [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/AndroidManifest.xml), [WalletsComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/WalletsComponents.kt), [values-v35/themes.xml](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/res/values-v35/themes.xml)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Creación de CropActivity heredando de UCropActivity y aplicación dinámica de systemBars + displayCutout insets en Toolbar y contenedor inferior.
  - [x] AC 2: Redirección transparente de uCropIntent hacia CropActivity en WalletsComponents manteniendo todas las opciones previas y handlers intactos.
  - [x] AC 3: Eliminación de bandera obsoleta de opt-out Edge-to-Edge en values-v35/themes.xml para compatibilidad con targetSdk 36.
  - [x] AC 4: Compilación exitosa de debug (assembleDebug) generando app-debug.apk sin errores.
---
---
### [2026-09-07 18:25] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Migración completa de WebSockets (Realtime) a FCM (Push-to-Pull) en Android, eliminando Supabase Realtime para mayor resiliencia.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [FCMReceiverService.kt](file:///../admin/app/src/main/java/com/notificape/admin/service/FCMReceiverService.kt), [DashboardViewModel.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [SyncRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/SyncRepository.kt), [BlockedScreen.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/auth/BlockedScreen.kt)
  - **Base de Datos:** Ninguno (Manejado en script DB)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Desacoplamiento de Supabase Realtime y adopción de receptor FCM con parseo de payloads SYNC_NOTIFICATIONS, SYNC_RULES.
  - [x] AC 2: Refactorización de lógicas de carga en caliente (startOfDay) en SyncRepository para soportar actualizaciones retrospectivas de notificaciones mediante push.
  - [x] AC 3: Extracción del botón "Verificar Estado" y automatización UI en pantalla de bloqueo.
---
### [2026-09-04 14:05] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** ActualizaciÃ³n obligatoria de compileSdk y targetSdk a API 36 (Android 16) para cumplimiento de normativas de Google Play Store y sincronizaciÃ³n de acciÃ³n setup-android en el pipeline CI/CD.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [app/build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/build.gradle.kts), [.github/workflows/deploy.yml](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/deploy.yml)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: compileSdk y targetSdk actualizados a 36 en admin/app/build.gradle.kts.
  - [x] AC 2: Pipeline deploy.yml sincronizado con la acciÃ³n android-actions/setup-android@v3.
  - [x] AC 3: Despliegue automÃ¡tico de Release Please y subida exitosa de paquete AAB con targetSdk 36 a Google Play Console (Prueba Interna).
---
---
### [2026-08-10 16:05] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** CorrecciÃ³n del mapeo del parÃ¡metro tipoFiltro en el simulador TestLabHandler para asegurar la correcta inyecciÃ³n y funcionamiento de las reglas de EXCLUSIÃ“N en los tests locales, y explicaciÃ³n arquitectural del filtro visual de privacidad para notificaciones en estado REVISION.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [TestLabHandler.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Las notificaciones mock que coinciden con una regla de EXCLUSION son truncadas correctamente y retornan emptyList en el simulador.
  - [x] AC 2: La compilaciÃ³n Kotlin/KSP fue exitosa.
---
# Changelog AtÃƒÂ³mico - App: Admin

---
### 2026-07-22 12:25 | App/Componente: admin | Autor: Programador Especializado (IA)

* **DescripciÃƒÂ³n:** Habilitar configuraciÃƒÂ³n de Presence en la creaciÃƒÂ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [AuthRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/AuthRealtimeHandler.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: La compilaciÃƒÂ³n del aplicativo es exitosa tras aplicar la configuraciÃƒÂ³n de Presence en el builder del canal.
  - [x] AC 2: La suscripciÃƒÂ³n a cambios Postgres existente en el canal permanece inalterada y funcional.
---

---
### 2026-07-25 16:15 | App/Componente: admin | Autor: Programador Especializado (IA)

* **DescripciÃƒÂ³n:** ImplementaciÃƒÂ³n de nuevo loader inicial (LoadingOverlay estÃƒÂ¡tico) y sistema de autolimpieza configurable de notificaciones bancarias procesadas.
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [LoadingOverlay.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/LoadingOverlay.kt), [CheckAuthScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/CheckAuthScreen.kt), [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [SettingsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/SettingsSection.kt), [NotificationProcessor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationProcessor.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Base de Datos:** Ninguno (Uso de DataStore local `user_settings`)
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: El nuevo loader `LoadingOverlay` con ÃƒÂ­cono estÃƒÂ¡tico se muestra correctamente al inicializar sesiÃƒÂ³n en la app Admin.
  - [x] AC 2: El switch de Limpieza AutomÃƒÂ¡tica estÃƒÂ¡ presente en ConfiguraciÃƒÂ³n (activo por defecto) con modal de confirmaciÃƒÂ³n al cambiar su estado.
  - [x] AC 3: Las notificaciones provenientes de billeteras activas se remueven automÃƒÂ¡ticamente del status bar sin romper la captura ni el guardado de notificaciones en estado PENDIENTE o REVISION.
---


---
### [2026-07-26 09:30] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃƒÂ³n:** ImplementaciÃƒÂ³n de soporte para colores dinÃƒÂ¡micos desde Base de Datos (RuleDto y DeviceWalletEntity).
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [DeviceWalletEntity.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/model/DeviceWalletEntity.kt), [RuleDto.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/remote/dto/RuleDto.kt), [WalletRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt), [RuleRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/RuleRepository.kt), [AppDatabase.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt)
  - Se aÃƒÂ±adiÃƒÂ³ \ColorHex\ a DTOs de sincronizaciÃƒÂ³n y a Room, mapeando en RuleRepository. Las Vistas (NotificationItem y WalletsComponents) ya leÃƒÂ­an de WalletEntity.colorHex, por lo que heredan el cambio al vuelo. Se elevÃƒÂ³ AppDatabase a la versiÃƒÂ³n 10.
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: La compilaciÃƒÂ³n Kotlin/KSP fue exitosa sin fallos de parseo de JSON.
---
### [2026-07-26 15:00] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃƒÂ³n:** Actualizaciones visuales en la app Admin: renombrado a 'Notificaciones' / 'Registro de Notificaciones', ensanchamiento y actualizaciÃƒÂ³n del modal de RecaudaciÃƒÂ³n por Billetera.
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [BreakdownDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/BreakdownDialog.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: La navegaciÃƒÂ³n inferior y el tÃƒÂ­tulo principal reflejan 'Notificaciones' y 'Registro de Notificaciones'.
  - [x] AC 2: El modal 'RecaudaciÃƒÂ³n por Billetera' coincide en ancho con el listado principal y actualiza los subtextos a 'notificaciones recibidas'.
---
---
### [2026-07-26 18:20] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripcion:** Parche a la vulnerabilidad de notificaciones zombies (spinner infinito) y starvation (estancadas en nube amarilla sin reintento).
* **Detalles Tecnicos:**
  - **Archivos Modificados:** [SyncRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/SyncRepository.kt), [SyncWorker.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/worker/SyncWorker.kt), [TestLabHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Base de Datos:** Se usa la funcion local resetProcessingStatus.
* **Criterios de Aceptacion (AC) Validados:**
  - [x] AC 1: Las notificaciones atascadas se curan automaticamente al abrir la app.
  - [x] AC 2: Si falla el envio en vivo, se delega un reintento a WorkManager (OneTimeWorkRequest).
---

---
### [2026-07-28 18:09] | App/Componente: Admin (UCrop) | Autor: AGENT_ROLE

* **DescripciÃƒÂ³n:** Se corrige el desbordamiento de contenido debajo de las barras de sistema (Edge-to-Edge) en la vista de recorte de imagen (uCrop) en Android 15.
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [themes.xml (values-v35)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/res/values-v35/themes.xml)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: La actividad de recorte ya no se dibuja detrÃƒÂ¡s de las barras del sistema (status y navigation bars) al aplicar windowOptOutEdgeToEdgeEnforcement.
  - [x] AC 2: La aplicaciÃƒÂ³n compila correctamente (assembleDebug).
---

---
### [2026-08-04 16:58] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃƒÂ³n:** Se hizo opcional la restricciÃƒÂ³n obligatoria de optimizaciÃƒÂ³n de baterÃƒÂ­a en el modal de permisos inicial, permitiendo omitirla mediante un modal de confirmaciÃƒÂ³n y guardando la decisiÃƒÂ³n localmente, para evitar el bloqueo en capas de Android estrictas.
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno (Uso de SharedPreferences locales)
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: El botÃƒÂ³n "Omitir" permite saltar el requerimiento de baterÃƒÂ­a pero requiere confirmaciÃƒÂ³n (AlertDialog).
  - [x] AC 2: La decisiÃƒÂ³n de omitir se guarda en SharedPreferences, persistiendo al reiniciar la app.
---

---
### [2026-08-04 17:36] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃƒÂ³n:** ReducciÃƒÂ³n de dimensiones y espaciado de los botones "Activar" y "Omitir" en la vista de permisos (ajuste visual a 32dp/24dp de altura respectivamente y fix de importaciÃƒÂ³n sp faltante).
* **Detalles TÃƒÂ©cnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃƒÂ³n (AC) Validados:**
  - [x] AC 1: La compilaciÃƒÂ³n del aplicativo es exitosa tras reparar la dependencia faltante (androidx.compose.ui.unit.sp).
  - [x] AC 2: La interfaz grÃƒÂ¡fica presenta botones estÃƒÂ©ticamente compactos y balanceados.
---

---
### [2026-08-06 13:14] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** ImplementaciÃ³n del Motor V2 (desestructuraciÃ³n de mocks en TestLabHandler, guardado de PayloadBruto en JSON para depuraciÃ³n de fallos de regex en estado REVISION, interpolaciÃ³n de variables en FormatoMensaje y actualizaciÃ³n de Room Database a V12).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AppDatabase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt), [ExtractPaymentUseCase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/domain/usecase/ExtractPaymentUseCase.kt), [TestLabHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **Base de Datos:** MigraciÃ³n destructiva de Room a V12 para aÃ±adir payloadBruto a NotificationEntity.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Los mensajes mock con etiquetas [TITLE]/[TEXT] son extraÃ­dos limpiamente por la UI.
  - [x] AC 2: Fallos de regex (REVISION) generan un payload JSON de diagnÃ³stico y lo sincronizan a Supabase.
---


 
 ---
### [2026-09-18 13:20] | App/Componente: admin | Autor: AGENT_ROLE (Orquestador SDD)

* **Descripción:** Corrección de subida asíncrona (NonCancellable), visibilidad de error en limpieza remota y cierre de deuda técnica (IsConnected).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [BacklogGlobal.md](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/BacklogGlobal.md), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [TestLabHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La generación de ráfaga y subida se completan exitosamente (vía NonCancellable) sin bloquearse si se vuelve atrás inmediatamente.
  - [x] AC 2: Se notifica explícitamente en UI si el borrado de pruebas en Supabase falla por error de red.
  - [x] AC 3: Tarea 6.2 finalizada, removiendo variables residuales dependientes de estados visuales FCM obsoletos.
---
---
### [2026-09-18 16:30] | App/Componente: admin | Autor: AGENT_ROLE (Orquestador SDD)

* **Descripción:** Solución a error de duplicación fantasma (mismatch en formato UUID) y erradicación visual/lógica del permiso de optimización de batería.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [ExtractPaymentUseCase.kt](file:///../admin/app/src/main/java/com/notificape/admin/domain/usecase/ExtractPaymentUseCase.kt), [SyncRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/SyncRepository.kt), [SyncRealtimeHandler.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/SyncRealtimeHandler.kt), [TestLabHandler.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt), [PermissionComponents.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt), [MainActivityContent.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Uso de UUID.nameUUIDFromBytes para generar UUID v3 con formato 8-4-4-4-12, permitiendo a Room resolver los conflictos en descargas FullSync por colisión estricta.
  - [x] AC 2: Se removió la supresión de guiones (isLetterOrDigit) en los manejadores de sincronización.
  - [x] AC 3: Componente gráfico y validadores del ciclo de vida que obligaban al permiso de batería fueron completamente borrados sin fallos de sintaxis en MainActivityContent.kt.
---

---
### [2026-09-18 16:40] | App/Componente: admin | Autor: AGENT_ROLE (Orquestador SDD)

* **Descripción:** Eliminación absoluta del componente interactivo de mitigación OEM (OemConfigOverlay) del Dashboard principal.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardScreen.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [DashboardViewModel.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [UserPreferences.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt). Eliminado: OemConfigOverlay.kt.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La UI del Dashboard ya no expone el banner amarillo condicional bajo detección de marcas chinas restrictivas.
  - [x] AC 2: Se purgó la persistencia local DataStore (is_oem_banner_dismissed) para reducir redundancia de estado.
---

---
### [2026-09-27 10:17] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Corrección de parpadeo de permisos y Loader erróneo en instalaciones limpias desactivando Auto-Backup de Android.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [AndroidManifest.xml](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/AndroidManifest.xml), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La app en reinstalación limpia no muestra overlay de permisos ni loader de Desvinculando.
  - [x] AC 2: Se mantiene el comportamiento de auto-expulsión íntegro para sesiones previamente cacheadas o activas.
---

---
### [2026-09-27 10:34] | App/Componente: admin/database | Autor: AGENT_ROLE

* **Descripción:** Corrección de FCM Unlink Trigger y Notificación Persistente Inmortal.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [0043_fcm_tokens_dispositivos.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0043_fcm_tokens_dispositivos.sql), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Base de Datos:** Actualizada la función n_dispatch_fcm en Supabase (Live y Script) para reaccionar al borrado del HardwareId.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Desvincular desde Web dispara UNBIND_DEVICE vía FCM.
  - [x] AC 2: La notificación persistente cambia a estado "Desvinculado" al borrarse el deviceId de memoria.
---

---
### [2026-09-27 10:42] | App/Componente: admin/auth | Autor: AGENT_ROLE

* **Descripción:** Refinamiento de la desvinculación manual local para evitar efecto búmeran de FCM y tokens huérfanos.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DeviceLinker.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/DeviceLinker.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **Lógica Modificada:** clearRemoteHardware ahora purga también el FcmToken. unbindDevice implementa cortocircuito temprano si el equipo ya no tiene deviceId local, previniendo re-ejecución por triggers.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Desvincular localmente no deja tokens huérfanos en Supabase.
  - [x] AC 2: Desvincular localmente no procesa pushes duplicados de desvinculación de Supabase.
---

---
### [2026-09-27 13:47] | App/Componente: admin/ui | Autor: AGENT_ROLE

* **Descripción:** Refactorización arquitectónica del Dashboard para alinear con la App Viewer (Desacoplamiento de TopBar y adopción de títulos de sección locales).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [PaymentsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/PaymentsSection.kt), [WalletsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/WalletsSection.kt), [SettingsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/SettingsSection.kt), [SummaryHeader.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/SummaryHeader.kt)
  - **Lógica Modificada:** Limpieza de TopAppBar global, inyección de Textos HeadlineLarge en las secciones individuales que coinciden con el Bottom Navigation. Refactorización visual de SummaryHeader para permitir estado deshabilitado (empty state) sin notificaciones.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: El encabezado superior global ya no muestra el nombre de la sección activa.
  - [x] AC 2: Cada sección interna muestra su título gigante con el mismo nombre que su pestaña.
  - [x] AC 3: El SummaryHeader está siempre visible y se deshabilita (estilo grisáceo/no clickeable) si no hay recaudación para ese día.
---

---
### [2026-09-27 14:02] | App/Componente: admin/ui | Autor: AGENT_ROLE

* **Descripción:** Homologación visual del selector de fecha a un patrón de "Bloques Gemelos".
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PaymentsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/PaymentsSection.kt), [SummaryHeader.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/SummaryHeader.kt)
  - **Lógica Modificada:** Se aplicó esquema Flex (weight(1f)) y rediseño de anatomía al selector de fecha para espejar el estilo del SummaryHeader. Ambos bloques comparten la misma proporción, tamaño de fuente y un subtítulo técnico superior.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Selector de Fecha y Píldora de Recaudación comparten el 50% del ancho (menos el espaciado).
  - [x] AC 2: Anatomía de doble línea con ícono anclado a la derecha implementada en el Selector de Fecha.
---

---
### [2026-09-27 14:14] | App/Componente: admin/ui | Autor: AGENT_ROLE

* **Descripción:** Corrección de ripple effect en botones de fecha/recaudación y agregado de Nombre del Contratante al encabezado global.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PaymentsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/PaymentsSection.kt), [SummaryHeader.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/SummaryHeader.kt), [DeviceDto.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com\notificape/admin/data/remote/dto/DeviceDto.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt), [DeviceLinker.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/DeviceLinker.kt), [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt)
  - **Lógica Modificada:** Uso de la propiedad onClick nativa del componente Surface para recortar automáticamente el ripple effect a la forma redondeada. Adición de relación Contratantes en las consultas de PostgREST para obtener el NombreNegocio. Extracción y preservación local de dicho nombre en DataStore para su inyección en la barra superior del Dashboard.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La animación táctil respeta los bordes redondeados (12dp) en los botones del Dashboard.
  - [x] AC 2: La barra superior muestra "[NombreNegocio] / [AliasCaja]"
---
---
### [2026-09-27 15:25] | App/Componente: admin/service | Autor: AGENT_ROLE

* **Descripción:** Implementación de Notificaciones de Sistema (Smart Diffing) para actualizaciones por FCM [TSK-026C].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [SystemNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/SystemNotificationManager.kt), [WalletRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt), [RuleRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/RuleRepository.kt), [AuthRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/AuthRepository.kt)
  - **Lógica Modificada:** Se creó SystemNotificationManager con el canal Alertas del Sistema. Se inyectó en los repositorios para realizar *diffing* matemático local antes de sobrescribir la base de datos (Room). De esta manera, se previenen avalanchas de notificaciones offline, disparando alertas solo por los cambios netos efectuados remotamente (estado de caja, filtros, billeteras, desvinculación).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La app muestra notificación local cuando el administrador desvincula remotamente el equipo.
  - [x] AC 2: La app notifica con precisión matemática qué billeteras específicas se añadieron/quitaron.
---
---
### [2026-09-27 20:07] | App/Componente: admin/service | Autor: AGENT_ROLE

* **Descripción:** Refactorización del manejador de notificaciones de billeteras para evitar sobrescrituras de Android.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [SystemNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/SystemNotificationManager.kt), [WalletRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt)
  - **Lógica Modificada:** Se dividió NOTIFICATION_ID_WALLETS en dos IDs distintos (1001 para activaciones y 1005 para desactivaciones) permitiendo que ambas alertas coexistan simultáneamente en la bandeja del sistema en un sync concurrente. Además, se añadió conteo de listas en el diffing de Room (
ames.size == 1) para inyectar gramática dinámica sin paréntesis de pluralización.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Desactivar y activar billeteras secuencial o simultáneamente no colapsa las notificaciones en una sola por conflicto de Notification ID.
  - [x] AC 2: Textos gramaticalmente limpios ("Billetera activada" / "Billeteras activadas").
---
---
### [2026-09-27 20:55] | App/Componente: admin/util | Autor: AGENT_ROLE

* **Descripción:** Parametrización de pluralidad para los títulos de notificaciones de billeteras.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [SystemNotificationManager.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/util/SystemNotificationManager.kt), [WalletRepository.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt)
  - **Lógica Modificada:** Se agregó el parámetro isPlural: Boolean a los métodos de notificación de SystemNotificationManager para evitar que el título permanezca estático en singular. El repositorio ahora envía dinámicamente este flag basado en 
ames.size > 1.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: El título de la notificación se adapta a "Billeteras activadas/desactivadas" cuando hay más de un elemento procesado.
---
