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
