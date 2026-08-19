# 08 - Kairos Report Engine

Kairos can be used locally for pentest project management and reporting.

Do not expose it to the public Internet.

Install:

```bash
cd ~/tools
git clone https://github.com/TeneBrae93/kairos-report-engine.git
cd kairos-report-engine
docker compose up -d
```

Browse:

```text
https://localhost:8443
```

Kairos uses persistent Docker volumes for its database, reports, and certificates.

Do not casually run:

```bash
docker compose down -v
```

because `-v` removes persistent volumes.

See the backup helpers under:

```text
scripts/kali/
```

and the autostart unit under:

```text
systemd/kairos.service.example
```
