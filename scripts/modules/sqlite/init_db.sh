#!/bin/bash
# Initialise SQLite database for Remote Access Platform

DB_PATH="/opt/remoteaccess.nija/remoteaccess.db"

mkdir -p /opt/remoteaccess.nija

# Create database and tables if not exist
sqlite3 $DB_PATH <<SQL
CREATE TABLE IF NOT EXISTS scripts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    run_date TEXT,
    status TEXT
);

CREATE TABLE IF NOT EXISTS system_state (
    key TEXT PRIMARY KEY,
    value TEXT
);
SQL

echo "✅ SQLite database initialised at $DB_PATH"
