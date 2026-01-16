# Domänenbasis
$DomainDN = "DC=HomeLab,DC=local"

# Sicherstellen, dass AD-Modul geladen ist
if (-not (Get-Module -ListAvailable ActiveDirectory)) {
    Write-Error "ActiveDirectory-Modul nicht verfügbar."
    exit 1
}
Import-Module ActiveDirectory

# 03_Groups.ps1
# Test: 
# Erstellt Sicherheitsgruppen nach AGDLP

$GlobalGroups = @("GG_IT_Admins","GG_Guests")
$DomainLocalGroups = @("DL_File_IT_RW")

foreach ($g in $GlobalGroups) {
    try {
        New-ADGroup `
            -Name $g `
            -GroupScope Global `
            -GroupCategory Security `
            -Path "OU=Security,OU=Groups,$DomainDN" `
            -ErrorAction Stop
        Write-Output "Globale Gruppe $g erstellt"
    }
    catch{
        Write-Output "Globale Gruppe $g bereits vorhanden"
    }
}

foreach ($g in $DomainLocalGroups) {
    try {
        New-ADGroup `
            -Name $g `
            -GroupScope DomainLocal `
            -GroupCategory Security `
            -Path "OU=Security,OU=Groups,$DomainDN" `
            -ErrorAction Stop
        Write-Output "Domain Local Gruppe $g erstellt"
    }
    Catch{
        Write-Output "Domain Local Gruppe $g bereits vorhanden"
    }
}
