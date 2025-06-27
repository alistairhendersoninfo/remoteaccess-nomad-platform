#!/bin/bash
SCRIPT_NAME="init_and_unseal_vault.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/init_and_unseal_vault.log"

mkdir -p $LOG_DIR

{
echo "===== Initialize and Unseal Vault ====="
date

export VAULT_ADDR="https://127.0.0.1:8200"
export VAULT_SKIP_VERIFY=true

vault operator init -key-shares=1 -key-threshold=1 > /root/vault.init
UNSEAL_KEY=$(grep 'Unseal Key 1' /root/vault.init | awk '{print $NF}')
vault operator unseal $UNSEAL_KEY

export VAULT_TOKEN=$(grep 'Initial Root Token' /root/vault.init | awk '{print $NF}')
vault status
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
