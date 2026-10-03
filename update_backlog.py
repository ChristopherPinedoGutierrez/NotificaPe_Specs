import re

with open('management/BacklogGlobal.md', 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r"- \[ \] App: db/web \| Tarea 7\.3: Implementar Edge Function / Trigger para evaluación atómica.*", r"- [x] App: db/web | Tarea 7.3: Implementar Edge Function / Trigger para evaluación atómica de campañas en el registro e inyectar el ABONO automático.", content)
content = re.sub(r"- \[ \] App: web \| Tarea 7\.5: Adaptar UI de Registro para aceptar códigos de invitación y crear componente dinámico.*", r"- [x] App: web | Tarea 7.5: Adaptar UI de Registro para aceptar códigos de invitación y crear componente dinámico (GlobalAnnouncementModal) en el Dashboard.", content)

# Append Epic 10
epic = '''

### Épica 10: Motor Centralizado de Anuncios y Novedades (SaaS)
- [ ] App: db/web | Tarea 10.1: Crear tabla CampanasInformativas en Supabase y panel CRUD en Superadmin para redactar y disparar avisos remotos.
- [ ] App: web | Tarea 10.2: Conectar GlobalAnnouncementModal a la tabla de avisos para despliegue dinámico.

### Épica 11: Mejora UX/UI del Gestor de Accesos y Dispositivos
- [ ] App: web | Tarea 11.1: Refactorizar la vista de gestión de accesos agrupando los usuarios (vendedores) por dispositivo/caja asignada.
- [ ] App: web | Tarea 11.2: Implementar modales de confirmación para acciones críticas (Revocar, Eliminar) previniendo clics accidentales.
'''
content += epic

with open('management/BacklogGlobal.md', 'w', encoding='utf-8') as f:
    f.write(content)
