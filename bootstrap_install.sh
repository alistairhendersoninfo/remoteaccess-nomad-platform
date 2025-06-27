#!/bin/bash
SCRIPT_NAME="bootstrap_install.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/bootstrap_install.log"

mkdir -p $LOG_DIR

{
echo "===== RemoteAccess.Ninja Bootstrap Install ====="
date

# Install prerequisites
apt update
apt install -y whiptail sqlite3 containerd

# Enable containerd
systemctl enable containerd
systemctl start containerd

# Create working directories
mkdir -p /opt/remoteaccess.nija

# Copy menu to PATH as ninjamenu
cp scripts/menu/menu_system.sh /usr/local/bin/ninjamenu
chmod +x /usr/local/bin/ninjamenu

echo "✅ ninjamenu installed to /usr/local/bin/ninjamenu."

# Run virgin check script
scripts/hardening/check_virgin_install.sh

echo "✅ Bootstrap installation completed. Run 'ninjamenu' to begin."

} | tee -a $LOG_FILE

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
