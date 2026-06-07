# ──────────────────────────────────────────────
# environments/dev/main.tf
#
# Identique à prod SAUF :
# → tout sur pve1 (ton Proxmox solo)
# → disk_datastore = "local-lvm" (pas TrueNAS)
# ──────────────────────────────────────────────

# ── CLUSTER K3S ────────────────────────────────

module "k3s_master" {
  source         = "../../modules/vm"
  vm_name        = "vm-k3s-master"
  pve_node       = "pve1"
  vm_id          = 100
  memory_mb      = 4096
  disk_gb        = 30
  disk_datastore = "local-lvm"
  vlan_id        = 30
  ip_address     = "10.10.30.10/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "k3s_worker" {
  source         = "../../modules/vm"
  vm_name        = "vm-k3s-worker"
  pve_node       = "pve1"          # pve1 en dev
  vm_id          = 101
  memory_mb      = 4096
  disk_gb        = 30
  disk_datastore = "local-lvm"
  vlan_id        = 30
  ip_address     = "10.10.30.11/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

# ── SERVICES CORE ──────────────────────────────

module "ldap" {
  source         = "../../modules/vm"
  vm_name        = "vm-ldap"
  pve_node       = "pve1"
  vm_id          = 102
  memory_mb      = 2048
  disk_gb        = 20
  disk_datastore = "local-lvm"
  vlan_id        = 20
  ip_address     = "10.10.20.38/24"
  gateway        = "10.10.20.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "dns" {
  source         = "../../modules/vm"
  vm_name        = "vm-dns"
  pve_node       = "pve1"
  vm_id          = 103
  memory_mb      = 1024
  disk_gb        = 10
  disk_datastore = "local-lvm"
  vlan_id        = 20
  ip_address     = "10.10.20.53/24"
  gateway        = "10.10.20.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

# ── GALERA CLUSTER ─────────────────────────────

module "galera_1" {
  source         = "../../modules/vm"
  vm_name        = "vm-galera-1"
  pve_node       = "pve1"
  vm_id          = 104
  memory_mb      = 4096
  disk_gb        = 50
  disk_datastore = "local-lvm"
  vlan_id        = 40
  ip_address     = "10.10.40.11/24"
  gateway        = "10.10.40.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "galera_2" {
  source         = "../../modules/vm"
  vm_name        = "vm-galera-2"
  pve_node       = "pve1"          # pve1 en dev
  vm_id          = 105
  memory_mb      = 4096
  disk_gb        = 50
  disk_datastore = "local-lvm"
  vlan_id        = 40
  ip_address     = "10.10.40.12/24"
  gateway        = "10.10.40.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "galera_3" {
  source         = "../../modules/vm"
  vm_name        = "vm-galera-3"
  pve_node       = "pve1"
  vm_id          = 106
  memory_mb      = 1024
  disk_gb        = 10
  disk_datastore = "local-lvm"
  vlan_id        = 40
  ip_address     = "10.10.40.13/24"
  gateway        = "10.10.40.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

# ── SERVICES OPS ───────────────────────────────

module "postfix" {
  source         = "../../modules/vm"
  vm_name        = "vm-postfix"
  pve_node       = "pve1"          # pve1 en dev
  vm_id          = 107
  memory_mb      = 1024
  disk_gb        = 10
  disk_datastore = "local-lvm"
  vlan_id        = 30
  ip_address     = "10.10.30.20/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "bastion" {
  source         = "../../modules/vm"
  vm_name        = "vm-bastion"
  pve_node       = "pve1"          # pve1 en dev
  vm_id          = 108
  memory_mb      = 4096
  disk_gb        = 40
  disk_datastore = "local-lvm"
  vlan_id        = 10
  ip_address     = "10.10.10.100/24"
  gateway        = "10.10.10.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "vault" {
  source         = "../../modules/vm"
  vm_name        = "vm-vault"
  pve_node       = "pve1"          # pve1 en dev
  vm_id          = 109
  memory_mb      = 2048
  disk_gb        = 20
  disk_datastore = "local-lvm"
  vlan_id        = 10
  ip_address     = "10.10.10.101/24"
  gateway        = "10.10.10.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}

module "pbs" {
  source         = "../../modules/vm"
  vm_name        = "vm-pbs"
  pve_node       = "pve1"          # pve1 en dev
  vm_id          = 110
  memory_mb      = 4096
  disk_gb        = 32
  disk_datastore = "local-lvm"
  vlan_id        = 10
  ip_address     = "10.10.10.102/24"
  gateway        = "10.10.10.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
}