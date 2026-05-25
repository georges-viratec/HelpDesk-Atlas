# HelpDesk-Atlas
## Infrastructure as Code pour le projet Helpdesk Atlas — Provisioning Terraform + Configuration Ansible sur cluster Proxmox

**Infra physique**
| Équipement            | IP            | Rôle                                                   |
|-----------------------|---------------|--------------------------------------------------------|
| Proxmox 1 (Orion)     | 10.10.0.250   | Hyperviseur principal, toutes les VMs pour l’instant  |
| Proxmox 2             | 10.10.0.252   | Hyperviseur secondaire (Corosync), vide pour l’instant |
| TrueNAS               | 10.10.10.50   | Stockage backup / NFS (physique, à configurer plus tard) |
| pfSense 1             | À définir     | Firewall HA CARP + pfsync                              |
| pfSense 2             | À définir     | Firewall HA CARP + pfsync                              |

# VMs — Plan d’adressage

| VMID | Nom             | Rôle                    | VLAN | IP           | CPU | RAM | Disque |
|------:|------------------|--------------------------|------|--------------|-----|-----|---------|
| 100  | vm-bastion       | Bastion / jump host      | 10   | 10.10.10.10 | 2   | 2G  | 20G     |
| 101  | vm-vault         | HashiCorp Vault          | 10   | 10.10.10.11 | 2   | 2G  | 20G     |
| 110  | k3s-master-1     | K3s control plane        | 20   | 10.10.20.10 | 2   | 4G  | 30G     |
| 111  | k3s-master-2     | K3s control plane        | 20   | 10.10.20.11 | 2   | 4G  | 30G     |
| 120  | k3s-worker-1     | K3s worker               | 20   | 10.10.20.12 | 2   | 4G  | 40G     |
| 121  | k3s-worker-2     | K3s worker               | 20   | 10.10.20.13 | 2   | 4G  | 40G     |
| 130  | vm-db-1          | MariaDB Galera           | 20   | 10.10.20.20 | 2   | 2G  | 30G     |
| 131  | vm-db-2          | MariaDB Galera           | 20   | 10.10.20.21 | 2   | 2G  | 30G     |
| 132  | vm-db-3          | MariaDB Galera           | 20   | 10.10.20.22 | 2   | 2G  | 30G     |
| 140  | vm-monitoring    | Zabbix + Prometheus      | 30   | 10.10.30.10 | 2   | 4G  | 30G     |
| 150  | vm-proxy         | Reverse proxy            | 40   | 10.10.40.10 | 2   | 2G  | 10G     |

---

# VLANs

| VLAN | Rôle                     | Subnet          | Gateway                     |
|-----:|---------------------------|-----------------|-----------------------------|
| 10   | MGMT                      | 10.10.10.0/24   | 10.10.10.1 (pfSense VIP)   |
| 20   | DATA (K3s + Galera)       | 10.10.20.0/24   | 10.10.20.1 (pfSense VIP)   |
| 30   | Monitoring                | 10.10.30.0/24   | 10.10.30.1 (pfSense VIP)   |
| 40   | DMZ / Proxy               | 10.10.40.0/24   | 10.10.40.1 (pfSense VIP)   |

---

# VIP Kubernetes

| VIP           | Usage                  |
|----------------|------------------------|
| 10.10.20.100 | kube-vip (API K3s)     |