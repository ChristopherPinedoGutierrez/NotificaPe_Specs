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

