---
### [2026-09-04 14:05] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Actualización obligatoria de compileSdk y targetSdk a API 36 (Android 16) para cumplimiento de normativas de Google Play Store y sincronización de acción setup-android en el pipeline CI/CD.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [app/build.gradle.kts](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/build.gradle.kts), [.github/workflows/deploy.yml](file:///c:/Trabajo/Proyectos/NotificaPe/admin/.github/workflows/deploy.yml)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: compileSdk y targetSdk actualizados a 36 en admin/app/build.gradle.kts.
  - [x] AC 2: Pipeline deploy.yml sincronizado con la acción android-actions/setup-android@v3.
  - [x] AC 3: Despliegue automático de Release Please y subida exitosa de paquete AAB con targetSdk 36 a Google Play Console (Prueba Interna).
---
---
### [2026-08-10 16:05] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Corrección del mapeo del parámetro tipoFiltro en el simulador TestLabHandler para asegurar la correcta inyección y funcionamiento de las reglas de EXCLUSIÓN en los tests locales, y explicación arquitectural del filtro visual de privacidad para notificaciones en estado REVISION.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [TestLabHandler.kt](file:///../admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Las notificaciones mock que coinciden con una regla de EXCLUSION son truncadas correctamente y retornan emptyList en el simulador.
  - [x] AC 2: La compilación Kotlin/KSP fue exitosa.
---
# Changelog AtÃ³mico - App: Admin

---
### 2026-07-22 12:25 | App/Componente: admin | Autor: Programador Especializado (IA)

* **DescripciÃ³n:** Habilitar configuraciÃ³n de Presence en la creaciÃ³n del canal Realtime para permitir el track de estado online en el dashboard [CR-010].
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [AuthRealtimeHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/repository/auth/AuthRealtimeHandler.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La compilaciÃ³n del aplicativo es exitosa tras aplicar la configuraciÃ³n de Presence en el builder del canal.
  - [x] AC 2: La suscripciÃ³n a cambios Postgres existente en el canal permanece inalterada y funcional.
---

---
### 2026-07-25 16:15 | App/Componente: admin | Autor: Programador Especializado (IA)

* **DescripciÃ³n:** ImplementaciÃ³n de nuevo loader inicial (LoadingOverlay estÃ¡tico) y sistema de autolimpieza configurable de notificaciones bancarias procesadas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [LoadingOverlay.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/LoadingOverlay.kt), [CheckAuthScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/auth/CheckAuthScreen.kt), [UserPreferences.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/preference/UserPreferences.kt), [DashboardViewModel.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardViewModel.kt), [SettingsSection.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/sections/SettingsSection.kt), [NotificationProcessor.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationProcessor.kt), [NotificationReceiverService.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/service/NotificationReceiverService.kt)
  - **Base de Datos:** Ninguno (Uso de DataStore local `user_settings`)
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: El nuevo loader `LoadingOverlay` con Ã­cono estÃ¡tico se muestra correctamente al inicializar sesiÃ³n en la app Admin.
  - [x] AC 2: El switch de Limpieza AutomÃ¡tica estÃ¡ presente en ConfiguraciÃ³n (activo por defecto) con modal de confirmaciÃ³n al cambiar su estado.
  - [x] AC 3: Las notificaciones provenientes de billeteras activas se remueven automÃ¡ticamente del status bar sin romper la captura ni el guardado de notificaciones en estado PENDIENTE o REVISION.
---


---
### [2026-07-26 09:30] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** ImplementaciÃ³n de soporte para colores dinÃ¡micos desde Base de Datos (RuleDto y DeviceWalletEntity).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DeviceWalletEntity.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/model/DeviceWalletEntity.kt), [RuleDto.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/remote/dto/RuleDto.kt), [WalletRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/WalletRepository.kt), [RuleRepository.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/repository/RuleRepository.kt), [AppDatabase.kt](file:///../admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt)
  - Se aÃ±adiÃ³ \ColorHex\ a DTOs de sincronizaciÃ³n y a Room, mapeando en RuleRepository. Las Vistas (NotificationItem y WalletsComponents) ya leÃ­an de WalletEntity.colorHex, por lo que heredan el cambio al vuelo. Se elevÃ³ AppDatabase a la versiÃ³n 10.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La compilaciÃ³n Kotlin/KSP fue exitosa sin fallos de parseo de JSON.
---
### [2026-07-26 15:00] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** Actualizaciones visuales en la app Admin: renombrado a 'Notificaciones' / 'Registro de Notificaciones', ensanchamiento y actualizaciÃ³n del modal de RecaudaciÃ³n por Billetera.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [DashboardScreen.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/DashboardScreen.kt), [BreakdownDialog.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/components/BreakdownDialog.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La navegaciÃ³n inferior y el tÃ­tulo principal reflejan 'Notificaciones' y 'Registro de Notificaciones'.
  - [x] AC 2: El modal 'RecaudaciÃ³n por Billetera' coincide en ancho con el listado principal y actualiza los subtextos a 'notificaciones recibidas'.
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

* **DescripciÃ³n:** Se corrige el desbordamiento de contenido debajo de las barras de sistema (Edge-to-Edge) en la vista de recorte de imagen (uCrop) en Android 15.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [themes.xml (values-v35)](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/res/values-v35/themes.xml)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La actividad de recorte ya no se dibuja detrÃ¡s de las barras del sistema (status y navigation bars) al aplicar windowOptOutEdgeToEdgeEnforcement.
  - [x] AC 2: La aplicaciÃ³n compila correctamente (assembleDebug).
---

---
### [2026-08-04 16:58] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** Se hizo opcional la restricciÃ³n obligatoria de optimizaciÃ³n de baterÃ­a en el modal de permisos inicial, permitiendo omitirla mediante un modal de confirmaciÃ³n y guardando la decisiÃ³n localmente, para evitar el bloqueo en capas de Android estrictas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt), [MainActivityContent.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/MainActivityContent.kt)
  - **Base de Datos:** Ninguno (Uso de SharedPreferences locales)
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: El botÃ³n "Omitir" permite saltar el requerimiento de baterÃ­a pero requiere confirmaciÃ³n (AlertDialog).
  - [x] AC 2: La decisiÃ³n de omitir se guarda en SharedPreferences, persistiendo al reiniciar la app.
---

---
### [2026-08-04 17:36] | App/Componente: admin | Autor: AGENT_ROLE

* **DescripciÃ³n:** ReducciÃ³n de dimensiones y espaciado de los botones "Activar" y "Omitir" en la vista de permisos (ajuste visual a 32dp/24dp de altura respectivamente y fix de importaciÃ³n sp faltante).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** [PermissionComponents.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/components/PermissionComponents.kt)
  - **Base de Datos:** Ninguno
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La compilaciÃ³n del aplicativo es exitosa tras reparar la dependencia faltante (androidx.compose.ui.unit.sp).
  - [x] AC 2: La interfaz grÃ¡fica presenta botones estÃ©ticamente compactos y balanceados.
---

---
### [2026-08-06 13:14] | App/Componente: admin | Autor: AGENT_ROLE

* **Descripción:** Implementación del Motor V2 (desestructuración de mocks en TestLabHandler, guardado de PayloadBruto en JSON para depuración de fallos de regex en estado REVISION, interpolación de variables en FormatoMensaje y actualización de Room Database a V12).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [AppDatabase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/data/local/AppDatabase.kt), [ExtractPaymentUseCase.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/domain/usecase/ExtractPaymentUseCase.kt), [TestLabHandler.kt](file:///c:/Trabajo/Proyectos/NotificaPe/admin/app/src/main/java/com/notificape/admin/ui/dashboard/viewmodel/handlers/TestLabHandler.kt)
  - **Base de Datos:** Migración destructiva de Room a V12 para añadir payloadBruto a NotificationEntity.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Los mensajes mock con etiquetas [TITLE]/[TEXT] son extraídos limpiamente por la UI.
  - [x] AC 2: Fallos de regex (REVISION) generan un payload JSON de diagnóstico y lo sincronizan a Supabase.
---

