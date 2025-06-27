#!/bin/bash
SCRIPT_NAME="install_vault.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/install_vault.log"

mkdir -p $LOG_DIR

{
echo "===== Install Vault ====="
date

VAULT_VERSION="1.13.3"
cd /usr/local/bin

wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip vault_${VAULT_VERSION}_linux_amd64.zip
chmod +x vault
rm vault_${VAULT_VERSION}_linux_amd64.zip

vault --version
echo "Vault installed."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
