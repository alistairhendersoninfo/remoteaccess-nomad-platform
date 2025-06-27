# Bootstrap Installation

## Overview

This bootstrap script prepares a fresh system for RemoteAccess.Ninja deployment. It installs all required base packages and sets up the menu system.

## Script

**Path:** `bootstrap_install.sh`

## Purpose

- Install prerequisites: whiptail, sqlite3, containerd
- Enable containerd for container runtime support
- Create working directories
- Copy menu system script to `/usr/local/bin/ninjamenu` for global access
- Run virgin install check

## Usage

From project root:

```bash
./bootstrap_install.sh
Outputs
Menu available via ninjamenu

Logs stored in /var/log/remoteaccess.nija/bootstrap_install.log

Execution recorded in SQLite scripts table

Next Steps
Run:ninjamenu
to begin using the menu-driven deployment system.
