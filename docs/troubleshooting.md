# Troubleshooting

## Ping fails but host is reachable

Windows Firewall may block ICMP.

Check:

```bash
ip neigh show 10.10.10.10
sudo nmap -Pn -p 135,445 10.10.10.10
```

A valid ARP neighbor plus filtered/open ports means VMware networking may be fine.

## SMB is filtered

Enable the built-in Windows firewall group:

```powershell
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"
```

Optionally enable ICMP:

```powershell
Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In
```

Do not globally disable Windows Firewall.

## NetExec Kerberoasting fails with HZNLAB.LOCAL:88 resolution

If Impacket works with `-dc-ip 10.10.10.10` but NetExec reports:

```text
Name or service not known
```

check split DNS.

```bash
dig @10.10.10.10 dc01.hznlab.local +short
getent hosts dc01.hznlab.local
resolvectl status
```

If direct DNS works but normal resolution does not, configure `systemd-resolved` as documented in `02-kali-setup.md`.

## GPO applies but local Administrators does not change

Verify:

```powershell
gpresult /r /scope computer
Get-LocalGroupMember Administrators
```

In the GPO, verify:

```text
Computer Configuration
 -> Preferences
 -> Control Panel Settings
 -> Local Users and Groups

Action: Update
Group: Administrators (built-in)
Member: HZNLAB\GG_WorkstationAdmins
```

Do not select options that delete all current members.

## BloodHound stops after reboot

```bash
docker ps -a
```

Start from the Compose directory:

```bash
docker compose up -d
```

For autostart, install the example systemd service.

## `.local` warning from dig

Linux tools may warn that `.local` is reserved for mDNS.

The isolated lab still works if split DNS routes `hznlab.local` to DC01.
