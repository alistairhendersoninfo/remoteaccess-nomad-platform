#!/bin/bash
SCRIPT_NAME="generate_vault_tls.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/generate_vault_tls.log"

mkdir -p $LOG_DIR

{
echo "===== Generate Vault Self-Signed TLS Cert ====="
date

mkdir -p /etc/vault/ssl

openssl req -x509 -nodes -newkey rsa:4096 \
  -keyout /etc/vault/ssl/vault.key \
  -out /etc/vault/ssl/vault.crt \
  -days 365 \
  -subj "/CN=localhost" \
  -extensions san \
  -config <(cat <<CONF
[req]
distinguished_name=req
req_extensions=san
x509_extensions=san
prompt=no

[dn]
CN=localhost

[san]
subjectAltName=IP:127.0.0.1,DNS:localhost
CONF
)
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
