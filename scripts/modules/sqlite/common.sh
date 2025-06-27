#!/bin/bash
# Common functions and database path for Remote Access Platform

DB_PATH="/opt/remoteaccess.nija/remoteaccess.db"

# Ensure database exists
if [ ! -f "$DB_PATH" ]; then
  echo "❌ Database not found at $DB_PATH. Please run init_db.sh first."
  exit 1
fi
