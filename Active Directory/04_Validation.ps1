# Prüft den aktuellen Zustand der AD-Struktur

$DomainDN = "DC=HomeLab,DC=local"

Write-Output "`n--- OUs ---"
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName

Write-Output "`n--- Benutzer ---"
# Unter LabUsers statt Users
Get-ADUser -Filter * -SearchBase "OU=LabUsers,$DomainDN" | Select-Object SamAccountName, Name

Write-Output "`n--- Gruppen & Mitglieder ---"
# Unter Groups/OU=Security
Get-ADGroup -Filter * -SearchBase "OU=Security,OU=Groups,$DomainDN" | ForEach-Object {
    Write-Output "`nGruppe: $($_.Name)"
    Get-ADGroupMember $_ | Select-Object Name, SamAccountName
}

Write-Output "`n--- Computer ---"
# Unter LabComputers statt Computers
Get-ADComputer -Filter * -SearchBase "OU=LabComputers,$DomainDN" | Select-Object Name, DistinguishedName
