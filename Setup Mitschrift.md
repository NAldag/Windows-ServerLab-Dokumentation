Server VM aufgesetzt, name auf DC01 gesetzt, neustart  
IP festgelegt, DNS vorerst .1
RDP aktiviert und verbunden. GUI zum verifizieren und als Orientierungshilfe erreichbar

## SSH für Powershell(ISE)

SSH & lokales VS Code einrichten, um sichere Powershell Sitzung vom Host aus zu starten und gewohntes Arbeiten ohne Verzögerung zu ermöglichen.

### Einrichten und (autom.) Starten des Dienstes auf Windows Server

```shell

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service sshd -StartupType Automatic

```

#### Troubleshooting
AddCapability funktioniert nicht > Keine Internetverbindung
NSlookup für google.de: 
Server:  UnKnown
Address: 192.168.204.10
*** google.de wurde von UnKnown nicht gefunden: No response from server


DNS löst keine externen ZOnen auf. Lösung: DNS Forwarder
DNS Manager > DC01 Eigenschaften > Weiterleitung Bearbeiten 8.8.8.8 1.1.1.1 (google und cloudflare) eingtragen

Oder:

```shell

Add-DnsServerForwarder -IPAddress 8.8.8.8,1.1.1.1

```

Firewall check

```shell

Get-NetFirewallRule -Name *ssh*

```

Regel wird angezeigt: OK

### VS Code

Powershell Extension installiert
STRG/SHIFT + P Terminal: Set Default Profile 
>Powershell 7 wählen
Falls VS Code meldet, dass es nicht in die settings.json schreiben kann
>Syntaxfehler in settings.json hat sich bei letzter Änderung reingeschlichen: Fehlende "{"




```shell


```

```shell



```
