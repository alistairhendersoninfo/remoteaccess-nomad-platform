#!/bin/bash
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="user_account_audit.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/user_account_audit.log"

mkdir -p $LOG_DIR

{
echo "===== User Account Audit ====="
date

echo "Users with shell access:"
awk -F: '($7 ~ /(bash|sh|zsh|ksh)$/) { print $1 " -> " $7 }' /etc/passwd

echo "Audit complete."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
