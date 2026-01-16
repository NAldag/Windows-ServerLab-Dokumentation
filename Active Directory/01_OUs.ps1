# Domänenbasis

# Test: OUS wurden erstellt, aber wirft exceptions beim Abfragen existierender OUs, beim versuchten Erstellen exisiterender OUs und beim Erstellen von Unter-OUs aufgrund zeitlicher Auflösung zwischen AD und Skriptlauf. Das Skript läuft schneller durch, als dass die Objekte in AD sichtbar sind.
# Abfrage & Erstellen: Basis OUs mit Namen gleich eines basis Containers geändert. Create-Execption mit Try Catch auffangen.
# Zeitauflösung(pragmatisch): Minimales Delay nach Parent Erstellung, nicht garantiert: Start-Sleep -Milliseconds 500
# Zeitauflösung(langfristig): Hilfsfunktion Wait-ForOU. Aufwändiger, aber erstlauf Garantie.

# Durchgeführt: Namensänderungen, Try Catch bei Erstellung statt IF, Wait 500 ms nach Parent Erstellung
# Text: 

$DomainDN = "DC=HomeLab,DC=local"

# Sicherstellen, dass AD-Modul geladen ist
if (-not (Get-Module -ListAvailable ActiveDirectory)) {
    Write-Error "ActiveDirectory-Modul nicht verfügbar."
    exit 1
}
Import-Module ActiveDirectory

# 01_OUs.ps1
# Erstellt die OU-Struktur für das HomeLab

$BaseOUs = @("LabUsers","LabComputers","Groups","ServiceAccounts")
$UserOUs = @("IT","Guests")
$GroupOUs = @("Security","Distribution")


foreach ($ou in $BaseOUs) {
    try {
        New-ADOrganizationalUnit -Name $ou -Path $DomainDN -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
        Write-Output "OU $ou erstellt"
        }
    catch{
        Write-Output "OU $ou existiert oder Parent noch nicht bereit"
        }
    
}

Start-Sleep -Milliseconds 500

foreach ($ou in $UserOUs) {
    try {
        New-ADOrganizationalUnit -Name $ou -Path "OU=LabUsers,$DomainDN" -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
        Write-Output "OU LabUsers\$ou erstellt"
        }
    catch {
        Write-Output "OU LabUsers\$ou existiert oder Parent noch nicht bereit"
        }
}

foreach ($ou in $GroupOUs) {
    try {
        New-ADOrganizationalUnit -Name $ou -Path "OU=Groups,$DomainDN" -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
        Write-Output "OU Groups\$ou erstellt"
        }
    catch {
        Write-Output "OU Groups\$ou existiert oder Parent noch nicht bereit"
         }
}

Start-Sleep -Milliseconds 500

# Computer-Unter-OU
$clientsDN = "OU=Clients,OU=LabComputers,$DomainDN"
$ExistingOUs = Get-ADOrganizationalUnit -Identity $clientsDN -ErrorAction SilentlyContinue

if (-not $ExistingOUs) {
    New-ADOrganizationalUnit -Name "Clients" -Path "OU=LabComputers,$DomainDN" -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
    Write-Output "OU LabComputers\Clients erstellt"
}
