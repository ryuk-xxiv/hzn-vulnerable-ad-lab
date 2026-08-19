# 07 - BloodHound Community Edition

## Install CLI

```bash
mkdir -p ~/tools/bloodhound-ce
cd ~/tools/bloodhound-ce

curl -L \
https://github.com/SpecterOps/bloodhound-cli/releases/latest/download/bloodhound-cli-linux-amd64.tar.gz \
-o /tmp/bloodhound-cli.tar.gz

tar -xzf /tmp/bloodhound-cli.tar.gz -C ~/tools/bloodhound-ce
chmod +x ~/tools/bloodhound-ce/bloodhound-cli
./bloodhound-cli install
```

Retain the initial credentials and change the admin password after first login.

Typical local UI:

```text
http://localhost:8080
```

If Burp also uses 8080, move Burp to a different listener such as `127.0.0.1:8081`.

## Collection

```bash
mkdir -p ~/labs/ad/bloodhound/acl-baseline
cd ~/labs/ad/bloodhound/acl-baseline

bloodhound-python \
  -u jwilson \
  -p 'HznLab2026!' \
  -d hznlab.local \
  -ns 10.10.10.10 \
  -dc dc01.hznlab.local \
  -c All
```

Upload the generated JSON files to BloodHound CE.

After the ACL scenario is enabled, inspect:

```text
JWILSON -> GG_HELPDESK -> GG_WORKSTATIONADMINS
```

## Autostart

Use the example unit:

```text
systemd/bloodhound.service.example
```
