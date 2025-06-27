#!/bin/bash
SCRIPT_NAME="auto_unseal.sh"

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/auto_unseal.log"
VAULT_KEYS_ENC="/opt/remoteaccess.nija/vault_unseal_keys.json.gpg"
GPG_PASS="SuperSecureLocalPassphrase"

mkdir -p $LOG_DIR

{
echo "===== Auto Unseal Vault ====="
date

export VAULT_ADDR="http://127.0.0.1:8200"

# Decrypt keys
echo $GPG_PASS | gpg --batch --yes --passphrase-fd 0 -o /tmp/vault_unseal.json -d $VAULT_KEYS_ENC

for KEY in $(jq -r '.unseal_keys_b64[]' /tmp/vault_unseal.json); do
  vault operator unseal $KEY
done

rm /tmp/vault_unseal.json
echo "Vault unsealed."
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
