# 09 - Snapshots and Reset

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

## Vulnerability vs exploited state

Keep the vulnerable configuration, but reset the state created by exploitation.

Example:

```text
Vulnerability:
GG_HelpDesk can modify GG_WorkstationAdmins membership.

Exploited state:
jwilson has added himself to GG_WorkstationAdmins.
```

Reset only the exploited state:

```powershell
Remove-ADGroupMember `
  -Identity "GG_WorkstationAdmins" `
  -Members "jwilson" `
  -Confirm:$false
```

Validate:

```bash
nxc smb 10.10.10.21 \
  -u jwilson \
  -p 'HznLab2026!'
```

Authentication should succeed without `(Pwn3d!)`.

Snapshots are rollback points, not backups.
