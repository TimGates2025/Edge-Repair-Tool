
# Author: Tim Gates
# Script Purpose: Repair or reinstall Microsoft Edge if it's crashing
# Version: 1.0

# Define log path
$LogFile = "$env:USERPROFILE\Desktop\EdgeRepairLog.txt"
Start-Transcript -Path $LogFile -Append

Write-Host "`n===> Starting Microsoft Edge repair..." -ForegroundColor Cyan

# Step 1: Kill Edge processes
Write-Host "Closing any running Edge processes..."
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force

# Step 2: Try built-in repair via Apps & Features
$App = Get-WmiObject Win32_Product | Where-Object { $_.Name -like "*Microsoft Edge*" }
if ($App) {
    Write-Host "Attempting to repair Microsoft Edge using built-in installer..."
    try {
        $App.Reinstall()
        Write-Host "Built-in repair initiated successfully."
    } catch {
        Write-Warning "Repair failed using WMI method. Proceeding with clean reinstall..."
    }
} else {
    Write-Warning "Microsoft Edge not found via WMI. Proceeding with clean reinstall..."
}

# Step 3: Re-download installer if needed
$InstallerPath = "$env:TEMP\MicrosoftEdgeSetup.exe"
if (-Not (Test-Path $InstallerPath)) {
    Write-Host "Downloading latest Edge installer..."
    Invoke-WebRequest -Uri "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/61e10c35-d3a6-4bfa-a3fc-607e10bcf303/MicrosoftEdgeEnterpriseX64.msi" `
                      -OutFile $InstallerPath
}

# Step 4: Install silently
if (Test-Path $InstallerPath) {
    Write-Host "Installing Edge silently..."
    Start-Process msiexec.exe -ArgumentList "/i `"$InstallerPath`" /quiet /norestart" -Wait
    Write-Host "Edge reinstallation complete."
} else {
    Write-Error "Installer not found. Could not complete repair."
}

Stop-Transcript
Write-Host "`nRepair process complete. See log at: $LogFile" -ForegroundColor Green
