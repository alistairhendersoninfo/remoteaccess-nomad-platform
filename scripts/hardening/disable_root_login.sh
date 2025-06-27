#!/bin/bash
# Virgin install marker check
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="disable_root_login.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/disable_root_login.log"
BACKUP_DIR="/opt/remoteaccess.nija/$(date +%Y%m%d)"

mkdir -p $LOG_DIR
mkdir -p $BACKUP_DIR

{
echo "===== Disable root SSH login ====="
date

CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="$BACKUP_DIR/sshd_config"

if [ -f "$BACKUP_FILE" ]; then
    i=1
    while [ -f "${BACKUP_FILE}-$i" ]; do
        ((i++))
    done
    cp $CONFIG_FILE "${BACKUP_FILE}-$i"
    echo "Backup created: ${BACKUP_FILE}-$i"
else
    cp $CONFIG_FILE $BACKUP_FILE
    echo "Backup created: $BACKUP_FILE"
fi

if grep -q "^PermitRootLogin" $CONFIG_FILE; then
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' $CONFIG_FILE
else
    echo "PermitRootLogin no" >> $CONFIG_FILE
fi

systemctl reload sshd

echo "Root SSH login has been disabled."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
