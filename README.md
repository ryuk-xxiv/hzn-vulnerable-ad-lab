# HZN Vulnerable Active Directory Lab

A reproducible Active Directory penetration-testing homelab built with VMware Workstation Pro, Windows Server 2022, Windows 11, and Kali Linux.

The project teaches both sides of Active Directory security: how a small business-style domain is built, which administrative choices create attack paths, how those paths are discovered with offensive tooling, and how to reset the environment for repeated testing.

> **Authorized lab use only.** Use the techniques in this repository only in isolated labs or against systems you own or have explicit authorization to test.

## Architecture

```text
                         VMware Workstation Pro

                         VMnet2 - Host Only
                           10.10.10.0/24
                                 |
                +----------------+----------------+
                |                |                |
              DC01             SRV01             WS01
         Windows Server    Windows Server      Windows 11
              2022             2022              25H2
          10.10.10.10      10.10.10.20       10.10.10.21
                |                |                |
             AD DS/DNS        Member Server    Workstation
                |                |                |
                +----------------+----------------+
                                 |
                                Kali
                            10.10.10.50
                                 |
                           Second NIC / NAT
                                 |
                              Internet
```

Domain: `hznlab.local`  
NetBIOS: `HZNLAB`

| Host | OS | IP | Role |
|---|---|---:|---|
| DC01 | Windows Server 2022 | 10.10.10.10 | AD DS / DNS |
| SRV01 | Windows Server 2022 | 10.10.10.20 | Member server |
| WS01 | Windows 11 Pro 25H2 | 10.10.10.21 | Domain workstation |
| Kali | Kali Linux | 10.10.10.50 | Attack / assessment workstation |

## What the project covers

- VMware host-only range networking
- Kali dual-homed networking and split DNS
- Windows Server 2022 domain-controller deployment
- Windows 11 domain joining
- Windows Server 2022 member-server deployment
- AD OUs, groups, users, service accounts, and Group Policy
- BloodHound Community Edition
- Kairos Report Engine
- Kerberoasting
- AS-REP roasting
- Active Directory ACL abuse
- Credential exposure via SMB
- Local administrator escalation
- Snapshots and reset procedures
- Troubleshooting notes from the actual build

## Vulnerability scenarios

### Kerberoasting
`svc_sql` has an MSSQL SPN, a deliberately weak lab password, and local administrator access to SRV01.

### AS-REP Roasting
`legacy_app` has Kerberos pre-authentication disabled and a deliberately weak lab password.

### AD ACL Abuse
`GG_HelpDesk` can modify membership of `GG_WorkstationAdmins`, while a GPO makes `GG_WorkstationAdmins` a local administrator on WS01.

```text
JWILSON
   |
 MemberOf
   v
GG_HELPDESK
   |
 WriteProperty(member)
   v
GG_WORKSTATIONADMINS
   |
   GPO
   v
WS01\Administrators
```

### Credential Exposure
`jwilson` can read a hidden deployment share on SRV01 containing plaintext `svc_backup` credentials. `svc_backup` is a local administrator on SRV01.

## Build order

1. [VMware networking](docs/01-vmware-networking.md)
2. [Kali setup](docs/02-kali-setup.md)
3. [DC01](docs/03-dc01-build.md)
4. [Active Directory population](docs/04-active-directory-setup.md)
5. [WS01](docs/05-ws01-build.md)
6. [SRV01](docs/06-srv01-build.md)
7. [BloodHound](docs/07-bloodhound.md)
8. [Kairos](docs/08-kairos.md)
9. [Snapshots and reset](docs/09-snapshots-and-reset.md)
10. [Troubleshooting](docs/troubleshooting.md)

Then enable the scenarios under [`vulnerabilities/`](vulnerabilities/).

## Manual vs automated build

**Manual track:** recommended for first-time builders. Follow the documentation and create the domain/configuration yourself so you understand what creates each attack path.

**Automated track:** once you understand the environment, use the PowerShell scripts under `scripts/powershell/` for faster repeat builds.

Suggested order:

```powershell
.\01-create-ous.ps1
.\02-create-groups.ps1
.\03-create-users.ps1
.\04-create-service-accounts.ps1
.\05-enable-vulnerabilities.ps1
```

## Suggested snapshots

### DC01
```text
DC01-01 - Clean Server 2022
DC01-02 - Clean AD DS
DC01-03 - Populated Clean Domain
DC01-04 - Vulnerable Domain
```

### WS01
```text
WS01-01 - Clean Domain Joined
WS01-02 - Populated Clean Domain
WS01-03 - Vulnerable Workstation
```

### SRV01
```text
SRV01-01 - Clean Domain Joined
SRV01-02 - Vulnerable Member Server
```

## Lab credentials

Examples used by the project:

```text
HznLab2026!
Summer2026!
Legacy2024!
Backup2025!
```

These are deliberately weak **lab-only** credentials. Never reuse them outside this disposable environment.

## Security notes

- Keep VMnet2 host-only.
- Do not bridge the vulnerable Windows machines to a production/home LAN.
- Do not expose BloodHound, Kairos, SMB, LDAP, WinRM, or other lab services to the public Internet.
- Do not commit real credentials, client assessment data, BloodHound exports, private keys, reports, ISOs, or VM disks.
- Snapshots are rollback points, not backups.

## Future expansion

Good next scenarios include AD CS, GPO delegation, WriteDACL/WriteOwner chains, delegation abuse, MSSQL, IIS, NTLM relay, a second domain/trust, LAPS, and detection/remediation exercises.

## License

MIT. See [LICENSE](LICENSE).

## Disclaimer

All systems, names, passwords, IP addresses, organizations, and vulnerable configurations in this repository are fictitious and intended solely for controlled training and explicitly authorized testing.
