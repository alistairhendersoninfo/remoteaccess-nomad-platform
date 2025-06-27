#!/bin/bash
SCRIPT_NAME="init_vault.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/init_vault.log"
VAULT_KEYS="/opt/remoteaccess.nija/vault_unseal_keys.json"
VAULT_KEYS_ENC="/opt/remoteaccess.nija/vault_unseal_keys.json.gpg"
GPG_PASS="SuperSecureLocalPassphrase"

mkdir -p $LOG_DIR

{
echo "===== Initialize Vault ====="
date

# Start Vault in dev mode to initialize
vault server -dev -dev-root-token-id="root" > /tmp/vault.log 2>&1 &
sleep 5

export VAULT_ADDR="http://127.0.0.1:8200"

# Initialize if not already initialized
if vault status | grep -q "Initialized.*false"; then
  vault operator init -format=json > $VAULT_KEYS
  echo "Vault initialized and keys saved to $VAULT_KEYS"

  # Encrypt unseal keys
  echo $GPG_PASS | gpg --batch --yes --passphrase-fd 0 -c $VAULT_KEYS
  rm $VAULT_KEYS
  echo "Unseal keys encrypted to $VAULT_KEYS_ENC"
else
  echo "Vault already initialized."
fi

pkill vault
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
