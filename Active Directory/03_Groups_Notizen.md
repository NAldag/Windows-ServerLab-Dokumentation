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
