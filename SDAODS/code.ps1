Write-Host "Surveillance du trafic de synchronisation OneDrive..." -ForegroundColor Cyan

do {
    Start-Sleep -Seconds 15
    # Récupère l'utilisation du réseau par le processus OneDrive (en Ko/s ou activité)
    $onedriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    
    if (-not $onedriveProcess) {
        Write-Host "Le processus OneDrive n'est plus actif." -ForegroundColor Yellow
        break
    }

    # Vérifie si le fichier journal ou l'état indique une fin de synchro (via l'activité CPU/Réseau minime)
    # On vérifie si le processeur de OneDrive est au repos (activité de fond)
    $cpuUsage = $onedriveProcess.CPU
    Start-Sleep -Seconds 10
    $onedriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    
    if ($onedriveProcess -and [math]::Abs($onedriveProcess.CPU - $cpuUsage) -lt 0.1) {
        Write-Host "Synchronisation terminée (activité stabilisée)." -ForegroundColor Green
        break
    }
} while ($true)

Write-Host "Extinction du PC dans 10 secondes..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Stop-Computer -Force
