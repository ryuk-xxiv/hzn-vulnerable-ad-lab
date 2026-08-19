#!/usr/bin/env bash
set -euo pipefail

KAIROS_DIR="$HOME/tools/kairos-report-engine"

cd "$KAIROS_DIR"
docker compose stop

cleanup() {
    cd "$KAIROS_DIR"
    docker compose start
}
trap cleanup EXIT

"$HOME/scripts/backup-kairos.sh"
echo "[+] Backup completed successfully."
