#!/bin/bash
SCRIPT_NAME="setup_vault_systemd.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/setup_vault_systemd.log"

mkdir -p $LOG_DIR

{
echo "===== Setup Vault Systemd Service ====="
date

tee /etc/systemd/system/vault.service > /dev/null <<SERVICE
[Unit]
Description=HashiCorp Vault - A tool for managing secrets
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target

[Service]
User=root
Group=root
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
Restart=on-failure
LimitNOFILE=65536
AmbientCapabilities=CAP_IPC_LOCK
SecureBits=keep-caps
CapabilityBoundingSet=CAP_IPC_LOCK
ProtectSystem=full
ProtectHome=read-only

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable vault
systemctl start vault
systemctl status vault
} >> $LOG_FILE 2>&1

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
