# 03 - DC01 Build

## VM configuration

```text
Name:      DC01
OS:        Windows Server 2022 Desktop Experience
RAM:       6 GB
CPU:       2 cores
Disk:      60 GB
Network:   VMnet2 only
```

Install VMware Tools.

Rename:

```powershell
Rename-Computer -NewName "DC01" -Restart
```

Configure:

```text
IP:       10.10.10.10
Mask:     255.255.255.0
Gateway:  blank
DNS:      10.10.10.10
```

Snapshot:

```text
DC01-01 - Clean Server 2022
```

Install AD DS:

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

Create forest:

```powershell
Install-ADDSForest `
  -DomainName "hznlab.local" `
  -DomainNetbiosName "HZNLAB" `
  -InstallDNS
```

Retain the DSRM password.

Verify:

```powershell
Get-ADDomain
Get-ADForest
Get-ADDomainController
Get-Service ADWS,DNS,KDC,Netlogon,NTDS
dcdiag
dcdiag /test:dns
```

DNS:

```powershell
Resolve-DnsName hznlab.local
Resolve-DnsName dc01.hznlab.local
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.hznlab.local
```

From Kali:

```bash
sudo nmap -Pn -sT \
  -p 53,88,135,139,389,445,464,636,3268,3269,5985 \
  10.10.10.10

nxc smb 10.10.10.10
```

Snapshot:

```text
DC01-02 - Clean AD DS
```
