## Ersteinrichtung in GUI

- Server VM aufgesetzt, name auf DC01 gesetzt, neustart.
- IP festgelegt und bei DNS eingetragen.
- Auf Domaincontroller hochgestuft. Installiert DNS automatisch und zwingend mit, daher Rollen installation unnötig.
- RDP aktiviert und verbunden. GUI zum verifizieren und als Orientierungshilfe erreichbar.
- Powershell 7 für Automatisierung/Remote/VS Code per Skript auf VM Installiert. AD Verwaltung erfolgt per integrierter v5.1

Diese Schritte Automatisch?

## Ersteinrichtung alternativ in Powershell (Work in Progress)



## SSH für Powershell

SSH & lokales VS Code einrichten, um Powershell und SSH gestützte RDP Verbindung vom Host zu ermöglichen.

### Einrichten und (autom.) Starten des Dienstes auf Windows Server

```powershell

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service sshd -StartupType Automatic

```

#### Troubleshooting

- AddCapability funktioniert nicht > Keine Internetverbindung
- NSlookup für google.de: 
- Server:  UnKnown
- Address: 192.168.204.10
- *** google.de wurde von UnKnown nicht gefunden: No response from server


DNS löst keine externen Zonen auf. Lösung: DNS Forwarder
DNS Manager > DC01 Eigenschaften > Weiterleitung Bearbeiten 8.8.8.8 1.1.1.1 (google und cloudflare) eingtragen

Oder:

```powershell

Add-DnsServerForwarder -IPAddress 8.8.8.8,1.1.1.1

```

Achtung: Google/Cloudflare für privaten gebrauch.
Firmenumfeld: Interner Resolver, wenn vorhanden, sonst ISP-DNS

Firewall check

```powershell

Get-NetFirewallRule -Name *ssh*

```

Regel wird angezeigt: OK

Tunnel von localhost auf RDP Port des Servers:

```Powershell

ssh -L 13389:localhost:3389 Administrator@192.168.204.10

```

RDP auf localhost:13389 -> SSH gestützte RDP Session

## VS Code

Powershell Extension installiert
STRG/SHIFT + P Terminal: Set Default Profile 
Powershell 7 wählen
Falls VS Code meldet, dass es nicht in die settings.json schreiben kann
Syntaxfehler in settings.json hat sich bei letzter Änderung reingeschlichen: Fehlende "{"

Enter-PSSession -HostName 192.168.204.10 -UserName Administrator Administrator@192.168.204.10's password: subsystem request failed on channel 0

SSH Subsystem für Powershell einrichten:
notepad C:\ProgramData\ssh\sshd_config
Eintragen:
Subsystem powershell "C:\Program Files\PowerShell\7\pwsh.exe" -sshs -NoLogo -NoProfile

SSH & Enter-PSSession test: OK

## Aktive Directory üver Powershell/Skript einrichten

Als robuste, reproduzierbare Setup-Skripte im Active Directory Unterordner.

Befehle:

```powershell

# Powershell lädt das AD-Modul
Import-Module ActiveDirectory 

```

### Erstellen der OUs (Organizational Units)

Erstellen der basis OUs: "Users,Computers,Groups,Service"  
direkt unter HomeLab.local

```powershell

# Erstelle neue OU namens Users.
# Path gibt an, wo das OU Objekt lebt. Hierarchische Struktur, gefolgt von Name der Domäne & TopLevelDomain.
# DC steht für DomainComponent im Active Directory Namensraum
New-ADOrganizationalUnit -Name "Users" -Path "DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Computers" -Path "DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Groups" -Path "DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "ServiceAccounts" -Path "DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true

```

Im Skript z. B. als Schleife mit Abfrage, ob OU existiert:

```powershell

$BaseDN = "DC=HomeLab,DC=local"
$OUs = @("Users,Computers,Groups,Service")
$ExistingOUs = Get-ADOrganizationalUnit -LDAPFilter "(distinguishedName=$dn)" -ErrorAction SilentlyContinue

foreach ($OU in $OUs)
{
  if ($OU -notin $ExistingOUs)
  {
    Write-Host "Erstelle OU: $OU"
    New-ADOrganizationalUnit -Name $OU -Path $BaseDN
  }
  else
  {
    Write-Host "OU existiert bereits: $OU"
  }
}

```

OUs unter Users erstellen:
Users.HomeLab.local

```powershell

New-ADOrganizationalUnit -Name "IT" -Path "OU=Users,DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Guests" -Path "OU=Users,DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true

```

OUs unter Computers erstellen:
Computers.HomeLab.local

```powershell

New-ADOrganizationalUnit -Name "Clients" -Path "OU=Computers,DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true

```

OUs unter Groups erstellen

```powershell

New-ADOrganizationalUnit -Name "Security" -Path "OU=Groups,DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name "Distribution" -Path "OU=Groups,DC=HomeLab,DC=local" -ProtectedFromAccidentalDeletion $true

```

Check:

```powershell

Get-ADOrganizationalUnit -Filter * | Select Name, DistinguishedName


```

Anzeige: 

### Struktur:

```

HomeLab.local
├── Users
│   ├── IT
│   └── Guests
├── Computers
│   └── Clients
├── Groups
│   ├── Security
│   └── Distribution
└── ServiceAccounts

```

```powershell



```
