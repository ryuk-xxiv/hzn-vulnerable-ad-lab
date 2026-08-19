# 01 - VMware Networking

## Goal
Create an isolated network for intentionally vulnerable Windows systems while allowing Kali to retain Internet access.

## Create VMnet2
In VMware Workstation Pro:

```text
Edit -> Virtual Network Editor -> Add Network
```

Create:

```text
Network:       VMnet2
Type:          Host-only
Subnet:        10.10.10.0
Mask:          255.255.255.0
VMware DHCP:   Disabled
```

Do not use bridged or NAT mode for the vulnerable Windows hosts.

## Address plan

```text
DC01    10.10.10.10
SRV01   10.10.10.20
WS01    10.10.10.21
Kali    10.10.10.50
```

No default gateway is required on the Windows lab systems.

## Kali adapters

```text
Adapter 1 -> NAT
Adapter 2 -> Custom: VMnet2
```

This allows Kali to reach both the Internet and the isolated range without giving the vulnerable Windows hosts Internet exposure.

## Verify

```bash
ip -br addr
ip route
```

Expected pattern:

```text
eth0 -> VMware NAT
eth1 -> 10.10.10.50/24

default route -> eth0
10.10.10.0/24 -> eth1
```
