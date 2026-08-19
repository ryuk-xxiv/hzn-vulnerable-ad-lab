# 02 - Kali Setup

## Baseline
Use the official Kali VMware image.

Recommended resources:

```text
4 vCPU
8-12 GB RAM
80 GB+ disk
Adapter 1: NAT
Adapter 2: VMnet2
```

Update:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
```

Useful packages:

```bash
sudo apt install -y \
  git curl wget pipx python3-venv python3-dev build-essential \
  golang-go tmux jq unzip p7zip-full tree docker.io docker-compose \
  enum4linux-ng seclists
```

Docker:

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

Log out/in, then:

```bash
docker run --rm hello-world
docker compose version
```

Kerbrute:

```bash
go install github.com/ropnop/kerbrute@latest
echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc
source ~/.zshrc
```

Suggested directories:

```bash
mkdir -p ~/tools ~/repos ~/wordlists ~/engagements
mkdir -p ~/labs/{htb,hacksmarter,tcm,other,ad}
```

## Configure lab NIC

Find the lab connection:

```bash
nmcli connection show
```

Example:

```bash
sudo nmcli connection modify "Wired connection 2" \
  ipv4.method manual \
  ipv4.addresses 10.10.10.50/24 \
  ipv4.gateway "" \
  ipv4.never-default yes

sudo nmcli connection down "Wired connection 2"
sudo nmcli connection up "Wired connection 2"
```

## Split DNS

After DC01 is running:

```bash
sudo nmcli connection modify "Wired connection 2" \
  ipv4.dns "10.10.10.10" \
  ipv4.dns-search "~hznlab.local"
```

Create:

```bash
sudo nano /etc/NetworkManager/conf.d/dns.conf
```

Add:

```ini
[main]
dns=systemd-resolved
```

Restart:

```bash
sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager
```

Verify:

```bash
resolvectl status
resolvectl query dc01.hznlab.local
resolvectl query github.com
```

AD DNS should route over the lab NIC; public DNS should continue over NAT.
