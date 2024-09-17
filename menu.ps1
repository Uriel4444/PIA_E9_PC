# Scrip Main

# Importar los módulos
Import-Module "SystemVulnerability" -Force
Import-Module "SystemResource" -Force

# Función para mostrar el menú
function Show-Menu {
    Clear-Host
    Write-Host "=== MENÚ DE CIBERSEGURIDAD ===" -ForegroundColor Cyan
    Write-Host "1. Revisión de hashes de archivos"
    Write-Host "2. Listado de archivos ocultos en una carpeta determinada"
    Write-Host "3. Revisión de uso de recursos del sistema"
    Write-Host "4. Escanear vulnerabilidades del sistema"
    Write-Host "5. Salir"
    Write-Host "6. Ayuda"
}

# Función para mostrar el submenu de Vulnerabilidades
function Show-MenuV {
    Clear-Host
    Write-Host "=== MENÚ DE VULNERABILIDADES ===" -ForegroundColor Cyan
    Write-Host "1. Descargar el NVD Data Feed y descomprimirlo"
    Write-Host "2. Actualizar lista de CVEs desde NVD"
    Write-Host "3. Escanear vulnerabilidades del sistema"
    Write-Host "4. Salir al menu principal"
}

# Función principal menú
function Main {
    do {
        Show-Menu
        $op = Read-Host "Seleccione una opción del menú (1-6)"
        
        switch ($op) {
            1{ # Opción del Modulo de los hashes
                try {
                    
                    Get-hashes
                
                } catch {

                    
                Write-Host "
                -----Detalles del error-----
                ||||||||||||||||||||||||||||

                    
$($_.Exception.Message)
                    
                    "

                }

                Pause


            }
            2{ # Opción del Modulo de archivos ocultos

                try { 
                
                    Get-HiddenFiles
                    
                }catch{

                Write-Host "
                -----Detalles del error-----
                

                    
$($_.Exception.Message)
                    
                    "
                
                 }

            Pause

            }


            3{ # Opción del Modulo de uso de recursos del sistema
                try {
                    Get-SystemResourceUsage
                } catch {
                    Write-Host "Error ejecutando la revisión de recursos del sistema: $_" -ForegroundColor Red
                }
                Pause
            }
            4{ # Opción del Modulo de Vulnerabilidades
                do {
                    Show-MenuV
                    $vop = Read-Host "Seleccione una opción del menú de vulnerabilidades (1-4)"

                    switch ($vop) {
                        1{
                            Write-Host "`n=== DESCARGAR EL NVD DATA FEED ===" -ForegroundColor Cyan
                            try {
                                NVDFeed
                            } catch {
                                Write-Host "Error descargando el NVD Data Feed: $_" -ForegroundColor Red
                            }
                            Pause
                        }
                        2{
                            Write-Host "`n=== ACTUALIZAR LISTA DE CVEs ===" -ForegroundColor Cyan
                            try {
                                CVEList
                            } catch {
                                Write-Host "Error actualizando la lista de CVEs: $_" -ForegroundColor Red
                            }
                            Pause
                        }
                        3{
                            Write-Host "`n=== ESCANEO DE VULNERABILIDADES DEL SISTEMA ===" -ForegroundColor Cyan
                            try {
                                $vulnerabilities = Get-SystemVulnerabilities
                                if ($vulnerabilities) {
                                    $vulnerabilities | Format-Table -AutoSize
                                }
                            } catch {
                                Write-Host "Error ejecutando el escaneo de vulnerabilidades: $_" -ForegroundColor Red
                            }
                            Pause
                        }
                        4{
                            Write-Host "Volviendo al menú principal..." -ForegroundColor Yellow
                            break
                        }
                        default {
                            Write-Host "Opción no válida. Inténtelo de nuevo." -ForegroundColor Red
                            Pause
                        }
                    }
                } while ($vop -ne 4)
            }
            5{
                Write-Host "Saliendo del programa..." -ForegroundColor Yellow
                exit
            }
            6{
                function help-main {
                    <#
                    .SYNOPSIS
                    Función del menú que da a elegir varios opciones y subopciones

                    .DESCRIPTION
                    Este script genera varias ocpiones:  
                    1. Revisión de hashes de archivos
                    "Consulta los hashes de archivos locales en la api de VirusTotal.
                    Nótese que los accesos directos o archivos que requieran acceso no
                    muestran un número hash
                    "

                    2. Listado de archivos ocultos en una carpeta determinada
                    "Muestra los archivos que al no aparecer en la interfaz aparecen ocultos
                    en la ruta C:\Windows"
                    

                    3. Revisión de uso de recursos del sistema
                    "Calculo algunos recursos como el cpu, disco, memoria, etc ... "

                    4. Escanear vulnerabilidades del sistema
                    "Abre un submenú que relacionado a esta opción
                    y sus funciones están descritas en dichas opciones"

                            1. Descargar el NVD Data Feed y descomprimirlo
                            2. Actualizar lista de CVEs desde NVD
                            3. Escanear vulnerabilidades del sistema
                            4. Salir al menu principal
                            5. Salir

                    5. Salir
                    "Sale del menú"

                    6. Ayuda
                    "Muestra cierta información referente al menú"

                    .EXAMPLE    
                    Diríjanse a la ruta donde se guardó el archivo como: "C:\ruta\a\carpeta"
                    Ejecute .\menu.ps1
                    Seleccione las opciones que quiera
                        
                    #>
                    
                }
                Get-Help help-main -Full
                    
                
                
                Pause
            }
            default {
                Write-Host "Opción no válida. Inténtelo de nuevo." -ForegroundColor Red
                Pause
            }
        }
    } while ($op -ne 5)
}




# Iniciar el menú
Main            