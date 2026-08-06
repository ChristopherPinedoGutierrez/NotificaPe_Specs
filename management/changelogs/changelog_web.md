# Historial de Cambios - NotificaPe Web

---
### [2026-08-06 14:15] | App/Componente: web | Autor: Antigravity

* **Descripción:** Implementación del filtro visual y de servidor para restringir la asignación de billeteras a VersionMotor = 2 en el Dashboard de Clientes, preservando la visibilidad de billeteras legacy (V1) previamente asignadas para permitir su desactivación.
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/layout.tsx): Extracción de `VersionMotor` e inyección de `initialBilleterasV2Permitidas`.
    - [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx): Soporte para estado global V2 y cálculo en `refetchCatalog`.
    - [CreateDeviceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/CreateDeviceModal.tsx): Filtro estricto visual a V2 para nuevas cajas.
    - [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/actions.ts): Filtro estricto `.eq("VersionMotor", 2)` a nivel de validación backend.
    - [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Filtro combinado `V2 || Asignada` en la lista maestra para el modal de edición.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Las nuevas cajas solo pueden seleccionar billeteras V2.
  - [x] AC 2: Las cajas existentes mantienen visibles sus billeteras V1 si estaban asignadas, permitiendo su desactivación segura.

---
### [2026-08-06 14:38] | App/Componente: web | Autor: Antigravity

* **Descripción:** Bugfix de UX en selector de billeteras: Ocultamiento estricto de opciones legacy inactivas y adición de banner informativo dinámico.
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Cambio de `relaciones.some()` a `b.Activo` en el filtro. Adición de variable `tieneLegacyActiva` y componente visual `AlertTriangle`.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Billeteras V1 desaparecen instantáneamente de la vista al ser apagadas.
  - [x] AC 2: Banner de advertencia (ámbar) solo aparece si existe al menos una billetera legacy encendida.
---
