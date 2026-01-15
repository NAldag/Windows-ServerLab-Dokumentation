# Skript zur Erstellung praxisnaher OUs

## Eingabedaten

Basis OUS: "Users","Computers","Groups","ServiceAccounts"
User OUs: "IT","Guests"
Group OOs:"Security","Distribution"

Array in Powershell: @("...","...")

Array jeweils mit foreach iterieren

In variablen

'$BaseOUs'
'$UserOUs'
'$GroupOUs'

## OU Erstellen

New-ADOrganizationalUnit -Name $ou -Path $DomainDN -ProtectedFromAccidentalDeletion $true

Write-Output "OU erstellt"

### Datenbeschaffung existierender OUs

Variable:
'$ExistingOUs'

Beispiel für OU Users:

Get-ADOrganizationalUnit -Identity OU=Users,DC=HomeLab,DC=local -ErrorAction SilentlyContinue

Abfrage von $ExistingOUs mit if else

Für unter OUs

Get-ADOrganizationalUnit -Identity OU=Clients,OU=Computers,DC=HomeLab,DC=local -ErrorAction SilentlyContinue



New-ADOrganizationalUnit -Name "Clients" -Path "OU=Computers,$DomainDN" -ProtectedFromAccidentalDeletion $true

```

Globale Variable für DC=HomeLab,DC=local = $DomainDN
