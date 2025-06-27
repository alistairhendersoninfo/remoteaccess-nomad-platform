# RemoteAccess Nomad Platform

## Overview

This project provides a fully self-hosted, hardened deployment framework for Remote Access, Reporting, DNS, and supporting infrastructure using Nomad for orchestration.

---

## 🔧 **Tools Used**

| Tool | URL | Purpose |
|------|-----|---------|
| **Nomad** | https://www.nomadproject.io | Orchestration and scheduling of containerized and non-containerized workloads. |
| **Kasm Workspaces** | https://www.kasmweb.com | Browser-based remote desktop and application streaming platform for secure workspaces. |
| **PostgreSQL** | https://www.postgresql.org | Primary relational database for platform services. |
| **MinIO** | https://min.io | Self-hosted S3-compatible object storage for file, log, and backup storage. |
| **Traefik** | https://traefik.io | Reverse proxy and dynamic load balancer for routing and TLS termination. |
| **Vault** | https://www.vaultproject.io | Secrets management, encryption, and identity-based access control. |
| **Let's Encrypt** | https://letsencrypt.org | Automated free TLS certificate provisioning. |
| **Linux (Ubuntu/RHEL)** | https://ubuntu.com / https://www.redhat.com | Operating system for all nodes. |
| **Bash** | https://www.gnu.org/software/bash/ | Automation scripting language for deployment tasks. |
| **Python** | https://www.python.org | Supporting scripts and utilities. |
| **ZooKeeper** | https://zookeeper.apache.org | Distributed coordination service where needed for clustered apps. |
| **ClickHouse** | https://clickhouse.com | Columnar database for fast analytics and reporting workloads. |
| **Trino** | https://trino.io | Distributed SQL query engine for data federation. |
| **Loki** | https://grafana.com/oss/loki/ | Log aggregation system for Grafana integration. |
| **Promtail** | https://grafana.com/docs/loki/latest/clients/promtail/ | Log shipping agent for Loki. |
| **Grafana** | https://grafana.com | Metrics and log visualization and alerting platform. |
| **SELinux** | https://selinuxproject.org | Mandatory access controls for system security. |
| **Fail2ban** | https://www.fail2ban.org | Intrusion prevention by banning suspicious IPs. |
| **rsyslog** | https://www.rsyslog.com | System log aggregation and forwarding. |
| **Pangolin** | [No official URL, internal project] | Secure gateway solution for remote access. |

---

## 📖 **Documentation**

- **GitHub Pages** served from `pages/`
- **GitBook** content in `books/`

---

## 🚀 **Quickstart**

```bash
# Clone the repo
git clone <repo-url>
cd remoteaccess-nomad-platform

# Run master menu
sudo ./scripts/master_menu.sh
```

