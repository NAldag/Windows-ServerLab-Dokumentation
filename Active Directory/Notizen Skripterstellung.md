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

Globale Variable für DC=HomeLab,DC=local = $DomainDN

# Erstellen eines Skripts für Benutzererstellung

## Eingabedaten:

Beispiel Users:

Name: "IT Admin"
SAM: "it.Admin"
OU: "IT"

Name: "Guest User"
SAM: "guest.user"
OU: "Guests"

Passwort als SecureString

$SecurePW = ConvertTo-SecureString "Start!123" -AsPlainText -Force

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
            -Path "OU=IT,OU=Users,DC=HomeLab,DC=local" `
            -AccountPassword $SecurePW `
            -Enabled $true `
            -ChangePasswordAtLogon $true

Write-Output "User x erstellt"

else:
Write-Output "User X existiert bereits

# Erstellen eines Skripts für Globale und Domain Local Gruppen nach AGDLP

Variable für Domainbasis

/$DomainDN = "DC=HomeLab,DC=local"

## Abfrage, ob AD Modul geladen ist

if (-not (Get-Module -ListAvailable ActiveDirectory)) {
    Write-Error "ActiveDirectory-Modul nicht verfügbar."
    exit 1
}

## Eingabedaten

Globale und DL Gruppen:

$GlobalGroups = @("GG_IT_Admins","GG_Guests")
$DomainLocalGroups = @("DL_File_IT_RW")

Iterieren mit foreach

Abfrage existierender Gruppen mit if else

if (-not $ExistingGroup)

## Datenbeschaffung

/$ExistingGroup = Get-ADGroup -Filter "Name -eq 'GG_IT_Admins'" -ErrorAction SilentlyContinue

## Neue Globale Gruppe erstellen

New-ADGroup `
        -Name GG_IT_Admins `
        -GroupScope Global `
        -GroupCategory Security `
         Path "OU=Security,OU=Groups,$DomainDN"


Write-Output "Globale Gruppe X erstellt"

## Neue DL Gruppe erstellen

    New-ADGroup `
            -Name DL_FIle_IT_RW `
            -GroupScope DomainLocal `
            -GroupCategory Security `
            -Path "OU=Security,OU=Groups,$DomainDN"

Write-Output "Domain Local Gruppe X erstellt"
