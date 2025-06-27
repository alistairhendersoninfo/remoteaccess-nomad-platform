#!/bin/bash
SCRIPT_NAME="set_root_banner_with_ninja_prompt.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/set_root_banner_with_ninja_prompt.log"

mkdir -p $LOG_DIR

{
echo "===== Setting root login banner ====="
date

tee /etc/motd <<'BANNER'
===============================================================================
ROOT CONSOLE LOGIN

This system is part of the RemoteAccess.Ninja Platform.

Unauthorized access is prohibited. All activities are logged and monitored.

===============================================================================
BANNER

echo "✅ root login banner set in /etc/motd."

} | tee -a $LOG_FILE

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
