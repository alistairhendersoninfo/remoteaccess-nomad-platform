#!/bin/bash

SCRIPT_NAME="check_virgin_install.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/check_virgin_install.log"
MARKER="/opt/remoteaccess.nija/virgin_check_passed"

mkdir -p $LOG_DIR
mkdir -p /opt/remoteaccess.nija

{
echo "===== Check Virgin Install ====="
date

if [ -f "$MARKER" ]; then
    echo "Virgin install check already passed. Marker exists."
else
    UPTIME_SECONDS=$(awk '{print $1}' /proc/uptime | cut -d. -f1)
    USER_COUNT=$(awk -F: '$3 >= 1000 { count++ } END { print count }' /etc/passwd)

    echo "Uptime (seconds): $UPTIME_SECONDS"
    echo "Non-system user accounts: $USER_COUNT"

    if [ "$UPTIME_SECONDS" -gt 1800 ] || [ "$USER_COUNT" -gt 2 ]; then
        echo "Virgin install check failed."
        exit 1
    else
        touch "$MARKER"
        echo "Virgin install check passed. Marker file created."
    fi
fi
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
