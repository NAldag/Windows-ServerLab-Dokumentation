# Windows Server Lab – Active Directory & Automatisierung

Dieses Repository dokumentiert ein Windows Server Homelab, das als praktische Testumgebung für Active Directory, Gruppenrichtlinien, Automatisierung und Remote-Management dient. Ziel ist eine reproduzierbare Umgebung, die typische Aufgaben eines Systemadministrators abbildet und als Nachweis für praktische IT-Kenntnisse dient.

## Inhalt & Fokus
- Aufbau einer Active Directory Testdomäne
- Strukturierte OU-Organisation und Rollenmodell (AGDLP)
- Automatisierung mittels PowerShell
- Remote-Management via SSH und VS Code
- Dokumentation der Konfiguration und Troubleshooting

## Umgebung
- Windows Server 2022 (Standard, Evaluation)
- Active Directory Domain Services (AD DS)
- DNS (integriert mit AD)
- Remote-Zugriff über SSH und PowerShell 7
- Virtualisierung: VMware Workstation (Host-only Netzwerk)

## Quickstart (Kurzüberblick)
1. Server VM aufsetzen und Domäne „HomeLab.local“ erstellen
2. SSH & PowerShell 7 installieren
3. AD-Struktur per PowerShell aufbauen
4. Validierung und Tests durchführen

## Weitere Details
Die detaillierte AD-Einrichtung ist im Sub-Repository **Active Directory** dokumentiert.
