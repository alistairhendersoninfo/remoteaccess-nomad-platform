#!/bin/bash
SCRIPT_NAME="configure_vault_approle.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/configure_vault_approle.log"

mkdir -p $LOG_DIR

{
echo "===== Configure Vault AppRole ====="
date

export VAULT_ADDR="https://127.0.0.1:8200"
export VAULT_SKIP_VERIFY=true
export VAULT_TOKEN=$(grep 'Initial Root Token' /root/vault.init | awk '{print $NF}')

vault auth enable approle

vault policy write automation-policy - <<POLICY
path "secret/data/certbot" {
  capabilities = ["read"]
}
POLICY

vault write auth/approle/role/certbot-role \
  secret_id_ttl=0 \
  token_ttl=3600 \
  token_max_ttl=86400 \
  token_num_uses=0 \
  policies="automation-policy"

vault read -field=role_id auth/approle/role/certbot-role/role-id > /root/certbot-role-id
vault write -field=secret_id -f auth/approle/role/certbot-role/secret-id > /root/certbot-secret-id
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
