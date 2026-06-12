# ── CLUSTER K3S ────────────────────────────────

module "k3s_master" {
  source         = "../../modules/vm"
  vm_name        = "vm-k3s-master"
  pve_node       = "pve1"
  vm_id          = 100
  memory_mb      = 4096
  disk_gb        = 30
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 30
  ip_address     = "10.10.30.10/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8000
}

module "k3s_worker" {
  source         = "../../modules/vm"
  vm_name        = "vm-k3s-worker"
  pve_node       = "pve1"
  vm_id          = 101
  memory_mb      = 4096
  disk_gb        = 30
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 30
  ip_address     = "10.10.30.12/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8000
}

# ── K3S MASTER 2 ───────────────────────────────
module "k3s_master_2" {
  source         = "../../modules/vm"
  vm_name        = "vm-k3s-master-2"
  pve_node       = "pve2"
  vm_id          = 111
  memory_mb      = 4096
  disk_gb        = 30
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 30
  ip_address     = "10.10.30.11/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8001
}

# ── K3S WORKER 2 ───────────────────────────────
module "k3s_worker_2" {
  source         = "../../modules/vm"
  vm_name        = "vm-k3s-worker-2"
  pve_node       = "pve2"
  vm_id          = 112
  memory_mb      = 4096
  disk_gb        = 30
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 30
  ip_address     = "10.10.30.13/24"
  gateway        = "10.10.30.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8001
}

# ── GALERA CLUSTER ─────────────────────────────

module "galera_1" {
  source         = "../../modules/vm"
  vm_name        = "vm-galera-1"
  pve_node       = "pve1"
  vm_id          = 104
  memory_mb      = 4096
  disk_gb        = 50
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 40
  ip_address     = "10.10.40.11/24"
  gateway        = "10.10.40.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8000
}

module "galera_2" {
  source         = "../../modules/vm"
  vm_name        = "vm-galera-2"
  pve_node       = "pve2"
  vm_id          = 105
  memory_mb      = 4096
  disk_gb        = 50
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 40
  ip_address     = "10.10.40.12/24"
  gateway        = "10.10.40.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8001
}

module "galera_3" {
  source         = "../../modules/vm"
  vm_name        = "vm-galera-3"
  pve_node       = "pve1"
  vm_id          = 106
  memory_mb      = 1024
  disk_gb        = 10
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 40
  ip_address     = "10.10.40.13/24"
  gateway        = "10.10.40.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8000
}

# ── VAULT ──────────────────────────────────────

module "vault" {
  source         = "../../modules/vm"
  vm_name        = "vm-vault"
  pve_node       = "pve2"
  vm_id          = 109
  memory_mb      = 2048
  disk_gb        = 20
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 10
  ip_address     = "10.10.10.101/24"
  gateway        = "10.10.10.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8001
}

# ── PROXMOX BACKUP SERVER ──────────────────────

module "pbs" {
  source         = "../../modules/vm"
  vm_name        = "vm-pbs"
  pve_node       = "pve2"
  vm_id          = 110
  memory_mb      = 4096
  disk_gb        = 32
  disk_datastore = "truenas-vm-storage"
  vlan_id        = 10
  ip_address     = "10.10.10.102/24"
  gateway        = "10.10.10.254"
  ssh_public_key = var.ssh_public_keys
  ci_password    = var.ci_password
  template_id    = 8001
}
