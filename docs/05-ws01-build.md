# 05 - WS01 Build

Create:

```text
Name:      WS01
OS:        Windows 11 Pro 25H2
RAM:       4 GB
CPU:       2 cores
Disk:      64 GB
Network:   VMnet2
```

Install VMware Tools.

Rename:

```powershell
Rename-Computer -NewName "WS01" -Restart
```

Configure:

```text
IP:       10.10.10.21
Mask:     255.255.255.0
Gateway:  blank
DNS:      10.10.10.10
```

Validate:

```powershell
Resolve-DnsName dc01.hznlab.local
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.hznlab.local
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

Verify:

```powershell
Get-CimInstance Win32_ComputerSystem |
  Select Name,Domain,PartOfDomain

Test-ComputerSecureChannel -Verbose
nltest /dsgetdc:hznlab.local
```

Move to Workstations OU on DC01:

```powershell
$domain = "DC=hznlab,DC=local"
Get-ADComputer WS01 |
  Move-ADObject -TargetPath "OU=Workstations,OU=HZN Computers,$domain"
```

Enable only required firewall rules:

```powershell
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"
Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In
```

Validate from Kali:

```bash
nxc smb 10.10.10.21
```

Snapshot:

```text
WS01-01 - Clean Domain Joined
```
