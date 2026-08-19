# 06 - SRV01 Build

Create:

```text
Name:      SRV01
OS:        Windows Server 2022 Desktop Experience
RAM:       4-6 GB
CPU:       2 cores
Disk:      60 GB
Network:   VMnet2
```

Rename:

```powershell
Rename-Computer -NewName "SRV01" -Restart
```

Configure:

```text
IP:       10.10.10.20
Mask:     255.255.255.0
Gateway:  blank
DNS:      10.10.10.10
```

Validate:

```powershell
Resolve-DnsName dc01.hznlab.local
Test-NetConnection dc01.hznlab.local -Port 88
Test-NetConnection dc01.hznlab.local -Port 389
Test-NetConnection dc01.hznlab.local -Port 445
```

Join:

```powershell
Add-Computer `
  -DomainName "hznlab.local" `
  -Credential "HZNLAB\Administrator" `
  -Restart
```

Move to Servers OU on DC01:

```powershell
$domain = "DC=hznlab,DC=local"
Get-ADComputer SRV01 |
  Move-ADObject -TargetPath "OU=Servers,OU=HZN Computers,$domain"
```

Enable:

```powershell
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"
Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In
```

Validate from Kali:

```bash
nxc smb 10.10.10.10 10.10.10.20 10.10.10.21 \
  -u jwilson \
  -p 'HznLab2026!'
```

At the clean stage, authentication should succeed without administrative access.

Snapshot:

```text
SRV01-01 - Clean Domain Joined
```
