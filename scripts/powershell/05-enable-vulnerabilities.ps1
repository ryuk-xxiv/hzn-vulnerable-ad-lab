Import-Module ActiveDirectory
$Domain = "DC=hznlab,DC=local"

Write-Host "[+] Kerberoasting..."
setspn -S MSSQLSvc/SRV01.hznlab.local:1433 HZNLAB\svc_sql
Set-ADAccountPassword svc_sql -Reset -NewPassword (ConvertTo-SecureString "Summer2026!" -AsPlainText -Force)
Set-ADUser svc_sql -PasswordNeverExpires $true

Write-Host "[+] AS-REP roasting..."
if (-not (Get-ADUser legacy_app -ErrorAction SilentlyContinue)) {
    New-ADUser -Name "Legacy Application" -SamAccountName "legacy_app" `
      -UserPrincipalName "legacy_app@hznlab.local" `
      -Description "Legacy application integration account" `
      -Path "OU=Disabled Accounts,$Domain" `
      -AccountPassword (ConvertTo-SecureString "Legacy2024!" -AsPlainText -Force) `
      -Enabled $true -ChangePasswordAtLogon $false
}
Set-ADAccountControl legacy_app -DoesNotRequirePreAuth $true

Write-Host "[+] ACL abuse..."
$Target = (Get-ADGroup GG_WorkstationAdmins).DistinguishedName
& dsacls $Target /G "HZNLAB\GG_HelpDesk:WP;member"

Write-Host "[+] Backup-service password..."
Set-ADAccountPassword svc_backup -Reset -NewPassword (ConvertTo-SecureString "Backup2025!" -AsPlainText -Force)
Set-ADUser svc_backup -PasswordNeverExpires $true

Write-Host "[+] AD-side vulnerability configuration complete."
Write-Host "[!] Complete the documented host-local configuration on WS01/SRV01."
