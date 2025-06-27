#!/bin/bash
SCRIPT_NAME="configure_vault.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/configure_vault.log"

mkdir -p $LOG_DIR

{
echo "===== Configure Vault ====="
date

mkdir -p /etc/vault.d /opt/vault/data

tee /etc/vault.d/vault.hcl > /dev/null <<CONF
ui = true
disable_mlock = true

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/ssl/vault.crt"
  tls_key_file  = "/etc/vault/ssl/vault.key"
}

storage "file" {
  path = "/opt/vault/data"
}

api_addr = "https://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"

log_level = "info"
CONF
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
