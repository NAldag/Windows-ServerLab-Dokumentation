# ----------------------------------------
# PowerShell 7 Installation auf Windows Server Core
# Version 7.5.4
# ----------------------------------------

# Versionsnummer und URLs
$pwshVersion = "7.5.4"
$msiUrl = "https://github.com/PowerShell/PowerShell/releases/download/v$pwshVersion/PowerShell-7.5.4-win-x64.msi"
$msiPath = "$env:TEMP\pwsh.msi"

# TLS 1.2 erzwingen (für sichere HTTPS-Verbindungen)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# MSI herunterladen mit curl
Write-Host "Lade PowerShell 7 MSI herunter..."
Start-Process curl.exe -ArgumentList "-L -o `"$msiPath`" `"$msiUrl`"" -Wait

# Prüfen, ob Datei existiert
if (-Not (Test-Path $msiPath)) {
    Write-Host " MSI-Download fehlgeschlagen. Prüfe Netzwerk / Firewall / Proxy."
    exit 1
}

# MSI installieren (silent)
Write-Host "Installiere PowerShell 7..."
Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait

# Installationspfad prüfen und ggf. PATH ergänzen
$pwshInstallPath = "C:\Program Files\PowerShell\7"
if (-not ($env:PATH -like "*$pwshInstallPath*")) {
    Write-Host "Füge PowerShell 7 zum PATH hinzu..."
    [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$pwshInstallPath", [EnvironmentVariableTarget]::Machine)
}

# Installation prüfen
$pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
if ($pwsh) {
    Write-Host " PowerShell 7 erfolgreich installiert unter: $($pwsh.Source)"
} else {
    Write-Host " PowerShell 7 konnte nicht gefunden werden."
}

# Bereinigen temporäre MSI-Datei
Remove-Item $msiPath -Force
