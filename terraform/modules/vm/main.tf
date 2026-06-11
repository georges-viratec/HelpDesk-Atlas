terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.76.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {

  name      = var.vm_name
  node_name = var.pve_node
  vm_id     = var.vm_id

  clone {
    vm_id     = var.template_id
    full      = true
    retries   = 3
    node_name = var.pve_node
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.disk_datastore
    size         = var.disk_gb
    interface    = "scsi0"
    discard      = "on"
    file_format  = "raw"
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = var.vlan_id
  }

  initialization {
    datastore_id = var.disk_datastore
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
    user_account {
      keys     = var.ssh_public_key
      password = var.ci_password
    }
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  on_boot = true
}
