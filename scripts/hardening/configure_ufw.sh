#!/bin/bash
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="configure_ufw.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/configure_ufw.log"
BACKUP_DIR="/opt/remoteaccess.nija/$(date +%Y%m%d)"

mkdir -p $LOG_DIR
mkdir -p $BACKUP_DIR

{
echo "===== Configure UFW ====="
date

if ! command -v ufw &> /dev/null; then
    apt update
    apt install -y ufw
fi

UFW_BACKUP="$BACKUP_DIR/ufw_rules.txt"

if ufw status verbose &> /dev/null; then
    if [ -f "$UFW_BACKUP" ]; then
        i=1
        while [ -f "${UFW_BACKUP}-$i" ]; do
            ((i++))
        done
        ufw status verbose > "${UFW_BACKUP}-$i"
        echo "UFW rules backup created: ${UFW_BACKUP}-$i"
    else
        ufw status verbose > $UFW_BACKUP
        echo "UFW rules backup created: $UFW_BACKUP"
    fi
fi

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable

echo "UFW firewall configured."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
