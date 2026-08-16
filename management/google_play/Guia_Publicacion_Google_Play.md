# Guía de Publicación y Revisión en Google Play (NotificaPe Admin)

Esta guía desmitifica el proceso de revisión de Google Play y detalla los pasos exactos que debes seguir para publicar tu aplicación `Admin` sin fricciones.

> [!NOTE]
> **¿Qué hace realmente un revisor de Google Play?**
> Los revisores no son probadores de QA de tu modelo de negocio. Su único objetivo es **buscar violaciones a las políticas de la tienda** (malware, pornografía, evasión de pagos, abuso de permisos, recolección ilegal de datos).

## 1. Resolviendo tus dudas sobre cómo prueban la app

*   **¿Necesitan descargar billeteras de Perú (Yape/Plin)?**
    *   **No.** No les importa tu lógica de negocio de terceros. No van a intentar recibir un pago real.
*   **¿Necesitan acceso a tu panel web?**
    *   **No.** Solo revisan el APK (la aplicación Android) que enviaste. No van a entrar a tu página web ni evaluar tu backend.
*   **¿Cómo prueban el Realtime o si funciona sin WiFi?**
    *   **No lo prueban a profundidad.** Verificarán que la app no se crashee al abrirse y que los botones de la interfaz reaccionen. Las pruebas de red las hacen bots automatizados buscando "fugas de memoria" o "consumo excesivo", no pruebas funcionales de tu WebRTC o Supabase.
*   **¿Qué es lo que realmente analizan?**
    1. Que la app inicie sin crashear.
    2. Si pide permisos críticos (como leer notificaciones), comprueban que tu Ficha de Play Store y tu Video Demostrativo justifiquen ese permiso.
    3. Que no haya enlaces externos para evadir su pasarela de pagos (esto ya lo solucionamos en el código).

---

## 2. Cómo darles acceso (El problema del QR de un solo uso)

Tienes mucha razón en tu observación: si tu código QR o código manual es de **un solo uso** (se regenera o borra tras usarse), el primer revisor consumirá el código y el segundo revisor se quedará bloqueado, provocando un rechazo automático. 

Para solucionar esto, **NO debes crear un inicio de sesión falso en la aplicación Android**, ya que si la app no se conecta a un registro real en tu base de datos, fallará al intentar enviar datos (Heartbeats, Realtime) y los revisores la rechazarán por mal funcionamiento. 

La solución ya ha sido implementada directamente en el código de tu aplicación Android (`DeviceLinker.kt`). Hemos programado una excepción para un código específico.

**Paso a paso para el Bypass de Revisión:**
1. Entra a tu panel web de NotificaPe (como cliente) y crea un dispositivo de prueba definitivo (ej. "Dispositivo Google Play").
2. Ve a la base de datos Supabase (Editor SQL) y fuerza que el `CodigoAcceso` de ese dispositivo sea **exactamente** `GPLAY1` (o edítalo desde la tabla).
3. Hazle una captura de pantalla al Código QR que te genera la web (o simplemente anota el código `GPLAY1`).
4. Sube esa imagen a un lugar público (por ejemplo, a Imgur o a tu propio servidor) para obtener un link (ej. `https://tu-dominio.com/qr-prueba.jpg`).
5. En la Consola de Google Play, ve a **Contenido de la aplicación -> Acceso a la app** y selecciona "Se requiere autenticación".
6. En las instrucciones, pon: *"Esta app es un nodo de lectura para nuestro SaaS B2B. Para iniciar sesión, escanee el Código QR en esta URL: https://tu-dominio.com/qr-prueba.jpg o ingrese manualmente el código de 6 dígitos: GPLAY1."*

**¿Por qué funciona esto?** He modificado el código Android para que, si detecta el código `GPLAY1` (que cumple con la regla estricta de tener exactamente 6 caracteres sin guiones), realice la vinculación con el dispositivo en la base de datos pero **omita** el paso de rotar (cambiar) el código. De esta forma, cualquier número de revisores (o bots automáticos) podrán usar el mismo código infinitas veces sin bloqueos.

---

## 3. El Video Demostrativo (Policy Video)

Al usar el permiso `NotificationListenerService` (para capturar pagos de Yape) y un `Foreground Service` (para funcionar con la pantalla apagada), Google te exige un video. **No intentes saltarte este paso, el rechazo es automático.**

**Cómo grabarlo:**
1. Instala la app en tu celular personal.
2. Usa el grabador de pantalla nativo de tu teléfono (suele estar en la barra de ajustes rápidos arriba) o descarga una app gratuita como **"XRecorder"** o **"AZ Screen Recorder"** desde la Play Store.
3. **El Guion del video:**
    *   **Duración:** No hay un mínimo estricto. **Puede durar solo 30 o 45 segundos**, siempre y cuando sea claro. No debe ser largo.
    *   **Alcance:** ¡NO tienes que mostrar cada vista de la app ni explicar todo el sistema! Los revisores de políticas solo quieren ver *por qué* pides el permiso de notificaciones y que funciona correctamente.
    *   **Paso 1:** Abre la app y muestra el momento exacto en que te pide el permiso de Notificaciones (cuando sale la pantalla de ajustes de Android para darle acceso a "NotificaPe"). Acéptalo.
    *   **Paso 2:** Con la app abierta en pantalla, envíate a ti mismo una notificación de prueba (usa el botón "Mock" que programamos, o envíate un mensaje de WhatsApp que simule ser Yape si tienes el regex). Muestra que la app captura la notificación.
    *   **Paso 3:** Minimiza la app (vuelve al inicio de tu Android, pantalla principal) y vuelve a enviarte una notificación. Demuestra que el servicio en segundo plano está capturándola correctamente. FIN del video.
4. Sube este video a YouTube como **"Oculto" (Unlisted)** y pega el link en el formulario de la Consola de Google Play (cuando te salga la tarea en "Permisos confidenciales").

---

## 4. Los Activos Gráficos (Icono y Gráfico de Funciones)

Para publicar, Google exige dos imágenes obligatorias. Ambas van en la sección **Crecimiento -> Presencia en Google Play -> Ficha de Play Store principal**:

*   **Ícono de la aplicación (512x512 px):**
    *   **Formato:** PNG de 32 bits o JPEG.
    *   **Fondo:** **Debe tener fondo sólido** (blanco o del color de tu marca). No se permiten fondos transparentes.
    *   **Contenido:** Es tu logo completo centrado. No le pongas bordes redondeados a la imagen; envíala cuadrada. Google Play se encarga de recortarle los bordes automáticamente para que se vea redondeado en los celulares.
*   **Gráfico de funciones (Banner 1024x500 px):**
    *   **¿Qué es?** Es la imagen promocional horizontal (tipo portada de Facebook) que aparece arriba del todo cuando alguien entra a tu app en la tienda.
    *   **Criterio:** No debe ser un fondo blanco vacío. Debe ser atractivo. Puedes poner un fondo con el color principal de NotificaPe, tu logo en grande en el centro, o una imagen abstracta de tecnología/notificaciones. Trata de mantener los elementos importantes al centro, ya que los bordes a veces se recortan un poco según la pantalla.

## 5. Paso a Paso en la Consola (Completar la Configuración)

Según tu consola, debes completar exactamente esta lista de tareas en orden para desbloquear la fase de Pruebas Cerradas. Ve haciendo clic en cada una:

### A. "Cuéntanos de qué se trata el contenido de la app"
1.  **Configura la política de privacidad:** Te pedirá una URL. Debes tener una página web básica con tu política de privacidad. Si no tienes, puedes generar una gratis en sitios como *privacypolicygenerator.info* y alojarla en tu web o en un Google Sites/Notion público.
2.  **Detalles de acceso:** Selecciona "Todas las funciones están restringidas". En instrucciones pon: *"Para iniciar sesión, escanee el Código QR en esta URL: [tu-link-imgur] o ingrese manualmente el código de 6 dígitos: GPLAY1."* (No pongas usuario/contraseña).
3.  **Anuncios:** Marca **"No, mi app no contiene anuncios"**.
4.  **Clasificación de contenido:** Inicia el cuestionario. Tu categoría es "Utilidades, Productividad o Comunicación". Responde "No" a todo (violencia, drogas, lenguaje ofensivo). Te dará una clasificación de "Apto para todo público" (PEGI 3).
5.  **Público objetivo:** Marca **18 años o más**. (Es un SaaS B2B, no es para niños). En la siguiente pregunta marca que la app *no* atrae involuntariamente a los niños.
6.  **Seguridad de los datos (Data Safety):**
    *   ¿Recopila o comparte datos? **Sí**.
    *   ¿Están cifrados en tránsito? **Sí** (van por HTTPS a Supabase).
    *   ¿Permites que los usuarios borren datos? **Sí** (desde el panel web).
    *   En la lista de datos, marca **Información financiera** -> "Historial de compras / Otra info financiera". Luego indica que se recopila para la "Funcionalidad de la aplicación" y que es "Obligatorio".
7.  **Apps gubernamentales:** Marca **"No"**.
8.  **Funciones financieras:** Marca **"Mi app no proporciona ninguna función financiera"** (No eres un banco, ni das préstamos ni criptomonedas, solo lees notificaciones de un dispositivo).
9.  **Salud:** Marca **"Mi app no es de salud"**.

### B. "Administra cómo se organiza y presenta la app"
10. **Selecciona la categoría:** Selecciona "App" (no juego) y Categoría: **Productividad o Empresa**. Ingresa tu correo de soporte y guarda.
11. **Configura la ficha de Play Store:**
    *   **Nombre de la app:** NotificaPe Admin.
    *   **Descripciones:** Llena una breve ("Nodo de captura de notificaciones para comercios") y una larga explicando tu SaaS.
    *   **Ícono (512x512):** Sube el ícono morado `icon_admin.jpg`.
    *   **Gráfico de funciones (1024x500):** Sube el banner morado `banner_admin.jpg`.
    *   **Capturas de pantalla del teléfono:** Tómale 2 o 3 capturas de pantalla a la app funcionando en tu celular (ej. la pantalla de escáner y la pantalla principal) y súbelas aquí.

### C. Desbloqueo de "Prueba Cerrada"
Una vez completados los 11 pasos anteriores, la sección de Prueba Cerrada se desbloqueará.
1.  **Seleccionar países y regiones:** Haz clic y selecciona tu país objetivo (ej. Perú) o todos los países.
2.  **Seleccionar verificadores:** Crea una lista de correos (tienen que ser correos de Google/Gmail) y pon ahí a tus **20 personas** de confianza.
3.  **Crea y lanza una versión:** *¡Atención aquí!* Como tu código ya fue subido vía GitHub Actions a Pruebas Internas, **NO necesitas subir un archivo nuevo**. Solo dale al botón "Promocionar desde versión de Pruebas Internas" o selecciona el archivo AAB que ya existe en tu biblioteca (la versión `v1.0.0`).
4.  **Enviar a Google para revisión:** Completa el flujo y dale enviar. 

Aquí es donde los humanos de Google revisarán tu aplicación (verán tu video de YouTube, probarán tu código `GPLAY1`). Si te aprueban, tus 20 verificadores recibirán un link para descargar la app y **empezará a correr el reloj de 14 días.**
