# Deployment Modules

## Overview

Deployment modules install and configure the main platform components, including:

- Vault (as Nomad job)
- PostgreSQL
- MinIO
- Traefik
- Kasm Workspaces

Each module is fully automated, logs its execution, and records status in the compliance SQLite database.

## Usage

Run via `ninjamenu` or execute scripts directly as needed during build phases.
