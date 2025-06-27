#!/bin/bash
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="check_selinux.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/check_selinux.log"
BACKUP_DIR="/opt/remoteaccess.nija/$(date +%Y%m%d)"

mkdir -p $LOG_DIR
mkdir -p $BACKUP_DIR

{
echo "===== Check SELinux ====="
date

if command -v sestatus &> /dev/null; then
    STATUS=$(sestatus | grep "SELinux status:" | awk '{print $3}')
    MODE=$(sestatus | grep "Current mode:" | awk '{print $3}')
    echo "SELinux status: $STATUS, mode: $MODE"

    if [ "$STATUS" == "enabled" ] && [ "$MODE" != "enforcing" ]; then
        sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
        setenforce 1
        echo "SELinux mode set to enforcing."
    else
        echo "SELinux is already enforcing or disabled."
    fi
else
    echo "SELinux is not installed."
fi
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
