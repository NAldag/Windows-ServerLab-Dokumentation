# Erstellen eines Skripts für Benutzererstellung

## Eingabedaten:

Beispiel Users:

Name: "IT Admin"
SAM: "it.Admin"
OU: "IT"

Name: "Guest User"
SAM: "guest.user"
OU: "Guests"

Array array: @(@{Name="IT Admin; Sam="it.admin"; OU="IT"},@{...})
= $Users

Iterieren mit foreach u in $Users

## Datenbeschaffung zum Abgleich:

Beispiel fir IT Admin:

Get-ADUser -Filter "SamAccountName -eq 'it.admin'" -ErrorAction SilentlyContinue

In Variable $ExistingUser

 Abfrage per if else

## Erstellung AD User

        New-ADUser `
            -Name it.admin `
            -DisplayName IT Admin `
            -SamAccountName it.admin `
            -UserPrincipalName "it.admin@HomeLab.local" `
            -Path "OU=$($u.OU),OU=Users,$DomainDN" `
            -AccountPassword $SecurePW `
            -Enabled $true `
            -ChangePasswordAtLogon $true

Write-Output "User x erstellt"

else:
Write-Output "User X existiert bereits
