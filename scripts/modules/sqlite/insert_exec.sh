#!/bin/bash
# Insert script execution record into SQLite database

SCRIPT_NAME="$1"
STATUS="$2"

if [ -z "$SCRIPT_NAME" ] || [ -z "$STATUS" ]; then
  echo "Usage: insert_exec.sh <script_name> <status>"
  exit 1
fi

source "$(dirname "$0")/common.sh"

sqlite3 "$DB_PATH" <<SQL
INSERT INTO scripts (name, run_date, status)
VALUES ('$SCRIPT_NAME', datetime('now'), '$STATUS')
ON CONFLICT(name) DO UPDATE SET run_date = datetime('now'), status = '$STATUS';
SQL

echo "✅ Execution record inserted for $SCRIPT_NAME with status: $STATUS"
