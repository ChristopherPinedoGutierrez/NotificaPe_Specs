# Guía de Pruebas y Trazabilidad: Fluco FCM y Notificaciones

Esta guía documenta el comportamiento arquitectónico y los filtros de diagnóstico en Logcat tras la migración de WebSockets a Firebase Cloud Messaging (FCM) (Epic CR-008).

## Filtro Logcat Obligatorio (Android Studio)
Para observar todo el flujo de negocio ignorando el ruido del sistema, utiliza exactamente el siguiente filtro en la barra de búsqueda del nuevo Logcat:
`package:mine (tag:FCMReceiverService | tag:NotificaPe | tag:NotificationService | tag:Scavenger | tag:NOTIFICAPE_DEBUG)`

## Escenarios de Comportamiento Esperado

### 1. Pérdida de Internet / Modo Avión
- **Comportamiento:** Si llega una notificación bancaria mientras el equipo no tiene red (ej. los SMS llegan en modo avión si hay señal celular, o cortes intermitentes de WiFi), el `NotificationReceiverService` intercepta el evento porque opera 100% de manera local (Local-First).
- **Proceso:** 
  1. Se borra visualmente la notificación del banco en milisegundos.
  2. Se inserta en la DB local (`Room`).
  3. Se genera la notificación agrupadora (InboxStyle) de NotificaPe.
  4. Al intentar subir a Supabase, arroja fallo y delega la tarea al `SyncWorker`.
- **Log esperado:** `⚠️ Falla de subida detectada. Programando reintento automático con SyncWorker.`

### 2. Evitando Duplicidad de Notificaciones (Doble Ingesta)
- **Comportamiento:** Es imposible registrar la misma notificacil;n dos veces.
- **Defensa Local (Room):** `NotificationDao` usa `OnConflictStrategy.REPLACE` basado en una clave determinista (combinación de hash de título, cuerpo y milisegundo exacto).
- **Defensa Nube (Supabase):** `SyncRepository` hace un `UPSERT` sobre `IdNotificacionLocal` e `IdDispositivo`. Si el `SyncWorker`  reintenta subir algo que ya estaba en Supabase, simplemente lo sobreescribe de forma idempotente o la DB rechaza el conflicto y el repositorio lo marca como sincronizado (`sacándolo de la cola`).

### 3. Sincronizacil;n Silenciosa de Filtros y Configuracil;n
- **Comportamiento:** Al editar reglas o billeteras desde el Panel Web, el Dispatcher de Supabase envía un mensaje FCM invisible a Android.
- **Logs esperados:**
  - Reglas: `Recibido SYNC_RULES. Sincronizando filtros...`
  - Billeteras: `Recibido SYNC_WALLETS. Descargando billeteras...`
  - Estado Dispositivo: `Recibido SYNC_DEVICE_STATUS. Actualizando status...`
