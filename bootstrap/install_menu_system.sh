#!/bin/bash
# Remote Access Platform bootstrap installer
# Installs prerequisites, creates directories, initialises SQLite DB

echo "===== Remote Access Platform Bootstrap Installer ====="

# Install prerequisites
echo "Installing required packages: whiptail, sqlite3, putty-tools, sshpass..."
apt update
apt install -y whiptail sqlite3 putty-tools sshpass

# Create directories
echo "Creating necessary directories..."
mkdir -p /opt/remoteaccess.nija
mkdir -p /var/log/remoteaccess.nija

# Run init_db.sh to initialise database schema
if [ -f scripts/modules/sqlite/init_db.sh ]; then
  echo "Initialising SQLite database schema..."
  bash scripts/modules/sqlite/init_db.sh
else
  echo "❌ ERROR: scripts/modules/sqlite/init_db.sh not found. Please check your repository structure."
  exit 1
fi

echo "✅ Bootstrap installation completed successfully."
