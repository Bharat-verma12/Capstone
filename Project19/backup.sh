#!/bin/bash

set -euo pipefail

BUCKET_NAME="project19-s3-backup-2026-uniqueid"
SOURCE_DIR="$HOME/Project19/logs"
BACKUP_DIR="$HOME/Project19/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/logs_$DATE.tar.gz"

echo "Starting backup: $(date)"

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

aws s3 cp "$BACKUP_FILE" \
  "s3://$BUCKET_NAME/backups/"

echo "Backup completed: $(date)"
