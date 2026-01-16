
```powershell

# Benutzer → Globale Gruppen
Add-ADGroupMember GG_IT_Admins it.admin
Add-ADGroupMember GG_Guests guest.user

# Globale Gruppen → Domain Local Gruppen
Add-ADGroupMember DL_File_IT_RW GG_IT_Admins

```
