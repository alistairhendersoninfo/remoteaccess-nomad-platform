#!/bin/bash
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="harden_ssh_config.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/harden_ssh_config.log"
BACKUP_DIR="/opt/remoteaccess.nija/$(date +%Y%m%d)"

mkdir -p $LOG_DIR
mkdir -p $BACKUP_DIR

{
echo "===== Harden SSH Configuration ====="
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

echo "Protocol 2" >> $CONFIG_FILE
echo "Ciphers aes256-ctr,aes192-ctr,aes128-ctr" >> $CONFIG_FILE
echo "MACs hmac-sha2-512,hmac-sha2-256" >> $CONFIG_FILE
echo "KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1" >> $CONFIG_FILE

systemctl reload sshd

echo "SSH configuration hardened."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
