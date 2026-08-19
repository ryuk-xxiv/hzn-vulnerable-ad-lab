#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT="/mnt/hgfs/KairosBackups"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_DIR="${BACKUP_ROOT}/kairos-backup-${TIMESTAMP}"

VOLUMES=(
  "kairos-report-engine_kairos-data"
  "kairos-report-engine_kairos-reports"
  "kairos-report-engine_kairos-certs"
)

mountpoint -q /mnt/hgfs || { echo "[-] /mnt/hgfs not mounted"; exit 1; }
[[ -d "$BACKUP_ROOT" ]] || { echo "[-] Missing $BACKUP_ROOT"; exit 1; }

mkdir -p "$BACKUP_DIR"

for VOLUME in "${VOLUMES[@]}"; do
    SHORT="${VOLUME#kairos-report-engine_}"
    docker run --rm \
      -v "${VOLUME}:/source:ro" \
      -v "${BACKUP_DIR}:/backup" \
      alpine \
      tar -czf "/backup/${SHORT}.tar.gz" -C /source .
done

{
  echo "Kairos Report Engine Backup"
  echo "Created: $(date)"
  printf '%s\n' "${VOLUMES[@]}"
} > "${BACKUP_DIR}/backup-info.txt"

for A in "${BACKUP_DIR}"/*.tar.gz; do
    gzip -t "$A"
done

mapfile -t OLD < <(
  find "$BACKUP_ROOT" -maxdepth 1 -mindepth 1 -type d \
    -name 'kairos-backup-*' -printf '%T@ %p\n' |
  sort -nr | tail -n +11 | cut -d' ' -f2-
)

for D in "${OLD[@]}"; do
    rm -rf -- "$D"
done

echo "[+] Backup complete: $BACKUP_DIR"
