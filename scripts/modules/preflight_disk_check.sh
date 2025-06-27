#!/bin/bash
SCRIPT_NAME="preflight_disk_check.sh"
LOG_DIR="/var/log/remoteaccess.nija"
LOG_FILE="$LOG_DIR/preflight_disk_check.log"

mkdir -p $LOG_DIR

{
echo "===== Preflight Disk Check ====="
date

FAIL=0

# Function to check disk size in GB
check_disk_size() {
  MOUNT=$1
  REQUIRED=$2
  ACTUAL=$(df -BG --output=size "$MOUNT" | tail -n1 | tr -dc '0-9')
  if [ "$ACTUAL" -lt "$REQUIRED" ]; then
    echo "❌ Disk at $MOUNT only ${ACTUAL}GB, requires at least ${REQUIRED}GB."
    FAIL=1
  else
    echo "✅ Disk at $MOUNT is ${ACTUAL}GB (requirement: ${REQUIRED}GB)."
  fi
}

# Check OS root disk
check_disk_size "/" 12

# Check /opt/nomad disk
if mountpoint -q /opt/nomad; then
  check_disk_size "/opt/nomad" 20
else
  echo "❌ /opt/nomad not mounted."
  FAIL=1
fi

# Check /opt/databases disk
if mountpoint -q /opt/databases; then
  check_disk_size "/opt/databases" 50
else
  echo "❌ /opt/databases not mounted."
  FAIL=1
fi

# Check /opt/minio disk
if mountpoint -q /opt/minio; then
  check_disk_size "/opt/minio" 100
else
  echo "❌ /opt/minio not mounted."
  FAIL=1
fi

# Summary
if [ "$FAIL" -eq 0 ]; then
  echo "✅ All disk checks passed."
else
  echo "❌ Disk check failed. Please provision or mount missing disks before proceeding."
  exit 1
fi

# CPU and RAM checks here

# Summary
if [ "$FAIL" -eq 0 ]; then
  echo "✅ All disk and system resource checks passed."
else
  echo "❌ Preflight check failed. Please provision missing requirements before proceeding."
  exit 1
fi

} | tee -a $LOG_FILE

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"


} | tee -a $LOG_FILE

scripts/modules/sqlite/insert_exec.sh "$SCRIPT_NAME" "completed"
