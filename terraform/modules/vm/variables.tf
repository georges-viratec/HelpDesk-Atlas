variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "pve_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "vm_id" {
  description = "VM ID"
  type        = number
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Memory in MB"
  type        = number
}

variable "disk_gb" {
  description = "Disk size in GB"
  type        = number
}

variable "disk_datastore" {
  description = "Datastore for the disk"
  type        = string
}

variable "vlan_id" {
  description = "VLAN ID"
  type        = number
}

variable "ip_address" {
  description = "IP address with prefix (e.g. 10.10.30.10/24)"
  type        = string
}

variable "gateway" {
  description = "Gateway IP"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public keys"
  type        = list(string)
}

variable "ci_password" {
  description = "Cloud-init password"
  type        = string
  sensitive   = true
}

variable "template_id" {
  description = "Template VM ID to clone"
  type        = number
}
