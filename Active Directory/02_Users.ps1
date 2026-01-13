# Domänenbasis
$DomainDN = "DC=HomeLab,DC=local"

# Sicherstellen, dass AD-Modul geladen ist
if (-not (Get-Module -ListAvailable ActiveDirectory)) {
    Write-Error "ActiveDirectory-Modul nicht verfügbar."
    exit 1
}
Import-Module ActiveDirectory

# 02_Users.ps1
# Test:
# Erstellt Benutzerkonten

$SecurePW = ConvertTo-SecureString "Start!123" -AsPlainText -Force

$Users = @(
    @{ Name="IT Admin"; Sam="it.admin"; OU="IT" },
    @{ Name="Guest User"; Sam="guest.user"; OU="Guests" }
)

foreach ($u in $Users) {
    $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$($u.Sam)'" -ErrorAction SilentlyContinue

    if (-not $ExistingUser) {
        New-ADUser `
            -Name $u.Sam `
            -DisplayName $u.Name `
            -SamAccountName $u.Sam `
            -UserPrincipalName "$($u.Sam)@HomeLab.local" `
            -Path "OU=$($u.OU),OU=Users,$DomainDN" `
            -AccountPassword $SecurePW `
            -Enabled $true `
            -ChangePasswordAtLogon $true
        Write-Output "User $($u.Sam) erstellt"
    } else {
        Write-Output "User $($u.Sam) existiert bereits"
    }
}
