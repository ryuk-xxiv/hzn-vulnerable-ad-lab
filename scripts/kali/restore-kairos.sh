#!/usr/bin/env bash
set -euo pipefail

[[ $# -eq 1 ]] || {
  echo "Usage: $0 /mnt/hgfs/KairosBackups/kairos-backup-YYYY-MM-DD_HH-MM-SS"
  exit 1
}

BACKUP_DIR="$1"
[[ -d "$BACKUP_DIR" ]] || { echo "[-] Backup directory not found"; exit 1; }

declare -A VOLUMES=(
  ["kairos-data.tar.gz"]="kairos-report-engine_kairos-data"
  ["kairos-reports.tar.gz"]="kairos-report-engine_kairos-reports"
  ["kairos-certs.tar.gz"]="kairos-report-engine_kairos-certs"
)

echo "[!] This overwrites current Kairos Docker volume contents."
read -r -p "Type RESTORE to continue: " CONFIRM
[[ "$CONFIRM" == "RESTORE" ]] || { echo "[-] Cancelled"; exit 1; }

cd "$HOME/tools/kairos-report-engine"
docker compose stop

for ARCHIVE in "${!VOLUMES[@]}"; do
    VOLUME="${VOLUMES[$ARCHIVE]}"
    [[ -f "${BACKUP_DIR}/${ARCHIVE}" ]] || { echo "[-] Missing ${ARCHIVE}"; exit 1; }

    docker run --rm -v "${VOLUME}:/restore" alpine \
      sh -c 'rm -rf /restore/* /restore/.[!.]* /restore/..?* 2>/dev/null || true'

    docker run --rm \
      -v "${VOLUME}:/restore" \
      -v "${BACKUP_DIR}:/backup:ro" \
      alpine \
      tar -xzf "/backup/${ARCHIVE}" -C /restore
done

docker compose start
echo "[+] Restore complete."
