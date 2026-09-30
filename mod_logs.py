from datetime import datetime
file_path = r'C:\Trabajo\Proyectos\NotificaPe\NotificaPe_Specs\management\changelogs\changelog_viewer.md'
with open(file_path, 'r', encoding='utf-8') as f: content = f.read()

entry = '''---
### [YYYY-MM-DD HH:MM] | App/Componente: viewer | Autor: AGENT_ROLE

* **Descripción:** Implementación de Cola Adaptativa FCM (Smart Batching), Supresión Contextual en primer plano e Inyección Silenciosa a Bandeja.
* **Detalles Técnicos:**
  - **Archivos Modificados:** [FCMReceiverService.kt](file:///../viewer/app/src/main/java/com/notificape/viewer/service/FCMReceiverService.kt), [NotificationQueueManager.kt](file:///../viewer/app/src/main/java/com/notificape/viewer/service/NotificationQueueManager.kt), [build.gradle.kts](file:///../viewer/app/build.gradle.kts)
  - **Base de Datos:** Ninguno
* **Criterios de Aceptación (AC) Validados:**
  - [x] AC 1: La notificación visual se entrega a la bandeja del sistema instantáneamente en cada Push, evitando que se pierda la información si Android mata el proceso.
  - [x] AC 2: Si el usuario tiene la app abierta en primer plano (Lifecycle RESUMED), se suprime completamente la voz y el pop-up, actualizando solo la lista visual.
  - [x] AC 3: Si llegan 1 o 2 notificaciones juntas en background, se leen de forma individual. Si llegan 3 o más, se agrupan en un solo bloque con suma de montos y se emite un único pop-up y voz de resumen.
---
'''

entry = entry.replace('YYYY-MM-DD HH:MM', datetime.now().strftime('%Y-%m-%d %H:%M'))
content += '\n' + entry

with open(file_path, 'w', encoding='utf-8') as f: f.write(content)

orq_path = r'C:\Trabajo\Proyectos\NotificaPe\NotificaPe_Specs\management\changelogs\orquestador.md'
with open(orq_path, 'r', encoding='utf-8') as f: orq = f.read()
orq_entry = '* **[' + datetime.now().strftime("%Y-%m-%d %H:%M") + ']** | App: viewer | Tipo: UI/Service | Refactorización de Cola FCM con Smart Batching y entregas silenciosas. Ver [changelog_viewer.md](file:///../NotificaPe_Specs/management/changelogs/changelog_viewer.md)\n'
orq += orq_entry
with open(orq_path, 'w', encoding='utf-8') as f: f.write(orq)
