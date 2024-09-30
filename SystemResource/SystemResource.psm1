# SystemResource.psm1

# Modo estricto
Set-StrictMode -Version Latest

function Get-SystemResourceUsage {
    try {
        # Revisión del uso de CPU
        $cpuUsage = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
    } catch {
        Write-Error "Error al obtener la información del CPU"
    }

    try {
        # Revisión del uso de memoria
        $memInfo = Get-WmiObject -Class Win32_OperatingSystem
        $totalMemory = [math]::Round($memInfo.TotalVisibleMemorySize / 1MB, 2)
        $freeMemory = [math]::Round($memInfo.FreePhysicalMemory / 1MB, 2)
        $usedMemory = [math]::Round($totalMemory - $freeMemory, 2)
    } catch {
        Write-Error "Error al obtener la información de la memoria"
    }

    try {
        # Revisión del uso del disco
        $diskInfo = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
        $diskUsage = @()
        foreach ($disk in $diskInfo) {
            $diskUsage += [PSCustomObject]@{
                Drive       = $disk.DeviceID
                TotalSpace  = [math]::Round($disk.Size / 1GB, 2)
                FreeSpace   = [math]::Round($disk.FreeSpace / 1GB, 2)
                UsedSpace   = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)
            }
        }
    } catch {
        Write-Error "Error al obtener la información del disco"
        }
    
    try {
        # Revisión de uso de red (adaptadores de red)
        $networkInfo = Get-NetAdapterStatistics
        $networkUsage = @()
        foreach ($net in $networkInfo) {
            $bytesSent = if ($net.SentBytes) { $net.SentBytes } else { "N/A" }
            $bytesReceived = if ($net.ReceivedBytes) { $net.ReceivedBytes } else { "N/A" }

            $networkUsage += [PSCustomObject]@{
                AdapterName   = $net.Name
                BytesSent     = $bytesSent
                BytesReceived = $bytesReceived
            }
        }
    } catch {
        Write-Error "Error al obtener la información de los adaptadores de red"
        }

    # Resultado final
    $systemUsage = [PSCustomObject]@{
        CPU_Usage      = "$cpuUsage %"
        Memory_Usage   = [PSCustomObject]@{
            TotalMemory   = "$totalMemory GB"
            UsedMemory    = "$usedMemory GB"
            FreeMemory    = "$freeMemory GB"
        }
        Disk_Usage     = $diskUsage
        Network_Usage  = $networkUsage
    }

    # Impresión ordenada de los resultados
    Write-Host "=== USO DE RECURSOS DEL SISTEMA ===" -ForegroundColor Cyan
    Write-Host "`n--- Uso del CPU --- `nCPU: $($systemUsage.CPU_Usage)"
    Write-Host "`n--- Uso de la Memoria --- `nTotal: $($systemUsage.Memory_Usage.TotalMemory) `nUsado: $($systemUsage.Memory_Usage.UsedMemory) `nLibre: $($systemUsage.Memory_Usage.FreeMemory)"
    Write-Host "`n--- Uso del Disco ---"
    foreach ($disk in $systemUsage.Disk_Usage) {
        Write-Host "Drive: $($disk.Drive) `nTotal: $($disk.TotalSpace) GB `nUsado: $($disk.UsedSpace) GB `nLibre: $($disk.FreeSpace) GB"
    }
    Write-Host "`n--- Uso de la Red ---"
    foreach ($net in $systemUsage.Network_Usage) {
        Write-Host "Adapter: $($net.AdapterName) `nBytes Eviados: $($net.BytesSent) `nBytes Recividos: $($net.BytesReceived)`n"
    }
}

# Exportar la función
Export-ModuleMember -Function Get-SystemResourceUsage