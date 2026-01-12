# Domänenbasis
$DomainDN = "DC=HomeLab,DC=local"

# Sicherstellen, dass AD-Modul geladen ist
if (-not (Get-Module -ListAvailable ActiveDirectory)) {
    Write-Error "ActiveDirectory-Modul nicht verfügbar."
    exit 1
}
Import-Module ActiveDirectory

# 01_OUs.ps1
# Test: 
# Erstellt die OU-Struktur für das HomeLab

$BaseOUs = @("Users","Computers","Groups","ServiceAccounts")
$UserOUs = @("IT","Guests")
$GroupOUs = @("Security","Distribution")


foreach ($ou in $BaseOUs) {
    $dn = "OU=$ou,$DomainDN"
    $ExistingOUs = Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue
    
    if (-not $ExistingOUs) {
        New-ADOrganizationalUnit -Name $ou -Path $DomainDN
        Write-Output "OU $ou erstellt"
    } else {
        Write-Output "OU $ou existiert bereits"
    }
}

foreach ($ou in $UserOUs) {
    $dn = "OU=$ou,OU=Users,$DomainDN"
    $ExistingOUs = Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue
    
    if (-not($ExistingOUs) {
        New-ADOrganizationalUnit -Name $ou -Path "OU=Users,$DomainDN"
        Write-Output "OU Users\$ou erstellt"
    }
}

foreach ($ou in $GroupOUs) {
    $dn = "OU=$ou,OU=Groups,$DomainDN"
    $ExistingOUs = Get-ADOrganizationalUnit -Identity $dn -ErrorAction SilentlyContinue
    
    if (-not $ExistingOUs) {
        New-ADOrganizationalUnit -Name $ou -Path "OU=Groups,$DomainDN"
        Write-Output "OU Groups\$ou erstellt"
    }
}

# Computer-Unter-OU
$clientsDN = "OU=Clients,OU=Computers,$DomainDN"
$ExistingOUs = Get-ADOrganizationalUnit -Identity $clientDN -ErrorAction SilentlyContinue

if (-not $ExistingOUs) {
    New-ADOrganizationalUnit -Name "Clients" -Path "OU=Computers,$DomainDN"
    Write-Output "OU Computers\Clients erstellt"
}
