#!/bin/bash
# Update script execution record in SQLite database

SCRIPT_NAME="$1"
STATUS="$2"

if [ -z "$SCRIPT_NAME" ] || [ -z "$STATUS" ]; then
  echo "Usage: update_exec.sh <script_name> <status>"
  exit 1
fi

source "$(dirname "$0")/common.sh"

sqlite3 "$DB_PATH" <<SQL
UPDATE scripts
SET run_date = datetime('now'), status = '$STATUS'
WHERE name = '$SCRIPT_NAME';
SQL

echo "✅ Execution record updated for $SCRIPT_NAME with status: $STATUS"
