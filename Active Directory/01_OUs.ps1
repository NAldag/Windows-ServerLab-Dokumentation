# Domänenbasis

# Test: OUS wurden erstellt, aber wirft exceptions beim Abfragen existierender OUs, beim versuchten Erstellen exisiterender OUs und beim Erstellen von Unter-OUs aufgrund zeitlicher Auflösung zwischen AD und Skriptlauf. Das Skript läuft schneller durch, als dass die Objekte in AD sichtbar sind.
# Abfrage & Erstellen: Basis OUs mit Namen gleich eines basis Containers geändert. Create-Execption mit Try Catch auffangen.
# Zeitauflösung(pragmatisch): Minimales Delay nach Parent Erstellung, nicht garantiert: Start-Sleep -Milliseconds 500
# Zeitauflösung(langfristig): Hilfsfunktion Wait-ForOU. Aufwändiger, aber erstlauf Garantie.


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
    $dn = "OU=$ou,$DomainDN"
    $ExistingOUs = Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue
    
    if (-not $ExistingOUs) {
        New-ADOrganizationalUnit -Name $ou -Path $DomainDN -ProtectedFromAccidentalDeletion $true
        Write-Output "OU $ou erstellt"
    } else {
        Write-Output "OU $ou existiert bereits"
    }
}

Start-Sleep -Milliseconds 500


foreach ($ou in $UserOUs) {
    $dn = "OU=$ou,OU=Users,$DomainDN"
    $ExistingOUs = Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue
    
    if (-not $ExistingOUs) {
        New-ADOrganizationalUnit -Name $ou -Path "OU=Users,$DomainDN" -ProtectedFromAccidentalDeletion $true
        Write-Output "OU Users\$ou erstellt"
    }
}

Start-Sleep -Milliseconds 500

foreach ($ou in $GroupOUs) {
    $dn = "OU=$ou,OU=Groups,$DomainDN"
    $ExistingOUs = Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue
    
    if (-not $ExistingOUs) {
        New-ADOrganizationalUnit -Name $ou -Path "OU=Groups,$DomainDN" -ProtectedFromAccidentalDeletion $true
        Write-Output "OU Groups\$ou erstellt"
    }
}

Start-Sleep -Milliseconds 500

# Computer-Unter-OU
$clientsDN = "OU=Clients,OU=Computers,$DomainDN"
$ExistingOUs = Get-ADOrganizationalUnit -Identity $clientsDN -ErrorAction SilentlyContinue

if (-not $ExistingOUs) {
    New-ADOrganizationalUnit -Name "Clients" -Path "OU=Computers,$DomainDN" -ProtectedFromAccidentalDeletion $true
    Write-Output "OU Computers\Clients erstellt"
}
