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
