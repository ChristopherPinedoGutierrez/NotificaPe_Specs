# Changelog Atómico - App: Admin

---
### 2026-07-22 12:25 | App/Componente: admin | Autor: Programador Especializado (IA)

* **Descripción:** Habilitar configuración de Presence en la creación del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
* **Detalles Técnicos:**
  - **Archivos Modificados:** [AuthRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/AuthRealtimeHandler.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La compilación del aplicativo es exitosa tras aplicar la configuración de Presence en el builder del canal.
  - [x] AC 2: La suscripción a cambios Postgres existente en el canal permanece inalterada y funcional.
---

---
### 2026-07-25 16:15 | App/Componente: admin | Autor: Programador Especializado (IA)

* **Descripción:** Implementación de nuevo loader inicial (LoadingOverlay estático) y sistema de autolimpieza configurable de notificaciones bancarias procesadas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [LoadingOverlay.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/LoadingOverlay.kt), [CheckAuthScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/CheckAuthScreen.kt), [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [SettingsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/SettingsSection.kt), [NotificationProcessor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationProcessor.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Base de Datos:** Ninguno (Uso de DataStore local `user_settings`)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: El nuevo loader `LoadingOverlay` con ícono estático se muestra correctamente al inicializar sesión en la app Admin.
  - [x] AC 2: El switch de Limpieza Automática está presente en Configuración (activo por defecto) con modal de confirmación al cambiar su estado.
  - [x] AC 3: Las notificaciones provenientes de billeteras activas se remueven automáticamente del status bar sin romper la captura ni el guardado de notificaciones en estado PENDIENTE o REVISION.
---


---
### [2026-07-26 09:30] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Implementación de soporte para colores dinámicos desde Base de Datos (RuleDto y DeviceWalletEntity).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DeviceWalletEntity.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/model/DeviceWalletEntity.kt), [RuleDto.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/remote/dto/RuleDto.kt), [WalletRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt), [RuleRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/RuleRepository.kt), [AppDatabase.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt)
  - Se añadió \ColorHex\ a DTOs de sincronización y a Room, mapeando en RuleRepository. Las Vistas (NotificationItem y WalletsComponents) ya leían de WalletEntity.colorHex, por lo que heredan el cambio al vuelo. Se elevó AppDatabase a la versión 10.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La compilación Kotlin/KSP fue exitosa sin fallos de parseo de JSON.
---
### [2026-07-26 15:00] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Actualizaciones visuales en la app Admin: renombrado a 'Notificaciones' / 'Registro de Notificaciones', ensanchamiento y actualización del modal de Recaudación por Billetera.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [BreakdownDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/BreakdownDialog.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La navegación inferior y el título principal reflejan 'Notificaciones' y 'Registro de Notificaciones'.
  - [x] AC 2: El modal 'Recaudación por Billetera' coincide en ancho con el listado principal y actualiza los subtextos a 'notificaciones recibidas'.
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

* **Descripción:** Se corrige el desbordamiento de contenido debajo de las barras de sistema (Edge-to-Edge) en la vista de recorte de imagen (uCrop) en Android 15.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [themes.xml (values-v35)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/res/values-v35/themes.xml)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La actividad de recorte ya no se dibuja detrás de las barras del sistema (status y navigation bars) al aplicar windowOptOutEdgeToEdgeEnforcement.
  - [x] AC 2: La aplicación compila correctamente (assembleDebug).
---

---
### [2026-08-04 16:58] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Se hizo opcional la restricción obligatoria de optimización de batería en el modal de permisos inicial, permitiendo omitirla mediante un modal de confirmación y guardando la decisión localmente, para evitar el bloqueo en capas de Android estrictas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno (Uso de SharedPreferences locales)
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: El botón "Omitir" permite saltar el requerimiento de batería pero requiere confirmación (AlertDialog).
  - [x] AC 2: La decisión de omitir se guarda en SharedPreferences, persistiendo al reiniciar la app.
---

---
### [2026-08-04 17:36] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Reducción de dimensiones y espaciado de los botones "Activar" y "Omitir" en la vista de permisos (ajuste visual a 32dp/24dp de altura respectivamente y fix de importación sp faltante).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La compilación del aplicativo es exitosa tras reparar la dependencia faltante (androidx.compose.ui.unit.sp).
  - [x] AC 2: La interfaz gráfica presenta botones estéticamente compactos y balanceados.
---
