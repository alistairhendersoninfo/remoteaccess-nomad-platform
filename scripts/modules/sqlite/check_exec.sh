#!/bin/bash
# Check if a script execution record exists in SQLite database

SCRIPT_NAME="$1"

if [ -z "$SCRIPT_NAME" ]; then
  echo "Usage: check_exec.sh <script_name>"
  exit 1
fi

source "$(dirname "$0")/common.sh"

RESULT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM scripts WHERE name = '$SCRIPT_NAME';")

if [ "$RESULT" -gt 0 ]; then
  echo "✅ $SCRIPT_NAME has been run before."
  exit 0
else
  echo "❌ $SCRIPT_NAME has not been run."
  exit 1
fi
