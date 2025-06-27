#!/bin/bash
SCRIPT_NAME="install_vault_binary.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/install_vault_binary.log"

mkdir -p $LOG_DIR

{
echo "===== Install Vault Binary ====="
date

VAULT_VERSION="1.15.2"

cd /opt
wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip vault_${VAULT_VERSION}_linux_amd64.zip
mv vault /usr/local/bin/
rm vault_${VAULT_VERSION}_linux_amd64.zip

vault --version
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
