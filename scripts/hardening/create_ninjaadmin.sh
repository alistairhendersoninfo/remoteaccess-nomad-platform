#!/bin/bash
SCRIPT_NAME="create_ninjaadmin.sh"

if [ ! -f /opt/remoteaccess.nija/virgin_check_passed ]; then
  echo "Virgin install check not passed. Exiting."
  exit 1
fi

LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/create_ninjaadmin.log"

mkdir -p $LOG_DIR

{
echo "===== Root Login Verification ====="
date

# Check if root user exists
if id "root" &>/dev/null; then
  echo "✅ Root user exists."
else
  echo "❌ Root user does not exist. Critical system error."
  exit 1
fi

# Ensure root has a password set
if [ -z "$(sudo grep root /etc/shadow | cut -d: -f2)" ] || sudo grep root /etc/shadow | grep -q '!*'; then
  echo "⚠️ Root has no valid password. Setting temporary password 'TempRootPass123!'. Please change immediately."
  echo "root:TempRootPass123!" | chpasswd
else
  echo "✅ Root password is set."
fi

# Prompt user to test root console login manually
while true; do
  echo -e "\n🚨 ROOT CONSOLE LOGIN VERIFICATION 🚨"
  echo "Please open a separate console or VM window and confirm you can login as 'root'."
  echo "Type 'yes' once confirmed, or 'no' to abort."

  read -p "Have you confirmed root console login works? (yes/no): " CONFIRM
  case "$CONFIRM" in
    yes) break ;;
    no)
      echo "❌ Aborting script to avoid potential lockout."
      exit 1
      ;;
    *)
      echo "Invalid input. Type 'yes' or 'no'."
      ;;
  esac
done

echo "✅ Root console login verified."

# Proceed to create ninjaadmin user
echo "===== Create ninjaadmin User ====="
date

# Create ninjaadmin user if not exists
if id "ninjaadmin" &>/dev/null; then
  echo "User ninjaadmin already exists."
else
  useradd -m -s /bin/bash ninjaadmin
  mkdir -p /home/ninjaadmin/.ssh
  chmod 700 /home/ninjaadmin/.ssh
  echo "✅ Created ninjaadmin user and .ssh directory."

  scripts/modules/security/set_ninjaadmin_banner.sh
  scripts/modules/security/set_root_banner_with_ninja_prompt.sh
  echo "✅ Created ninjaadmin and root banners"

fi

# Generate SSH key pair if not present
if [ ! -f /home/ninjaadmin/.ssh/authorized_keys ]; then
  ssh-keygen -t rsa -b 4096 -f /home/ninjaadmin/.ssh/id_rsa -N ""
  cat /home/ninjaadmin/.ssh/id_rsa.pub > /home/ninjaadmin/.ssh/authorized_keys
  chmod 600 /home/ninjaadmin/.ssh/authorized_keys
  chown -R ninjaadmin:ninjaadmin /home/ninjaadmin/.ssh
  echo "✅ Generated SSH key pair for ninjaadmin."

  # Display private key for user to save
  echo "🚨 SAVE THIS PRIVATE KEY SECURELY FOR ninjaadmin LOGIN 🚨"
  cat /home/ninjaadmin/.ssh/id_rsa
else
  echo "✅ SSH key already exists for ninjaadmin."
fi

# Banner message
echo -e "\n\n🚨 SSH KEY LOGIN REQUIRED 🚨"
echo "You must log out now and log back in as 'ninjaadmin' using your SSH key to continue installation."
echo "This session will log out in 10 seconds."
sleep 10

# Log out current session
pkill -KILL -u $(whoami)

} | tee -a $LOG_FILE

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
