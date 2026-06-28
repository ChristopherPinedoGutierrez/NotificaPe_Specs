$source = "c:\Trabajo\Proyectos\NotificaPe\web\docs\app_web_main"
$dest = "c:\Trabajo\Proyectos\NotificaPe\NotificaPe_Specs\management\database\scripts"

# Limpiar scripts y restaurar modelo base
Remove-Item -Path "$dest\*" -Force -Recurse
Copy-Item -Path "c:\Trabajo\Proyectos\NotificaPe\web\docs\b.1_blueprint_data_model.sql" -Destination "$dest\0000_blueprint_data_model.sql" -Force
Copy-Item -Path "c:\Trabajo\Proyectos\NotificaPe\web\docs\b.1_blueprint_data_model.sql" -Destination "c:\Trabajo\Proyectos\NotificaPe\NotificaPe_Specs\management\database\schema.sql" -Force

$files = Get-ChildItem -Path $source -Filter "*.sql" | Sort-Object Name
$counter = 1

$output = @()

foreach ($file in $files) {
    # Extraer el nombre quitando su prefijo numérico original
    $newName = $file.Name -replace '^\d+_', ''
    $formattedCounter = "{0:D4}" -f $counter
    $finalName = "${formattedCounter}_$newName"
    
    Copy-Item -Path $file.FullName -Destination "$dest\$finalName"
    $output += "$finalName (Original: $($file.Name))"
    $counter++
}

$output | Out-File "c:\Trabajo\Proyectos\NotificaPe\NotificaPe_Specs\web_sql_list.txt" -Encoding utf8
