function Get-hashes {
    
    #Parámetros de entrada
    param(
    
        [string]$FolderPath,
        [string]$HashAlgorithm = "SHA256",
        [string]$ReportPath = "$PSScriptRoot\HASH_Report.txt",
        [string]$ApiKey = "dca56829a699006f327383a14b221774994e2529655ab4bcb973d66da6d40e4d"
    )
    # Modo estricto
    Set-StrictMode -Version 1.0

    # Inicio de la transcripción y ruta donde se va a guardar
    Start-Transcript -Path $ReportPath


    # Manejo de excepciones
    try {


        # Obtiene los datos de los hashes
        $files = Get-ChildItem -Path $FolderPath -ErrorAction SilentlyContinue


        # Ciclo que muestra cada documento y su hash
        foreach ($file in $files) {

            $hash = Get-FileHash -Path $file.FullName -ErrorAction SilentlyContinue -Algorithm $HashAlgorithm  `
            | Select-Object -ExpandProperty Hash

            Write-Host "Hash del archivo $($file.Name): $hash"

        

            # Prepara los headers y la URL para la consulta a VirusTotal
            $headers = @{
                "x-apikey" = $ApiKey
                "accept"   = "application/json"

            }
        

            # Dirección de la api
            $url = "https://www.virustotal.com/vtapi/v2/file/report?apikey=$ApiKey&resource=$hash"
        

            # Realiza la solicitud a la API de VirusTotal
            $response = Invoke-RestMethod -Uri $url -Method GET -Headers $headers


            # Muestra la respuesta
            if ($response.response_code -eq 1) {

                Write-Host "Archivo $($file.Name) encontrado en VirusTotal."
                Write-Host "Positivos: $($response.positives)/$($response.total)"


            } elseif ($response.response_code -eq 0) {


                Write-Host "Archivo $($file.Name) no encontrado en VirusTotal."


            }


        }

    

    } catch { 


        #Mensaje de error en caso de que algún archivo local requiera permiso para
        #consultar en la api es posible que arroje error
        Write-Error "-------------------> $($_.Exception.Message)"
        Write-Host "Detalles del error:"


    }


    Stop-Transcript # Detiene la transcripción


}

Export-ModuleMember -Function Get-hashes