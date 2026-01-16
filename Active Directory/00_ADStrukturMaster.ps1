# Test auf LabServer: OK, alles läuft durch, Ausgaben wie erwartet

# 1. OUs erstellen
.\01_OUs.ps1
Start-Sleep -Seconds 1

# 2. Benutzer erstellen
.\02_Users.ps1
Start-Sleep -Seconds 1

# 3. Gruppen erstellen
.\03_Groups.ps1
