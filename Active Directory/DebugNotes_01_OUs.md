# Lab-AD Skript: Debugging & Anpassungen

**Skript:** `01_OUs.ps1` – Erstellung von OUs im HomeLab

## Problemstellung
- Skript erzeugt beim ersten Durchlauf **ADIdentityNotFoundException**:
  - Beim Prüfen existierender OUs (`Get-ADOrganizationalUnit -Identity`)
  - Beim Erstellen von OUs, die schon existieren
  - Beim Erstellen von Unter-OUs kurz nach Erstellung der Parent-OU  

Ursache: 
- Timing / AD-Latenz → Skript läuft schneller als AD Objekte repliziert  
- Inkonsistente OU-Namen: ursprüngliche Pfade (`Users`, `Computers`) existierten nicht → Exceptions

Testergebnis: 

## Änderungen / Debugging

1. **OU-Namen konsistent gemacht**
   - Base-OUs: `LabUsers`, `LabComputers`  
   - Unter-OUs → Pfade angepasst:
     ```powershell
     "OU=LabUsers,$DomainDN"
     "OU=LabComputers,$DomainDN"
     ```

2. **Fehlerbehandlung**
   - `try/catch` für `New-ADOrganizationalUnit` eingefügt  
   - `-ErrorAction Stop` hinzugefügt → `catch` fängt zuverlässig existierende OUs ab

3. **Timing / Latenz**
   - Minimaler Delay nach Erstellung der Parent-OUs:
     ```powershell
     Start-Sleep -Milliseconds 500
     ```
   - Hinweis: pragmatisch für Lab, keine 100%-Garantie

4. **Optional / sauberer Ansatz**
   - Hilfsfunktion `Ensure-OU(Name,Path)` für einheitliche Logik  
   - Eliminierung von `$ExistingOUs` Lookup → Skript bleibt idempotent
