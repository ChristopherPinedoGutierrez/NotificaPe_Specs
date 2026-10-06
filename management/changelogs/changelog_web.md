---
### [2026-10-05 21:30] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Corrección de desbordamiento horizontal en el botón de canje de código promocional (`PromoCodeForm`).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [PromoCodeForm.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/PromoCodeForm.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Se añade `min-w-0` y ajuste de padding responsivo al input y botón de canje de código evitando que sobrepase el contenedor en pantallas de escritorio y móviles.
  - [x] AC 2: Se armoniza el estilo del contenedor a `p-5 rounded-2xl` alineado con la tarjeta de saldo disponible.
---
### [2026-10-05 21:22] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Optimización compacta en dos columnas de la tarjeta de Plan Activo con botones de gestión contextuales e integración de capacidad de Webhooks en asistente de licencias.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx), [page.tsx (gestionar)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/page.tsx), [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx)
  - **Base de Datos:** Ninguno.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La tarjeta de Plan Activo elimina el divider vertical, reorganizándose en dos columnas esbeltas (info a la izquierda y 3 cards horizontales a la derecha).
  - [x] AC 2: Botones de acceso directo ("Gestionar") añadidos en los tres recursos (Dispositivos, Usuarios y Webhooks) con tooltips persistentes de base y extras.
  - [x] AC 3: La capacidad del plan actual en `/dashboard/licencias/gestionar` refleja la cuota de Webhooks junto a Dispositivos y Usuarios.
---
### [2026-10-05 21:15] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Reestructuración de la vista de Licencias: tarjeta de Plan Activo de ancho completo superior, adición de métrica de Webhooks B2B y redistribución desacoplada inferior.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx)
  - **Base de Datos:** Invocación a RPC `get_cuota_webhooks` y lectura de `ExtraWebhooks` y `LimiteWebhooks` en licencias activas e historial.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La tarjeta de Plan Activo ocupa el ancho completo en la parte superior con los 3 indicadores de recursos (Dispositivos, Usuarios, Webhooks B2B).
  - [x] AC 2: La distribución inferior mantiene el Saldo Disponible y Canje de Códigos a la izquierda (1/3) y las Colas/Historial a la derecha (2/3).
  - [x] AC 3: Licencias en cola muestran badges de webhooks adicionales cuando aplican.
---
### [2026-10-05 21:05] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Explicitación de parámetros RPC en compra de licencias y soporte de extra_webhooks en webhook de Mercado Pago.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts), [index.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_webhook/index.ts)
  - **Base de Datos:** Inclusión explícita de `p_factor_unidad_entera: 100` y `p_extra_webhooks` en las invocaciones a `ejecutar_compra_licencia_multiple`.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Desbloqueada la compra y personalización de licencias con add-ons de webhooks usando saldo disponible.
  - [x] AC 2: Webhook de pasarela procesa y transfiere compras con webhooks adicionales a la cola y activación de licencias.
---
### [2026-09-07 18:25] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Creación y despliegue de Edge Function cm-dispatcher para emitir notificaciones push.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [index.ts](file:///../web/supabase/functions/fcm-dispatcher/index.ts)
  - **Base de Datos:** Configurado secreto FIREBASE_SERVICE_ACCOUNT
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Edge function desarrollada en Deno con Google Firebase Admin SDK (npm).
  - [x] AC 2: Invocable de forma segura desde los Triggers internos de Postgres vía pg_net.
# Historial de Cambios - NotificaPe Web

---
### [2026-09-04 12:05] | App/Componente: web / edge-functions | Autor: Antigravity

* **DescripciÃ³n:** ImplementaciÃ³n de desacoplamiento dinÃ¡mico multi-entorno (TEST/PROD) en pasarela Mercado Pago y estrategia de resoluciÃ³n dual de tokens en Webhook, con validaciÃ³n exitosa en producciÃ³n en vivo.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:**
    - [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts): EnvÃ­o explÃ­cito del entorno `env: NEXT_PUBLIC_MERCADOPAGO_ENV || "PROD"` en la invocaciÃ³n a la Edge Function `mercadopago_preferencia`.
    - [index.ts (mercadopago_preferencia)](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_preferencia/index.ts): Lectura dinÃ¡mica de `env` desde el body con fallback seguro a la variable `MERCADOPAGO_ENV` o `"PROD"`. Desplegada versiÃ³n 24 en Supabase.
    - [index.ts (mercadopago_webhook)](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_webhook/index.ts): Consulta con estrategia de token primario (PROD) y reintento con token secundario (TEST), permitiendo que pagos de Sandbox y ProducciÃ³n coexistan sin colisiones. Desplegada versiÃ³n 19 en Supabase.
  - **Base de Datos:** Verificada transacciÃ³n en vivo #198 con proveedor Mercado Pago (`177253140618`), cargo de S/ 48.00 por crÃ©ditos previos, cobro pasarela de S/ 5.00 (ticket mÃ­nimo para cubrir los S/ 2.00 restantes) y acreditaciÃ³n inmediata del vuelto de S/ 3.00 en `CreditoXContratante` (asiento #240).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La Edge Function `mercadopago_preferencia` acepta el entorno sin alterar la configuraciÃ³n global de producciÃ³n.
  - [x] AC 2: El Webhook procesa pagos de ambos entornos de forma transparente y resiliente.
  - [x] AC 3: ValidaciÃ³n integral en vivo con dinero real y comprobaciÃ³n de asiento de vuelto en base de datos.
---

* **DescripciÃ³n:** ImplementaciÃ³n en servidor y base de datos del forzado de Ticket MÃ­nimo (S/ 5.00) en pasarela Mercado Pago y acreditaciÃ³n matemÃ¡tica exacta del diferencial (Vuelto) como saldo a favor en la cuenta del cliente.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:**
    - [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts): Forzado de `montoCobro = 500` cÃ©ntimos en la creaciÃ³n de preferencia de pago cuando el monto final adeudado es mayor a 0 y menor a 500 cÃ©ntimos.
    - [0042_ticket_minimo_vuelto.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0042_ticket_minimo_vuelto.sql): ActualizaciÃ³n de la funciÃ³n RPC `ejecutar_compra_licencia_multiple` con cÃ¡lculo de `v_diferencial_vuelto := p_monto_cobrado - v_monto_final`, abono a `CreditoXContratante` y registro auditable en `TransaccionesXCredito`.
  - **Base de Datos:** Actualizada la funciÃ³n `ejecutar_compra_licencia_multiple` en Supabase en vivo y otorgados permisos a roles `authenticated` y `service_role`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Transacciones con remanente inferior a S/ 5.00 se cobran como S/ 5.00 en Mercado Pago sin ser rechazadas por la pasarela.
  - [x] AC 2: La base de datos abona la diferencia al cÃ©ntimo (ej. si debÃ­a S/ 1.20, se acreditan S/ 3.80 de saldo) en la tabla `CreditoXContratante`.
  - [x] AC 3: Queda registrado el asiento de auditorÃ­a bajo el concepto `TICKET_MINIMO_VUELTO` en `TransaccionesXCredito`.

---
### [2026-09-03 20:05] | App/Componente: web / db | Autor: Antigravity

* **DescripciÃ³n:** ActualizaciÃ³n de tarifas para add-ons de licencias (S/ 30 por dispositivo y S/ 20 por usuario), ampliaciÃ³n de lÃ­mites cuantitativos de selecciÃ³n en frontend (hasta 20 dispositivos y 50 usuarios) y correcciÃ³n de persistencia de metadata en Edge Functions de Mercado Pago.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:**
    - [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx): ActualizaciÃ³n de `MAX_EXTRA_DISPOSITIVOS = 20` y `MAX_EXTRA_USUARIOS = 50`.
    - [index.ts (mercadopago_preferencia)](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_preferencia/index.ts): ExtracciÃ³n de `extra_usuarios` y `extra_dispositivos` e inyecciÃ³n en `metadata` de Mercado Pago.
    - [index.ts (mercadopago_webhook)](file:///c:/Trabajo/Proyectos/NotificaPe/web/supabase/functions/mercadopago_webhook/index.ts): Lectura de `extra_usuarios` y `extra_dispositivos` de `metadata` y entrega a `ejecutar_compra_licencia_multiple`.
    - [0041_actualizar_precios_addons.sql](file:///c:/Trabajo/Proyectos/NotificaPe/NotificaPe_Specs/management/database/scripts/0041_actualizar_precios_addons.sql): Script SQL para actualizar tarifas en catÃ¡logo `Licencias`.
  - **Base de Datos:** Actualizadas columnas `PrecioExtraDispositivoCentimos = 3000` y `PrecioExtraUsuarioCentimos = 2000` en tabla `Licencias` para todos los planes con `PermiteAddons = TRUE`. Desplegadas versiones 23 de `mercadopago_preferencia` y 18 de `mercadopago_webhook`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La base de datos calcula add-ons con los nuevos valores: S/ 30.00 por dispositivo y S/ 20.00 por usuario.
  - [x] AC 2: La interfaz web permite incrementar hasta 20 dispositivos y 50 usuarios adicionales.
  - [x] AC 3: Las compras procesadas por pasarela Mercado Pago preservan y persisten los extras seleccionados en la licencia activa o en cola.

---
### [2026-08-06 14:15] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** ImplementaciÃ³n del filtro visual y de servidor para restringir la asignaciÃ³n de billeteras a VersionMotor = 2 en el Dashboard de Clientes, preservando la visibilidad de billeteras legacy (V1) previamente asignadas para permitir su desactivaciÃ³n.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/layout.tsx): ExtracciÃ³n de `VersionMotor` e inyecciÃ³n de `initialBilleterasV2Permitidas`.
    - [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx): Soporte para estado global V2 y cÃ¡lculo en `refetchCatalog`.
    - [CreateDeviceModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/CreateDeviceModal.tsx): Filtro estricto visual a V2 para nuevas cajas.
    - [actions.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/actions.ts): Filtro estricto `.eq("VersionMotor", 2)` a nivel de validaciÃ³n backend.
    - [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Filtro combinado `V2 || Asignada` en la lista maestra para el modal de ediciÃ³n.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Las nuevas cajas solo pueden seleccionar billeteras V2.
  - [x] AC 2: Las cajas existentes mantienen visibles sus billeteras V1 si estaban asignadas, permitiendo su desactivaciÃ³n segura.

---
### [2026-08-06 14:38] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** Bugfix de UX en selector de billeteras: Ocultamiento estricto de opciones legacy inactivas y adiciÃ³n de banner informativo dinÃ¡mico.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Cambio de `relaciones.some()` a `b.Activo` en el filtro. AdiciÃ³n de variable `tieneLegacyActiva` y componente visual `AlertTriangle`.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Billeteras V1 desaparecen instantÃ¡neamente de la vista al ser apagadas.
  - [x] AC 2: Banner de advertencia (Ã¡mbar) solo aparece si existe al menos una billetera legacy encendida.

---
### [2026-08-06 15:30] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** RefactorizaciÃ³n White-Label de la Landing Page e integraciÃ³n del componente dinÃ¡mico de Carrusel Infinito (Marquee) para Billeteras Soportadas.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [globals.css](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/globals.css): DefiniciÃ³n de animaciÃ³n CSS `@keyframes marquee` y clase `.animate-marquee`.
    - [SupportedWallets.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SupportedWallets.tsx): Componente de carrusel continuo con marquesina sin fin, desvanecidos laterales y disclaimer legal.
    - [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/page.tsx): Consulta a tabla `Billeteras` en Server Component e inyecciÃ³n de lista a la Landing Page.
    - [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx): SanitizaciÃ³n de marcas de bancos a tÃ©rminos genÃ©ricos ("billeteras digitales", "pagos mÃ³viles"), ajuste de gradientes universales y posicionamiento del carrusel.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Carrusel dinÃ¡mico de billeteras animado en bucle con datos servidos desde Supabase.
  - [x] AC 2: SanitizaciÃ³n de textos para cumplir con requerimientos de marca y disclaimer legal visible.
---
### [2026-08-06 15:45] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** CorrecciÃ³n de la maquetaciÃ³n responsive del footer legal y expansiÃ³n de ancho mÃ¡ximo en pantallas widescreen.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx): Reemplazo de `grid-cols-2` por Flexbox adaptativo (`flex-col lg:flex-row`), ampliaciÃ³n del contenedor a `max-w-[1440px]` y alineaciÃ³n `lg:flex-1 lg:justify-end` para pegar los botones a los bordes.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: EliminaciÃ³n total de desbordes/solapamientos en tablets (640px-1023px).
  - [x] AC 2: Botones pegados a los bordes laterales en monitores desktop panorÃ¡micos.
---
### [2026-08-06 15:55] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** UnificaciÃ³n de la rejilla visual y alineaciÃ³n de bordes (max-w-7xl + px-6 md:px-8) en todo el layout de la Landing Page (Nav Header, Cuerpo Central, Footer Legal y Subfooter).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx): HomogeneizaciÃ³n de contenedores a `max-w-7xl mx-auto px-6 md:px-8` en Nav, Footer principal y Subfooter de copyright para lograr una simetrÃ­a vertical absoluta.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: AlineaciÃ³n vertical limpia y exacta entre los logos (izquierda) y botones de acciÃ³n (derecha) en todo el sitio web.
  - [x] AC 2: EliminaciÃ³n del desfase de anchos mÃ¡ximos entre el cuerpo y el pie de pÃ¡gina.
---
### [2026-08-06 16:05] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** OptimizaciÃ³n estÃ©tica del contenedor de Billeteras Soportadas mediante gradiente horizontal de transparencia y mÃ¡scara CSS de desvanecimiento lateral.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [SupportedWallets.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SupportedWallets.tsx): AplicaciÃ³n de `bg-gradient-to-r` de transparencia en los bordes horizontales del contenedor manteniendo las lÃ­neas divisorias (`border-y`), y adiciÃ³n de `mask-image: linear-gradient` para difuminar suavemente los extremos del carrusel en paneles de alto contraste (VA/OLED).
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: EliminaciÃ³n del corte rectangular brusco a los lados en paneles de alto contraste.
  - [x] AC 2: PreservaciÃ³n de las lÃ­neas divisorias superior e inferior con desvanecimiento horizontal orgÃ¡nico.
---
### [2026-08-06 16:11] | App/Componente: web | Autor: Antigravity

* **DescripciÃ³n:** Refinamiento de micro-interacciones (hover scale) e igualaciÃ³n de mÃ¡rgenes verticales superiores e inferiores en el carrusel de billeteras.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** 
    - [SupportedWallets.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SupportedWallets.tsx): Reemplazo de `-translate-y-1` por `scale-[1.04]` con sombra realzada (`shadow-lg`), adiciÃ³n de padding vertical interno (`py-2`) y unificaciÃ³n de espaciados a `mb-10` y `mt-10`.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: EliminaciÃ³n total del corte del borde superior al pasar el cursor sobre las tarjetas de billeteras.
  - [x] AC 2: SimetrÃ­a exacta en los mÃ¡rgenes verticales superiores e inferiores dentro del bloque de cobertura.
---

---
### 2026-08-30 14:05 | App/Componente: web | Autor: AGENT_ROLE

* **DescripciÃ³n:** ImplementaciÃ³n del Sistema Integral de Onboarding y Usabilidad (E5: Hitos 1, 2 y 3): Hub Global de Descargas QR, Widget Setup Checklist, Empty States asistidos, Banner Contextual de Licencia Expirada, Panel Lateral de Ayuda (Help Drawer) y Motor de Tour Interactivo (SpotlightTour).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados / Creados:**
    - [DownloadHubModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/DownloadHubModal.tsx): Modal bitemÃ¡tico con generaciÃ³n dinÃ¡mica de QR para instalaciÃ³n en Android (App Emisor y App Receptor) y botÃ³n para compartir vÃ­a WhatsApp.
    - [SetupChecklist.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/SetupChecklist.tsx): Widget reactivo con barra de progreso porcentual, detecciÃ³n de 4 hitos clave, colapso y descarte persistente en localStorage.
    - [HelpDrawer.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/HelpDrawer.tsx): Sheet lateral con detecciÃ³n de pathname y FAQs contextuales por secciÃ³n.
    - [SpotlightTour.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SpotlightTour.tsx): Motor de tour overlay spotlight en SVG/Tailwind con persistencia de ciclo de vida.
    - [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx): IntegraciÃ³n de botones de GuÃ­a & Ayuda, Descargas MÃ³viles y data-tour attributes.
    - [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx): IntegraciÃ³n de botÃ³n de instalaciÃ³n y data-tour.
    - [DashboardStatsCards.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardStatsCards.tsx): Marcado data-tour para recorrido guiado.
    - [actions_control.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/actions_control.ts): CÃ¡lculo en servidor de `checklistStatus`.
    - [page.tsx (dispositivos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/page.tsx): RediseÃ±o didÃ¡ctico del empty state en 3 pasos.
    - [page.tsx (accesos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/page.tsx): RediseÃ±o de empty state con CTA directo a creaciÃ³n de cajas.
    - [page.tsx (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx): Banner contextual de alerta cuando la cuenta carece de plan activo.
    - [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx): InyecciÃ³n y montaje de SetupChecklist y DownloadHubModal.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1 (TSK-016 a TSK-019): Hub de descargas con selector de apps y cÃ³digos QR; banner de plan expirado y empty states con micro-guÃ­as.
  - [x] AC 2 (TSK-020 a TSK-022): Setup Checklist reactivo en Dashboard con 4 pasos interactivos y persistencia de estado.
  - [x] AC 3 (TSK-023 a TSK-025): Help Drawer lateral con FAQs segÃºn la ruta actual y motor de tour Spotlight guiado.
---

### 2026-08-30 14:50 | App/Componente: web | Autor: AGENT_ROLE

* **DescripciÃ³n:** Perfeccionamiento del Sistema de Onboarding y Usabilidad: Soporte oficial por correo (`servicios@ryctech.dev`), FAQs agrupadas por vista con apertura reactiva, mÃ¡scara SVG con transparencia real en Spotlight, reorganizaciÃ³n del menÃº inferior en la barra lateral, Welcome Modal inicial y banners contextuales de inicio/reanudaciÃ³n/descarte por pantalla.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados / Creados:**
    - [middleware.ts](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/middleware.ts) / [middleware.ts (lib)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/lib/supabase/middleware.ts): Middleware SSR para sincronizaciÃ³n y purga de cookies expiradas, eliminando warnings en consola de desarrollo.
    - [HelpDrawer.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/HelpDrawer.tsx): Tarjeta de soporte con correo oficial `servicios@ryctech.dev` (copiar/enviar mailto), FAQs completas categorizadas en acordeones reactivos y botÃ³n directo Instalar Apps.
    - [SpotlightTour.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SpotlightTour.tsx): MÃ¡scara SVG con regla `mask/rect` 100% transparente sobre el elemento enfocado, anillo luminoso animado y definiciones de tours multi-vista.
    - [TourContextBanner.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/TourContextBanner.tsx): Banner no invasivo superior para iniciar, reanudar o descartar (Dismiss) tours locales.
    - [WelcomeOnboardingModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/WelcomeOnboardingModal.tsx): Modal de inducciÃ³n para la primera visita al Dashboard con botÃ³n de lanzamiento del tour.
    - [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx): ReorganizaciÃ³n de navegaciÃ³n con botÃ³n simplificado "Instalar Apps" y menÃº inferior consolidado (ConfiguraciÃ³n, GuÃ­a y Ayuda, Cerrar SesiÃ³n).
    - [DashboardHeader.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardHeader.tsx): RemociÃ³n de botÃ³n redundante de descargas.
    - [SetupChecklist.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/SetupChecklist.tsx): AnimaciÃ³n y anillo de atenciÃ³n cuando la configuraciÃ³n estÃ¡ por debajo del 100%.
    - [DispositivosTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosTourManager.tsx) / [AccesosTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/AccesosTourManager.tsx) / [LicenciasTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/LicenciasTourManager.tsx): InyecciÃ³n de banners y marcadores `data-tour` en todas las subvistas.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Errores de refresh token suprimidos en consola de desarrollo vÃ­a middleware SSR.
  - [x] AC 2: Spotlight Tour con iluminaciÃ³n y transparencia real sobre el selector enfocado sin oscurecimiento interno.
  - [x] AC 3: FAQs completas disponibles en acordeones categorizados con apertura por defecto segÃºn la ruta activa.
  - [x] AC 4: Soporte directo a `servicios@ryctech.dev` con copia al portapapeles y enlace mailto.
  - [x] AC 5: MenÃº de opciones unificado al pie de la barra lateral y botÃ³n directo simplificado a "Instalar Apps".
---

### 2026-08-31 22:01 | App/Componente: web | Autor: AGENT_ROLE

* **DescripciÃ³n:** SoluciÃ³n integral de reactividad en el Store de Dispositivos para `FechaReg`:
  1. IdentificaciÃ³n y correcciÃ³n en `DispositivosViewProvider.tsx`: el hook `useState(initialDispositivos)` no se sincronizaba cuando el Server Component del layout revalidaba y entregaba nuevas propiedades (incluyendo la columna `FechaReg`).
  2. ImplementaciÃ³n de `useEffect` reactivos para sincronizar `dispositivos`, `billeteras` y relaciones cada vez que `initialProps` se actualiza desde el servidor.
  3. VerificaciÃ³n exitosa en base de datos Supabase confirmando que `Caja 1` posee `FechaReg: "2026-08-10 19:44:13.692606+00"`, renderizÃ¡ndose correctamente como `10/08/2026` en hora de PerÃº (UTC-5).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:**
    - [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx): Efectos de sincronizaciÃ³n reactiva para `initialDispositivos`.
    - [dispositivos/[id]/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): Parser y fallback `disp.FechaReg || disp.created_at`.
  - **Base de Datos:** Verificada existencia de `FechaReg` en tabla `DispositivosXContratante`.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: La fecha de creaciÃ³n se sincroniza y se muestra con exactitud en formato DD/MM/YYYY.
  - [x] AC 2: El provider es reactivo ante cambios en los Server Components.
---

### 2026-09-01 21:35 | App/Componente: web | Autor: AGENT_ROLE

* **DescripciÃ³n:** OptimizaciÃ³n integral de Onboarding, Tours Guiados y UI de Licencias:
  1. **SpotlightTour Compacto y Arrastrable:** RediseÃ±o a tarjeta compacta (`w-[340px]`, `p-4.5`) con arrastre libre (Draggable) en escritorio con lÃ­mites de pantalla, y modo anclado inferior fijo (`bottom-3 left-3 right-3`) en dispositivos mÃ³viles.
  2. **Tours Condicionales Multi-Vista:**
     - Dashboard General: pasos condicionales para actividad diaria de cobros (estado vacÃ­o vs ingresos por terminal y auditorÃ­a de alertas).
     - Dispositivos: eliminaciÃ³n de paso exterior redundante al ingresar a la vista detallada de una caja (`/dispositivos/[id]`).
     - Gestionar Licencias: incorporaciÃ³n del paso explicativo de Personalizar / Renovar Plan y respiro perimetral con margen en el foco de Plan Actual y Saldo Disponible.
  3. **MÃ³dulo de Licencias (`/dashboard/licencias`):**
     - Desacoplamiento de columnas con `items-start` para alturas naturales sin deformaciones.
     - ExtracciÃ³n de acordeones de cola e historial en `LicenciasAccordionGroup.tsx` con lÃ­mite de altura `max-h-[calc(100vh-280px)]` y scroll interno.
     - Limpieza de banners redundantes y alineaciÃ³n a la izquierda del estado sin plan activo con CTA "Adquirir Licencia".
  4. **Modal Informativo y Subtour en Gestionar Licencias (`/dashboard/licencias/gestionar`):**
     - CreaciÃ³n de `GestionarLicenciasTourManager.tsx` con modal automÃ¡tico informativo de renovaciÃ³n para cuentas sin plan o vencidas.
     - Hero card adaptativo (2 columnas simÃ©tricas con divisor central vs 3 columnas con botÃ³n a la derecha).
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados / Creados:**
    - [SpotlightTour.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SpotlightTour.tsx): Tarjeta arrastrable con listeners de ratÃ³n, limitadores perimetrales, docking responsive mÃ³vil y definiciÃ³n de tours.
    - [page.tsx (licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/page.tsx): Limpieza de banner y alineaciÃ³n a la izquierda.
    - [LicenciasAccordionGroup.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/LicenciasAccordionGroup.tsx): Acordeones con scroll interno independiente.
    - [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx): Hero card adaptativo, respiro visual de spotlight y marcado data-tour.
    - [GestionarLicenciasTourManager.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/GestionarLicenciasTourManager.tsx): Modal informativo de suscripciÃ³n y gestor de tour.
    - [DashboardClient.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/DashboardClient.tsx): Marcado data-tour condicional en actividad, terminales y alertas.
    - [dispositivos/[id]/page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx): RemociÃ³n de data-tour redundante en contenedor exterior.
  - **Base de Datos:** Ninguno.
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Tarjeta de tour compacta, arrastrable en escritorio y no invasiva en mÃ³vil.
  - [x] AC 2: Tours adaptativos que omiten pasos innecesarios y explican secciones condicionales.
  - [x] AC 3: Vista de licencias y acordeones con scroll contenido y alineaciÃ³n simÃ©trica.
  - [x] AC 4: Subtour de gestionar licencias detectable desde el FAB de ayuda y banner superior.
---

### 2026-09-06 12:10 | App/Componente: web | Autor: AGENT_ROLE / HUMAN

* **DescripciÃ³n:** MigraciÃ³n de infraestructura de despliegue web (EasyPanel / VPS) y actualizaciÃ³n de enrutamiento DNS:
  1. **MotivaciÃ³n y Costos:** ReubicaciÃ³n de la instancia de EasyPanel debido a la expiraciÃ³n inminente del VPS original de Hostinger, migrando hacia un nuevo VPS con vigencia extendida hasta enero del prÃ³ximo aÃ±o para optimizaciÃ³n presupuestaria.
  2. **ConfiguraciÃ³n EasyPanel:** Despliegue de servicio `App` enlazado al repositorio `ChristopherPinedoGutierrez/NotificaPe_Web` mediante compilaciÃ³n por `Dockerfile`, inyecciÃ³n de variables de entorno de producciÃ³n y exposiciÃ³n en puerto `3000`.
  3. **DNS y SSL:** ActualizaciÃ³n en Namecheap del `A Record` para el subdominio `notificape` (Host: `notificape`, Dominio: `ryctech.dev`) apuntando a la nueva IP pÃºblica `31.220.50.238`. VerificaciÃ³n de resoluciÃ³n HTTP 200 y enrutamiento con Traefik/Let's Encrypt.
* **Detalles TÃ©cnicos:**
  - **Archivos Modificados:** Ninguno a nivel de cÃ³digo fuente (despliegue continuo 100% stateless vÃ­a Git).
  - **Infraestructura:**
    - Host anterior: `2.24.79.225` (Desmantelado / PrÃ³ximo a vencer).
    - Host nuevo: `31.220.50.238` (Vigencia Enero 2027 / Hostinger VPS).
    - Proxy / SSL: Traefik integrado en EasyPanel con Let's Encrypt para `notificape.ryctech.dev`.
  - **Base de Datos:** Sin impacto (persistencia centralizada en Supabase).
* **Criterios de AceptaciÃ³n (AC) Validados:**
  - [x] AC 1: Dockerfile compila correctamente en el nuevo EasyPanel y responde con HTTP 200 OK en puerto 3000.
  - [x] AC 2: Registro A en Namecheap (`notificape` -> `31.220.50.238`) actualizado y propagado a nivel global.
  - [x] AC 3: Sin interrupciÃ³n en servicios de base de datos ni variables de entorno productivas.
---


  
---  
### [2026-09-18 17:24] | App/Componente: web | Autor: AGENT_ROLE  
  
* **Descripci�n:** Mejora de UX en el indicador de estado Realtime y protecci�n inteligente de navegaci�n.  
* **Detalles T�cnicos:**  
  - **Archivos Modificados:** [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx), [page.tsx (dispositivos)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/[id]/page.tsx)  
  - Se elimin� el bloqueo global en RealtimeProvider y se implement� un candado inteligente en SidebarNav evaluando navigator.onLine para proteger de pantallas 404/dinosaurio sin asfixiar la navegaci�n SPA cuando el socket entra en backoff.  
* **Criterios de Aceptaci�n (AC) Validados:**  
  - [x] AC 1: Navegaci�n libre durante desconexiones temporales del socket sin arrojar Toast rojo.  
  - [x] AC 2: Bloqueo seguro e inmediato si el dispositivo pierde la red f�sica (isPhysicalOffline = true).  
--- 
---
### [2026-09-18 22:46] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Implementación completa del flujo de captación de Beta Testers (Closed Testing).
* **Detalles Técnicos:**
  - **Archivos Modificados:** LandingTabs.tsx, BetaRegistrationForm.tsx (nuevo), SuperadminSidebar.tsx, rutas /superadmin/beta/* (nuevas).
  - **Base de Datos:** Se creó tabla BetaTesters y políticas RLS para registro anónimo y lectura protegida en Supabase.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La Landing muestra la pestaña Únete de forma prominente.
  - [x] AC 2: Validaciones de campos (30 char max, 9 dígitos cel Perú, @gmail.com).
  - [x] AC 3: El panel superadmin permite ver, copiar y contactar vía WhatsApp a los inscritos.
---
---
### [2026-09-29 18:46] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Corrección de la reactividad Realtime en Dashboard al desvincular o recibir solicitudes de acceso.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DispositivosViewProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/dispositivos/DispositivosViewProvider.tsx), [RealtimeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/RealtimeProvider.tsx)
  - **Base de Datos:** Ninguno (Corrección de sintaxis en el filtro del socket: envoltura de columnas CamelCase en comillas dobles).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La vista web de dispositivos refleja los cambios de desvinculación ('HardwareId' nulo) en tiempo real sin F5.
  - [x] AC 2: La campana de accesos pendientes recibe los eventos de 'AutorizacionesXUsuario' en tiempo real correctamente.
---

---
### [2026-10-02 22:00] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Rediseño integral de la vista de Usuarios y Accesos (/dashboard/accesos) con agrupación por dispositivos, bandeja de pendientes y modales de confirmación.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/page.tsx), [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx)
  - **Base de Datos:** Ninguno (Consumo de DispositivosXContratante, AutorizacionesXUsuario, Usuarios y EstadosAuth).
  - Se implementó la Opción 1: Bandeja superior de atención inmediata para solicitudes pendientes (IdEstadoAuth = 1), agrupación en tarjetas/acordeones por dispositivo con metadatos (Alias, PIN con copiado, estado de conexión), barra de herramientas con buscador y filtros por estado.
  - Se corrigió la terminología del sistema sustituyendo referencias de 'Caja' por 'Dispositivo'.
  - Se aseguraron los botones de acción (Aprobar y Bloquear) con modales de confirmación explícitos para prevenir clics accidentales, respetando los estados existentes (Pendiente, Aprobado, Bloqueado) sin introducir Rechazado.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Los vendedores se visualizan agrupados jerárquicamente bajo su respectivo dispositivo con orden prioritario.
  - [x] AC 2: La bandeja superior destaca al instante las peticiones pendientes de aprobación.
  - [x] AC 3: Las acciones de aprobar y bloquear requieren confirmación en modal.
  - [x] AC 4: Se preserva la reactividad en tiempo real de Supabase y el contador en la barra de navegación.
---

---
### [2026-10-02 22:08] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Pulido visual de la vista Usuarios y Accesos: eliminación de subtítulo redundante, alineación del indicador al nivel del título general y distinción visual entre badges de estado y botones de acción.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [page.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/page.tsx), [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx)
  - Se eliminó el subtítulo redundante 'Peticiones y Personal Activo' y el contenedor envolvente, alineando los acordeones al margen del título.
  - Se subió el indicador de personal activo ('X de Y activos') a la fila superior derecha del PageContainer.
  - Se cambió la cabecera de la columna a 'USUARIO'.
  - Se rediseñaron los botones de acción con mayor presencia, tamaño y relieve para distinguirlos de los badges pasivos de estado.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Indicador de cupo alineado a la derecha en la cabecera principal.
  - [x] AC 2: Eliminación de padding y subtítulos redundantes.
  - [x] AC 3: Columna rotulada como 'USUARIO'.
  - [x] AC 4: Botones interactivos con presencia clara frente a los pills pasivos de estado.
---

---
### [2026-10-02 22:15] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Aplicación del estilo filled sólido con alto contraste en todos los botones de acción de Usuarios y Accesos, preservando el pill pasivo en la columna de estado.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx)
  - Se estandarizaron los botones de acción (Aprobar, Reactivar, Bloquear y Reemplazar) a tipo filled sólido con texto e icono en blanco (emerald-600 y rose-600), alineados visualmente a los selectores activos del menú de filtros.
  - Se preservó la columna ESTADO como pill suave y translúcido (rounded-full), garantizando un contraste evidente e inequívoco frente a los botones de acción en tema claro y oscuro.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Botones de acción tipo filled sólido (verde/rojo con texto blanco) y relieve interactivo.
  - [x] AC 2: Indicador de estado preservado como pill pasivo.
  - [x] AC 3: Consistencia y contraste garantizado en modo claro y oscuro.
---

---
### [2026-10-02 22:25] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Implementación del ordenamiento alfabético estable por nombre de usuario (A-Z) e integración del selector de criterio de ordenamiento en la barra de herramientas.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx)
  - Se eliminó el ordenamiento jerárquico por estado que desplazaba las filas al bloquear, garantizando una posición vertical estable.
  - El criterio por defecto es alfabético estricto (A - Z) por NombreCompleto usando 'localeCompare'.
  - Se retiró el botón de colapso masivo en favor del control individual por dispositivo y se añadió en su lugar un selector de ordenamiento con icono 'ArrowUpDown' que ofrece: Nombre (A - Z), Nombre (Z - A), Fecha (Más reciente) y Fecha (Más antigua).
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Posición visual estable sin desplazamientos forzados al aprobar o bloquear.
  - [x] AC 2: Ordenamiento por defecto A - Z por nombre de usuario.
  - [x] AC 3: Selector dinámico de ordenamiento (Nombre y Fecha) activo en toolbar.
  - [x] AC 4: Acordeones de dispositivos operan de forma independiente.
---

---
### [2026-10-02 22:30] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Reemplazo del selector de texto por un botón compacto con icono tradicional de filtro/embudo (Filter) y menú flotante de selección de ordenamiento.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [TeamTable.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/accesos/TeamTable.tsx)
  - Se sustituyó el select con texto visible por un botón compacto con el icono de embudo estándar ('Filter'), optimizando el ancho de la toolbar.
  - El botón despliega un menú flotante con fondo difuminado (backdrop-blur) y cierre por clic exterior ('useRef' + 'mousedown').
  - Las opciones de ordenamiento (Nombre A-Z [default], Nombre Z-A, Fecha reciente, Fecha antigua) se muestran exclusivamente dentro de dicho menú con marca de verificación 'Check'.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Botón compacto con icono tradicional de embudo (Filter).
  - [x] AC 2: Texto descriptivo visible solo dentro del menú desplegable.
  - [x] AC 3: Menú emergente con cierre al hacer clic fuera.
  - [x] AC 4: Opción activa señalizada con check azul.
---

---
### [2026-10-03 20:00] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Rediseño de la tarjeta de disputas y actualización de vista de base de datos para desambiguar perfiles homónimos y mostrar contexto bancario.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [DisputaCard.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/notificaciones/disputadas/DisputaCard.tsx)
  - **Base de Datos:** Actualización in-place mediante CREATE OR REPLACE VIEW en view_notificaciones_disputadas añadiendo ContenidoMsg, Correo, FotoUrl, EquipoMarca, EquipoModelo, y JustificacionConflicto.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Visualización del texto original de la notificación bancaria (ContenidoMsg).
  - [x] AC 2: Desambiguación de usuarios mediante correo electrónico, foto de perfil e identificación de dispositivo móvil.
  - [x] AC 3: Renderizado diferenciado de observación inicial de captura y justificación de conflicto.
---


---
### [2026-10-04 19:30] | App/Componente: web | Autor: AGENT_ROLE

* **Descripción:** Reestructuración comercial de la Landing Page, modal de promociones y beneficios activos, layout de 2 columnas en pestaña de prueba, validaciones reactivas y erradicación del parpadeo blanco (FOUC).
* **Detalles Técnicos:**
  - **Archivos Modificados:** [BetaRegistrationForm.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/BetaRegistrationForm.tsx), [LandingTabs.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingTabs.tsx), [LandingPromoModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/LandingPromoModal.tsx), [ThemeProvider.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/ThemeProvider.tsx), [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/layout.tsx), [globals.css](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/globals.css)
  - **Base de Datos:** Ninguno.
  - **Comunicación Comercial:** Se eliminaron términos técnicos ("Beta", "Beta Testers", etc.) reemplazándolos por conceptos comerciales directos ("Prueba gratuita", "Acceso anticipado", "Bono de bienvenida", "Gana por recomendar").
  - **Modal Promocional (`LandingPromoModal`):** Implementación de modal centrado con persistencia selectiva (`localStorage` únicamente al presionar "No volver a mostrar"), diseño calibrado a ~408px sin glows desbordantes que asegura despliegue simétrico y sin scrollbar tanto en monitores de 720p como 1080p.
  - **Layout de Pestaña Únete:** Distribución en 2 columnas niveladas (`items-stretch`, `h-full flex flex-col justify-between`) entre los pasos ilustrados y el formulario, con padding inferior adaptado hacia el footer.
  - **Validaciones en Formulario:** Validación reactiva en `onChange` y `onBlur` para nombres (sin números), cuentas Gmail (terminación estricta `@gmail.com`) y celular (9 dígitos empezando en 9), con resaltado en rojo y mensajes instantáneos.
  - **Prevención de FOUC:** Eliminación del bloqueo `if (!mounted)` en `ThemeProvider` para permitir que `next-themes` inyecte su script síncrono en SSR, adición de `dark` por defecto en la etiqueta `<html>`, y remoción de transiciones de color en la carga inicial.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Lenguaje comercial claro y comprensible para comerciantes peruanos en toda la Landing.
  - [x] AC 2: Modal de promociones con 3 tarjetas informativas, centrado perfecto y sin barra de scroll en resoluciones de 720p y 1080p.
  - [x] AC 3: Botón 'No volver a mostrar' con persistencia en localStorage; botón (X) y botón principal sin bloqueo permanente.
  - [x] AC 4: Layout de 2 columnas simétrico a igual altura en la pestaña 'Únete a la prueba' con separación natural hacia el footer.
  - [x] AC 5: Validaciones reactivas en inputs de registro con alertas contextuales inmediatas.
  - [x] AC 6: Carga en modo oscuro instantánea sin parpadeo blanco (FOUC).
---

---
### [2026-10-05 14:26] | App/Componente: Web Dashboard | Autor: AGENT_ROLE (Orquestador SDD)

* **Descripción:** Integración de fallback Just-In-Time (JIT) en DashboardLayout para auto-promoción reactiva de licencias en cola sin corte de servicio.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [layout.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/layout.tsx)
  - **Base de Datos:** Consumo de la RPC `activar_licencia_cola_si_aplica` en SSR ante ausencia de licencia activa vigente.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Typecheck de TypeScript aprobado con 0 errores (`tsc --noEmit`).
  - [x] AC 2: Servidor de desarrollo Next.js levantado exitosamente en `http://localhost:3000`.
  - [x] AC 3: Acceso al Dashboard promueve la cola al vuelo sin redirección forzada a catálogo cuando el cliente tiene licencias programadas.
---

---
### [2026-10-05 19:30] | App/Componente: Web Dashboard & B2B Integrations | Autor: AGENT_ROLE (Orquestador SDD)

* **Descripción:** Implementación completa del módulo de Integraciones B2B y Webhooks Unidireccionales [CR-016], visualizador de claves HMAC, panel de auditoría de entregas, documentación interactiva y add-on comercial en gestión de licencias.
* **Detalles Técnicos:**
  - **Archivos Modificados / Creados:**
    - [actions.ts (Integraciones)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/integraciones/actions.ts): Server Actions para CRUD de webhooks, consulta de cuotas (`get_cuota_webhooks`), regeneración de secretos HMAC y despacho de prueba.
    - [page.tsx (Integraciones)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/integraciones/page.tsx): Server component con metadata y carga paralela SSR.
    - [IntegracionesClientView.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/integraciones/IntegracionesClientView.tsx): Vista cliente integral con tarjetas de cuota, listado reactivo de endpoints, estados de salud, inspector de payload y switches de activación.
    - [WebhookFormModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/integraciones/WebhookFormModal.tsx): Modal de alta/edición de webhook con soporte para autenticación abierta, Bearer Token y cabecera personalizada, además de selector de cajas/dispositivos emisores.
    - [WebhookTestModal.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/integraciones/WebhookTestModal.tsx): Modal de prueba interactiva en tiempo real con simulación de payload, cálculo de latencia en milisegundos y captura de cuerpo de respuesta del servidor destino.
    - [WebhookDocsAccordion.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/integraciones/WebhookDocsAccordion.tsx): Guía técnica para desarrolladores con especificación de cabeceras, formato JSON y código de verificación criptográfica (Node.js, PHP y Python).
    - [SidebarNav.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/components/SidebarNav.tsx): Incorporación de la pestaña "Integraciones B2B" con icono Network en el menú de navegación del dashboard.
    - [WizardGestionarLicencias.tsx](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/gestionar/WizardGestionarLicencias.tsx) y [actions.ts (Licencias)](file:///c:/Trabajo/Proyectos/NotificaPe/web/src/app/dashboard/licencias/actions.ts): Integración de add-on `extraWebhooks` (S/ 30.00/mes c/u, máx 10) en stepper de compra, renovación y personalización de planes activos.
  - **Base de Datos & Edge Functions:** Integrado con tablas `WebhooksXContratante` y `EntregasWebhooks`, función RPC `get_cuota_webhooks` y Edge Function desplegada `dispatch-webhook` en Supabase.
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: Typecheck de TypeScript aprobado con 0 errores (`tsc --noEmit`).
  - [x] AC 2: Build de producción exitoso en Next.js 16 (`next build`) con Turbopack.
  - [x] AC 3: Soporte para 3 modalidades de autenticación del cliente (Ninguna / Bearer / Cabecera custom) con firma HMAC-SHA256 obligatoria (`X-NotificaPe-Signature`).
  - [x] AC 4: Control comercial de límites por plan y add-ons integrado en la cotización y pago de licencias.
  - [x] AC 5: Servidor local de desarrollo levantado y respondiendo en `http://localhost:3000`.
---