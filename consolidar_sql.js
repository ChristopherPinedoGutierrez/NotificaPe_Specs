const fs = require('fs');
const path = require('path');

const destDir = path.join(__dirname, 'management', 'database', 'scripts');
const adminDir = path.join('c:', 'Trabajo', 'Proyectos', 'NotificaPe', 'web', 'docs', 'app_android_admin');
const viewerDir = path.join('c:', 'Trabajo', 'Proyectos', 'NotificaPe', 'web', 'docs', 'app_android_user');

const tableToScript = {};
let maxCounter = 27;

// 1. Mapear Web Scripts (0001 - 0027) existentes para encontrar afinidad de tablas
const webFiles = fs.readdirSync(destDir).filter(f => f.endsWith('.sql') && f !== '0000_blueprint_data_model.sql');
for (const file of webFiles) {
    const content = fs.readFileSync(path.join(destDir, file), 'utf-8');
    // Buscamos nombres de tablas típicos en comandos DDL o DML
    const regex = /(?:ON|TABLE|INTO|FROM|UPDATE)\s+(?:public\.)?\"?([A-Za-z_]+)\"?/gi;
    let match;
    while ((match = regex.exec(content)) !== null) {
        const table = match[1];
        // Asignamos la tabla al script si no ha sido asignada antes
        // Ciertas palabras reservadas podrían cruzarse, pero esto es aproximado y efectivo.
        if (!['NEW', 'OLD', 'true', 'false', 'SELECT', 'INSERT', 'UPDATE', 'DELETE'].includes(table) && !tableToScript[table]) {
            tableToScript[table] = file;
        }
    }
}

const log = [];

function processDir(sourceDir, appName) {
    const files = fs.readdirSync(sourceDir).filter(f => f.endsWith('.sql'));
    for (const file of files) {
        const content = fs.readFileSync(path.join(sourceDir, file), 'utf-8');
        
        const regex = /(?:ON|TABLE|INTO|UPDATE)\s+(?:public\.)?\"?([A-Za-z_]+)\"?/gi;
        let match;
        let targetTable = null;
        
        while ((match = regex.exec(content)) !== null) {
            const table = match[1];
            if (tableToScript[table]) {
                targetTable = table;
                break; // Found a match
            }
        }

        if (targetTable) {
            // MERGE (Append al archivo existente)
            const targetFile = tableToScript[targetTable];
            const appendData = `\n\n-- ==========================================================================\n-- EXTENSIÓN (${appName}): Origen -> ${file}\n-- Porqué: Integrado durante auditoría por cruce de dominio (Tabla: ${targetTable})\n-- ==========================================================================\n\n${content}\n`;
            fs.appendFileSync(path.join(destDir, targetFile), appendData);
            log.push(`[MERGE IN-PLACE] ${appName}/${file} -> Anexado al archivo base '${targetFile}' (Afinidad: ${targetTable})`);
        } else {
            // NUEVO (No choca con tablas mapeadas)
            maxCounter++;
            const newNum = String(maxCounter).padStart(4, '0');
            const cleanName = file.replace(/^\d+_/, '');
            const newName = `${newNum}_${cleanName}`;
            
            const newData = `-- ==========================================================================\n-- NUEVO (${appName}): Origen -> ${file}\n-- Porqué: No hubo cruce con el dominio previo, añadido secuencialmente.\n-- ==========================================================================\n\n${content}\n`;
            fs.writeFileSync(path.join(destDir, newName), newData);
            log.push(`[NUEVO ARCHIVO]  ${appName}/${file} -> Creado como '${newName}' secuencialmente.`);
            
            // Map table
            regex.lastIndex = 0;
            while ((match = regex.exec(content)) !== null) {
                if (!['NEW', 'OLD', 'true', 'false'].includes(match[1]) && !tableToScript[match[1]]) {
                    tableToScript[match[1]] = newName;
                }
            }
        }
    }
}

processDir(adminDir, 'App Admin');
processDir(viewerDir, 'App Viewer');

fs.writeFileSync(path.join(__dirname, 'consolidation_report.txt'), log.join('\n'));
console.log("Consolidacion completada exitosamente.");
