#!/bin/bash
SCRIPT_NAME="set_ninjaadmin_banner.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/set_ninjaadmin_banner.log"

mkdir -p $LOG_DIR

{
echo "===== Setting ninjaadmin Security Banner ====="
date

tee /etc/issue <<'BANNER'
===============================================================================
                         _                                   
 _ __ ___ _ __ ___   ___ | |_ ___  __ _  ___ ___ ___  ___ ___ 
| '__/ _ \ '_ ` _ \ / _ \| __/ _ \/ _` |/ __/ __/ _ \/ __/ __|
| | |  __/ | | | | | (_) | ||  __/ (_| | (_| (_|  __/\__ \__ \
|_|  \___|_| |_| |_|\___/ \__\___|\__,_|\___\___\___||___/___/
                                                              

RemoteAccess.Ninja Platform

Unauthorized access is prohibited. All activities are logged and monitored.

By proceeding, you acknowledge and agree to system security policies.

===============================================================================
BANNER

echo "✅ ninjaadmin banner set in /etc/issue."

} | tee -a $LOG_FILE

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
