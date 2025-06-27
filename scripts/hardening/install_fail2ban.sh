#!/bin/bash
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="install_fail2ban.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/install_fail2ban.log"
BACKUP_DIR="/opt/remoteaccess.nija/$(date +%Y%m%d)"

mkdir -p $LOG_DIR
mkdir -p $BACKUP_DIR

{
echo "===== Install Fail2ban ====="
date

if ! command -v fail2ban-client &> /dev/null; then
    apt update
    apt install -y fail2ban
    echo "Fail2ban installed."
else
    echo "Fail2ban already installed."
fi

JAIL_LOCAL="/etc/fail2ban/jail.local"
BACKUP_FILE="$BACKUP_DIR/jail.local"

if [ -f "$JAIL_LOCAL" ]; then
    if [ -f "$BACKUP_FILE" ]; then
        i=1
        while [ -f "${BACKUP_FILE}-$i" ]; do
            ((i++))
        done
        cp $JAIL_LOCAL "${BACKUP_FILE}-$i"
        echo "Backup created: ${BACKUP_FILE}-$i"
    else
        cp $JAIL_LOCAL $BACKUP_FILE
        echo "Backup created: $BACKUP_FILE"
    fi
fi

cat > /etc/fail2ban/jail.local <<EOF2
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = auto
EOF2

systemctl enable fail2ban
systemctl restart fail2ban

echo "Fail2ban configured and restarted."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
