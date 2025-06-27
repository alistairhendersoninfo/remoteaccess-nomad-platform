# Preflight Checks

## Overview

The preflight disk and system resource check ensures your server meets minimum requirements before deploying core modules.

## Script

**Path:** `scripts/modules/preflight_disk_check.sh`

## Purpose

- Verify OS disk has minimum 12GB
- Verify additional disks for:
  - /opt/nomad (20GB)
  - /opt/databases (50GB)
  - /opt/minio (100GB)
- Check CPU cores (minimum 2)
- Check RAM (minimum 4GB)

## Usage

Run via ninjamenu or manually:

```bash
scripts/modules/preflight_disk_check.sh
tee books/docs/preflight/README.md <<'EOF'
# Preflight Checks

## Overview

The preflight disk and system resource check ensures your server meets minimum requirements before deploying core modules.

## Script

**Path:** `scripts/modules/preflight_disk_check.sh`

## Purpose

- Verify OS disk has minimum 12GB
- Verify additional disks for:
  - /opt/nomad (20GB)
  - /opt/databases (50GB)
  - /opt/minio (100GB)
- Check CPU cores (minimum 2)
- Check RAM (minimum 4GB)

## Usage

Run via ninjamenu or manually:

```bash
scripts/modules/preflight_disk_check.sh
Outputs
Displays check results for each requirement

Exits with error if any requirement is not met

Logs stored in /var/log/remoteaccess.nija/preflight_disk_check.log

Importance
Preflight validation ensures smooth deployment by verifying hardware readiness before installation of Nomad and critical services.
