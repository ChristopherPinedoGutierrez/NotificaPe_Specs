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
### [2026-08-06 16:11] | App/Componente: web | Autor: Antigravity

* **Descripción:** Refinamiento de micro-interacciones (hover scale) e igualación de márgenes verticales superiores e inferiores en el carrusel de billeteras.
* **Detalles Técnicos:**
  - **Archivos Modificados:** 
    - [SupportedWallets.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SupportedWallets.tsx): Reemplazo de `-translate-y-1` por `scale-[1.04]` con sombra realzada (`shadow-lg`), adición de padding vertical interno (`py-2`) y unificación de espaciados a `mb-10` y `mt-10`.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Eliminación total del corte del borde superior al pasar el cursor sobre las tarjetas de billeteras.
  - [x] AC 2: Simetría exacta en los márgenes verticales superiores e inferiores dentro del bloque de cobertura.
---

---
### 2026-08-30 14:05 | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Implementación del Sistema Integral de Onboarding y Usabilidad (E5: Hitos 1, 2 y 3): Hub Global de Descargas QR, Widget Setup Checklist, Empty States asistidos, Banner Contextual de Licencia Expirada, Panel Lateral de Ayuda (Help Drawer) y Motor de Tour Interactivo (SpotlightTour).
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [DownloadHubModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/DownloadHubModal.tsx): Modal bitemático con generación dinámica de QR para instalación en Android (App Emisor y App Receptor) y botón para compartir vía WhatsApp.
    - [SetupChecklist.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/SetupChecklist.tsx): Widget reactivo con barra de progreso porcentual, detección de 4 hitos clave, colapso y descarte persistente en localStorage.
    - [HelpDrawer.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/HelpDrawer.tsx): Sheet lateral con detección de pathname y FAQs contextuales por sección.
    - [SpotlightTour.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SpotlightTour.tsx): Motor de tour overlay spotlight en SVG/Tailwind con persistencia de ciclo de vida.
    - [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx): Integración de botones de Guía & Ayuda, Descargas Móviles y data-tour attributes.
    - [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx): Integración de botón de instalación y data-tour.
    - [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx): Marcado data-tour para recorrido guiado.
    - [actions_control.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/actions_control.ts): Cálculo en servidor de `checklistStatus`.
    - [page.tsx (dispositivos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/page.tsx): Rediseño didáctico del empty state en 3 pasos.
    - [page.tsx (accesos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/page.tsx): Rediseño de empty state con CTA directo a creación de cajas.
    - [page.tsx (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx): Banner contextual de alerta cuando la cuenta carece de plan activo.
    - [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx): Inyección y montaje de SetupChecklist y DownloadHubModal.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1 (TSK-016 a TSK-019): Hub de descargas con selector de apps y códigos QR; banner de plan expirado y empty states con micro-guías.
  - [x] AC 2 (TSK-020 a TSK-022): Setup Checklist reactivo en Dashboard con 4 pasos interactivos y persistencia de estado.
  - [x] AC 3 (TSK-023 a TSK-025): Help Drawer lateral con FAQs según la ruta actual y motor de tour Spotlight guiado.
---

### 2026-08-30 14:50 | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Perfeccionamiento del Sistema de Onboarding y Usabilidad: Soporte oficial por correo (`servicios@ryctech.dev`), FAQs agrupadas por vista con apertura reactiva, máscara SVG con transparencia real en Spotlight, reorganización del menú inferior en la barra lateral, Welcome Modal inicial y banners contextuales de inicio/reanudación/descarte por pantalla.
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [middleware.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/middleware.ts) / [middleware.ts (lib)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/lib/supabase/middleware.ts): Middleware SSR para sincronización y purga de cookies expiradas, eliminando warnings en consola de desarrollo.
    - [HelpDrawer.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/HelpDrawer.tsx): Tarjeta de soporte con correo oficial `servicios@ryctech.dev` (copiar/enviar mailto), FAQs completas categorizadas en acordeones reactivos y botón directo Instalar Apps.
    - [SpotlightTour.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SpotlightTour.tsx): Máscara SVG con regla `mask/rect` 100% transparente sobre el elemento enfocado, anillo luminoso animado y definiciones de tours multi-vista.
    - [TourContextBanner.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/TourContextBanner.tsx): Banner no invasivo superior para iniciar, reanudar o descartar (Dismiss) tours locales.
    - [WelcomeOnboardingModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/WelcomeOnboardingModal.tsx): Modal de inducción para la primera visita al Dashboard con botón de lanzamiento del tour.
    - [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx): Reorganización de navegación con botón simplificado "Instalar Apps" y menú inferior consolidado (Configuración, Guía y Ayuda, Cerrar Sesión).
    - [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx): Remoción de botón redundante de descargas.
    - [SetupChecklist.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/SetupChecklist.tsx): Animación y anillo de atención cuando la configuración está por debajo del 100%.
    - [DispositivosTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosTourManager.tsx) / [AccesosTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/AccesosTourManager.tsx) / [LicenciasTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/LicenciasTourManager.tsx): Inyección de banners y marcadores `data-tour` en todas las subvistas.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Errores de refresh token suprimidos en consola de desarrollo vía middleware SSR.
  - [x] AC 2: Spotlight Tour con iluminación y transparencia real sobre el selector enfocado sin oscurecimiento interno.
  - [x] AC 3: FAQs completas disponibles en acordeones categorizados con apertura por defecto según la ruta activa.
  - [x] AC 4: Soporte directo a `servicios@ryctech.dev` con copia al portapapeles y enlace mailto.
  - [x] AC 5: Menú de opciones unificado al pie de la barra lateral y botón directo simplificado a "Instalar Apps".
---

### 2026-08-31 22:01 | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Solución integral de reactividad en el Store de Dispositivos para `FechaReg`:
  1. Identificación y corrección en `DispositivosViewProvider.tsx`: el hook `useState(initialDispositivos)` no se sincronizaba cuando el Server Component del layout revalidaba y entregaba nuevas propiedades (incluyendo la columna `FechaReg`).
  2. Implementación de `useEffect` reactivos para sincronizar `dispositivos`, `billeteras` y relaciones cada vez que `initialProps` se actualiza desde el servidor.
  3. Verificación exitosa en base de datos Supabase confirmando que `Caja 1` posee `FechaReg: "2026-08-10 19:44:13.692606+00"`, renderizándose correctamente como `10/08/2026` en hora de Perú (UTC-5).
* **Detalles Técnicos:**
  - **Archivos Modificados:**
    - [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx): Efectos de sincronización reactiva para `initialDispositivos`.
    - [dispositivos/[id]/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Parser y fallback `disp.FechaReg || disp.created_at`.
  - **Base de Datos:** Verificada existencia de `FechaReg` en tabla `DispositivosXContratante`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La fecha de creación se sincroniza y se muestra con exactitud en formato DD/MM/YYYY.
  - [x] AC 2: El provider es reactivo ante cambios en los Server Components.
---

### 2026-09-01 21:35 | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Optimización integral de Onboarding, Tours Guiados y UI de Licencias:
  1. **SpotlightTour Compacto y Arrastrable:** Rediseño a tarjeta compacta (`w-[340px]`, `p-4.5`) con arrastre libre (Draggable) en escritorio con límites de pantalla, y modo anclado inferior fijo (`bottom-3 left-3 right-3`) en dispositivos móviles.
  2. **Tours Condicionales Multi-Vista:**
     - Dashboard General: pasos condicionales para actividad diaria de cobros (estado vacío vs ingresos por terminal y auditoría de alertas).
     - Dispositivos: eliminación de paso exterior redundante al ingresar a la vista detallada de una caja (`/dispositivos/[id]`).
     - Gestionar Licencias: incorporación del paso explicativo de Personalizar / Renovar Plan y respiro perimetral con margen en el foco de Plan Actual y Saldo Disponible.
  3. **Módulo de Licencias (`/dashboard/licencias`):**
     - Desacoplamiento de columnas con `items-start` para alturas naturales sin deformaciones.
     - Extracción de acordeones de cola e historial en `LicenciasAccordionGroup.tsx` con límite de altura `max-h-[calc(100vh-280px)]` y scroll interno.
     - Limpieza de banners redundantes y alineación a la izquierda del estado sin plan activo con CTA "Adquirir Licencia".
  4. **Modal Informativo y Subtour en Gestionar Licencias (`/dashboard/licencias/gestionar`):**
     - Creación de `GestionarLicenciasTourManager.tsx` con modal automático informativo de renovación para cuentas sin plan o vencidas.
     - Hero card adaptativo (2 columnas simétricas con divisor central vs 3 columnas con botón a la derecha).
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [SpotlightTour.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SpotlightTour.tsx): Tarjeta arrastrable con listeners de ratón, limitadores perimetrales, docking responsive móvil y definición de tours.
    - [page.tsx (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx): Limpieza de banner y alineación a la izquierda.
    - [LicenciasAccordionGroup.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/LicenciasAccordionGroup.tsx): Acordeones con scroll interno independiente.
    - [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx): Hero card adaptativo, respiro visual de spotlight y marcado data-tour.
    - [GestionarLicenciasTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/GestionarLicenciasTourManager.tsx): Modal informativo de suscripción y gestor de tour.
    - [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx): Marcado data-tour condicional en actividad, terminales y alertas.
    - [dispositivos/[id]/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Remoción de data-tour redundante en contenedor exterior.
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Tarjeta de tour compacta, arrastrable en escritorio y no invasiva en móvil.
  - [x] AC 2: Tours adaptativos que omiten pasos innecesarios y explican secciones condicionales.
  - [x] AC 3: Vista de licencias y acordeones con scroll contenido y alineación simétrica.
  - [x] AC 4: Subtour de gestionar licencias detectable desde el FAB de ayuda y banner superior.
---

