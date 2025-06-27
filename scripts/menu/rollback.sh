#!/bin/bash
# Remote Access Platform Rollback Script
# Restores original backed up configuration files and deletes ninjaadmin user

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/rollback.log"
BACKUP_BASE="/opt/remoteaccess.nija"

mkdir -p $LOG_DIR

{
echo "===== Rollback Started ====="
date

# Confirm rollback action
read -p "⚠️ WARNING: This will restore original configuration backups and delete ninjaadmin user. Continue? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Rollback aborted by user."
    exit 0
fi

# Restore original backup files
for BACKUP_DIR in $(ls -d $BACKUP_BASE/*/ 2>/dev/null); do
  echo "Processing backups in $BACKUP_DIR"

  for ORIGINAL in $(find "$BACKUP_DIR" -type f ! -name "*-*"); do
    BASENAME=$(basename "$ORIGINAL")
    TARGET_FILE=""

    # Determine target file restore path based on known backups
    case "$BASENAME" in
      sshd_config) TARGET_FILE="/etc/ssh/sshd_config" ;;
      jail.local) TARGET_FILE="/etc/fail2ban/jail.local" ;;
      ufw_rules.txt) echo "Skipping UFW rules text restore (manual review needed)"; continue ;;
      *)
        echo "Unknown backup file: $ORIGINAL – skipping"
        continue
        ;;
    esac

    if [ -n "$TARGET_FILE" ]; then
      cp "$ORIGINAL" "$TARGET_FILE"
      echo "✅ Restored $TARGET_FILE from $ORIGINAL"
    fi
  done
done

# Delete ninjaadmin user if exists
if id "ninjaadmin" &>/dev/null; then
  userdel -r ninjaadmin
  echo "✅ Deleted ninjaadmin user and home directory."
fi

# Optionally delete virgin marker
read -p "Delete virgin install marker to allow re-run as fresh install? (y/n): " DELETE_MARKER
if [[ "$DELETE_MARKER" == "y" ]]; then
  rm -f /opt/remoteaccess.nija/virgin_check_passed
  echo "✅ Virgin install marker deleted."
fi

# Optionally delete SQLite database
read -p "Delete SQLite database to fully reset deployment state? (y/n): " DELETE_DB
if [[ "$DELETE_DB" == "y" ]]; then
  rm -f /opt/remoteaccess.nija/remoteaccess.db
  echo "✅ SQLite database deleted."
fi

echo "===== Rollback Completed ====="
} | tee -a $LOG_FILE
