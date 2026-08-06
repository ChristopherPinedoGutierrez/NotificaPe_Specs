# Changelog At贸mico - App: Admin

---
### 2026-07-22 12:25 | App/Componente: admin | Autor: Programador Especializado (IA)

* **Descripci贸n:** Habilitar configuraci贸n de Presence en la creaci贸n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [AuthRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/AuthRealtimeHandler.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: La compilaci贸n del aplicativo es exitosa tras aplicar la configuraci贸n de Presence en el builder del canal.
  - [x] AC 2: La suscripci贸n a cambios Postgres existente en el canal permanece inalterada y funcional.
---

---
### 2026-07-25 16:15 | App/Componente: admin | Autor: Programador Especializado (IA)

* **Descripci贸n:** Implementaci贸n de nuevo loader inicial (LoadingOverlay est谩tico) y sistema de autolimpieza configurable de notificaciones bancarias procesadas.
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [LoadingOverlay.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/LoadingOverlay.kt), [CheckAuthScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/CheckAuthScreen.kt), [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [SettingsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/SettingsSection.kt), [NotificationProcessor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationProcessor.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Base de Datos:** Ninguno (Uso de DataStore local `user_settings`)
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: El nuevo loader `LoadingOverlay` con 铆cono est谩tico se muestra correctamente al inicializar sesi贸n en la app Admin.
  - [x] AC 2: El switch de Limpieza Autom谩tica est谩 presente en Configuraci贸n (activo por defecto) con modal de confirmaci贸n al cambiar su estado.
  - [x] AC 3: Las notificaciones provenientes de billeteras activas se remueven autom谩ticamente del status bar sin romper la captura ni el guardado de notificaciones en estado PENDIENTE o REVISION.
---


---
### [2026-07-26 09:30] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripci贸n:** Implementaci贸n de soporte para colores din谩micos desde Base de Datos (RuleDto y DeviceWalletEntity).
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [DeviceWalletEntity.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/model/DeviceWalletEntity.kt), [RuleDto.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/remote/dto/RuleDto.kt), [WalletRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt), [RuleRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/RuleRepository.kt), [AppDatabase.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt)
  - Se a帽adi贸 \ColorHex\ a DTOs de sincronizaci贸n y a Room, mapeando en RuleRepository. Las Vistas (NotificationItem y WalletsComponents) ya le铆an de WalletEntity.colorHex, por lo que heredan el cambio al vuelo. Se elev贸 AppDatabase a la versi贸n 10.
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: La compilaci贸n Kotlin/KSP fue exitosa sin fallos de parseo de JSON.
---
### [2026-07-26 15:00] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripci贸n:** Actualizaciones visuales en la app Admin: renombrado a 'Notificaciones' / 'Registro de Notificaciones', ensanchamiento y actualizaci贸n del modal de Recaudaci贸n por Billetera.
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [BreakdownDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/BreakdownDialog.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: La navegaci贸n inferior y el t铆tulo principal reflejan 'Notificaciones' y 'Registro de Notificaciones'.
  - [x] AC 2: El modal 'Recaudaci贸n por Billetera' coincide en ancho con el listado principal y actualiza los subtextos a 'notificaciones recibidas'.
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

* **Descripci贸n:** Se corrige el desbordamiento de contenido debajo de las barras de sistema (Edge-to-Edge) en la vista de recorte de imagen (uCrop) en Android 15.
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [themes.xml (values-v35)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/res/values-v35/themes.xml)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: La actividad de recorte ya no se dibuja detr谩s de las barras del sistema (status y navigation bars) al aplicar windowOptOutEdgeToEdgeEnforcement.
  - [x] AC 2: La aplicaci贸n compila correctamente (assembleDebug).
---

---
### [2026-08-04 16:58] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripci贸n:** Se hizo opcional la restricci贸n obligatoria de optimizaci贸n de bater铆a en el modal de permisos inicial, permitiendo omitirla mediante un modal de confirmaci贸n y guardando la decisi贸n localmente, para evitar el bloqueo en capas de Android estrictas.
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno (Uso de SharedPreferences locales)
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: El bot贸n "Omitir" permite saltar el requerimiento de bater铆a pero requiere confirmaci贸n (AlertDialog).
  - [x] AC 2: La decisi贸n de omitir se guarda en SharedPreferences, persistiendo al reiniciar la app.
---

---
### [2026-08-04 17:36] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripci贸n:** Reducci贸n de dimensiones y espaciado de los botones "Activar" y "Omitir" en la vista de permisos (ajuste visual a 32dp/24dp de altura respectivamente y fix de importaci贸n sp faltante).
* **Detalles T茅cnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptaci贸n (AC) Validados:**
  - [x] AC 1: La compilaci贸n del aplicativo es exitosa tras reparar la dependencia faltante (androidx.compose.ui.unit.sp).
  - [x] AC 2: La interfaz gr谩fica presenta botones est茅ticamente compactos y balanceados.
---

---
### [2026-08-06 13:14] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripci髇:** Implementaci髇 del Motor V2 (desestructuraci髇 de mocks en TestLabHandler, guardado de PayloadBruto en JSON para depuraci髇 de fallos de regex en estado REVISION, interpolaci髇 de variables en FormatoMensaje y actualizaci髇 de Room Database a V12).
* **Detalles T閏nicos:**
  - **Archivos Modificados:** [AppDatabase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt), [ExtractPaymentUseCase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/domain/usecase/ExtractPaymentUseCase.kt), [TestLabHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **Base de Datos:** Migraci髇 destructiva de Room a V12 para a馻dir payloadBruto a NotificationEntity.
* **Criterios de Aceptaci髇 (AC) Validados:**
  - [x] AC 1: Los mensajes mock con etiquetas [TITLE]/[TEXT] son extra韉os limpiamente por la UI.
  - [x] AC 2: Fallos de regex (REVISION) generan un payload JSON de diagn髎tico y lo sincronizan a Supabase.
---
