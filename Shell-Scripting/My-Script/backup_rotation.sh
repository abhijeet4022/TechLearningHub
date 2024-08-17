#!/bin/bash
clear

BACKUP_DIR="/root/backup"
MAX_BACKUPS="5"

while [ $(ls -1 "$BACKUP_DIR" | wc -l) -gt "$MAX_BACKUPS" ]; do

  oldest_backup=$( ls -1t "$BACKUP_DIR" | tail -n 1 )
  rm -rf "{$BACKUP_DIR/$oldest_backup}"

done


