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
### [2026-08-06 15:30] | App/Componente: web | Autor: Antigravity

* **Descripción:** Refactorización White-Label de la Landing Page e integración del componente dinámico de Carrusel Infinito (Marquee) para Billeteras Soportadas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [globals.css](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/globals.css): Definición de animación CSS `@keyframes marquee` y clase `.animate-marquee`.
    - [SupportedWallets.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SupportedWallets.tsx): Componente de carrusel continuo con marquesina sin fin, desvanecidos laterales y disclaimer legal.
    - [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/page.tsx): Consulta a tabla `Billeteras` en Server Component e inyección de lista a la Landing Page.
    - [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx): Sanitización de marcas de bancos a términos genéricos ("billeteras digitales", "pagos móviles"), ajuste de gradientes universales y posicionamiento del carrusel.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Carrusel dinámico de billeteras animado en bucle con datos servidos desde Supabase.
  - [x] AC 2: Sanitización de textos para cumplir con requerimientos de marca y disclaimer legal visible.
---
### [2026-08-06 15:45] | App/Componente: web | Autor: Antigravity

* **Descripción:** Corrección de la maquetación responsive del footer legal y expansión de ancho máximo en pantallas widescreen.
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx): Reemplazo de `grid-cols-2` por Flexbox adaptativo (`flex-col lg:flex-row`), ampliación del contenedor a `max-w-[1440px]` y alineación `lg:flex-1 lg:justify-end` para pegar los botones a los bordes.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Eliminación total de desbordes/solapamientos en tablets (640px-1023px).
  - [x] AC 2: Botones pegados a los bordes laterales en monitores desktop panorámicos.
---
### [2026-08-06 15:55] | App/Componente: web | Autor: Antigravity

* **Descripción:** Unificación de la rejilla visual y alineación de bordes (max-w-7xl + px-6 md:px-8) en todo el layout de la Landing Page (Nav Header, Cuerpo Central, Footer Legal y Subfooter).
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx): Homogeneización de contenedores a `max-w-7xl mx-auto px-6 md:px-8` en Nav, Footer principal y Subfooter de copyright para lograr una simetría vertical absoluta.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Alineación vertical limpia y exacta entre los logos (izquierda) y botones de acción (derecha) en todo el sitio web.
  - [x] AC 2: Eliminación del desfase de anchos máximos entre el cuerpo y el pie de página.
---
### [2026-08-06 16:05] | App/Componente: web | Autor: Antigravity

* **Descripción:** Optimización estética del contenedor de Billeteras Soportadas mediante gradiente horizontal de transparencia y máscara CSS de desvanecimiento lateral.
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [SupportedWallets.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SupportedWallets.tsx): Aplicación de `bg-gradient-to-r` de transparencia en los bordes horizontales del contenedor manteniendo las líneas divisorias (`border-y`), y adición de `mask-image: linear-gradient` para difuminar suavemente los extremos del carrusel en paneles de alto contraste (VA/OLED).
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Eliminación del corte rectangular brusco a los lados en paneles de alto contraste.
  - [x] AC 2: Preservación de las líneas divisorias superior e inferior con desvanecimiento horizontal orgánico.
---

