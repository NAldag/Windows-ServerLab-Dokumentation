# Beispiel: CLIENT01 nach OU Clients verschieben
Move-ADObject -Identity "CN=CLIENT01,CN=Computers,DC=HomeLab,DC=local" `
  -TargetPath "OU=Clients,OU=Computers,DC=HomeLab,DC=local"
