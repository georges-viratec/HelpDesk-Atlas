# environments/prod/template.tf

# Image Debian 13 téléchargée sur PVE1
resource "proxmox_virtual_environment_download_file" "debian_13" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pve1"
  url          = "https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-genericcloud-amd64-daily.qcow2"
  file_name    = "debian-13-cloud.qcow2"
}

# Template stocké sur TrueNAS → accessible PVE1 + PVE2
resource "proxmox_virtual_environment_vm" "debian_template" {
  name      = "debian-13-cloud"
  node_name = "pve1"
  vm_id     = 9000
  template  = true

  cpu    { cores = 2; type = "host" }
  memory { dedicated = 2048 }

  disk {
    datastore_id = "truenas-vms"    # ← sur TrueNAS
    file_id      = proxmox_virtual_environment_download_file.debian_13.id
    interface    = "scsi0"
    size         = 8
  }

  network_device { bridge = "vmbr0" }

  initialization {
    ip_config { ipv4 { address = "dhcp" } }
  }

  agent { enabled = true }

  depends_on = [
    proxmox_virtual_environment_storage.truenas_vms
  ]
}