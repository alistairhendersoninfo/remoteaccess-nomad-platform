#!/bin/bash
if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

SCRIPT_NAME="update_upgrade.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/update_upgrade.log"

mkdir -p $LOG_DIR

{
echo "===== System Update and Upgrade ====="
date

export DEBIAN_FRONTEND=noninteractive

apt update -qq
apt -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    --yes --quiet --allow-downgrades --allow-remove-essential --allow-change-held-packages \
    full-upgrade

echo "System packages have been silently updated and upgraded."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
