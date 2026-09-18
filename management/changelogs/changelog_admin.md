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
