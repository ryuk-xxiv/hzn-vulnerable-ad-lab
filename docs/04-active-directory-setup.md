# 04 - Active Directory Setup

Build the clean directory before adding vulnerabilities.

## OU layout

```text
hznlab.local
+-- HZN Users
|   +-- Executive
|   +-- IT
|   +-- Finance
|   +-- HR
|   +-- Sales
|   +-- Operations
+-- HZN Computers
|   +-- Workstations
|   +-- Servers
+-- HZN Groups
+-- Service Accounts
+-- Disabled Accounts
```

Run manually or use:

```powershell
.\scripts\powershell\01-create-ous.ps1
.\scripts\powershell\02-create-groups.ps1
.\scripts\powershell\03-create-users.ps1
.\scripts\powershell\04-create-service-accounts.ps1
```

Global groups:

```text
GG_Executive
GG_IT
GG_HelpDesk
GG_Finance
GG_HR
GG_Sales
GG_Operations
GG_ServerAdmins
GG_WorkstationAdmins
```

Domain-local resource groups:

```text
DL_FinanceShare_RW
DL_HRShare_RW
DL_SalesShare_RW
```

Lab user default password:

```text
HznLab2026!
```

Test a domain login on WS01:

```text
HZNLAB\jwilson
HznLab2026!
```

Then:

```powershell
whoami
whoami /groups
$env:LOGONSERVER
```

Snapshot clean populated state before introducing vulnerabilities.
