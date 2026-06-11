# modules/vm/outputs.tf

output "vm_name" {
  description = "Nom de la VM créée"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip_address" {
  description = "IP de la VM (sans le masque /24)"
  value       = split("/", var.ip_address)[0]
}

output "vm_id" {
  description = "ID Proxmox de la VM"
  value       = proxmox_virtual_environment_vm.this.vm_id
}