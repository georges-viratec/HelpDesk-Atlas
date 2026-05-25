variable "pve_endpoint" {
    description = "The Proxmox VE API endpoint URL."
    type        = string
    default     = "https://100.100.137.13:8006/"
}

variable "pve_api_token" {
    description = "The Proxmox VE API token."
    type        = string
    sensitive   = true
}

variable "ssh_public_keys" {
    description = "The SSH public keys to be added to the virtual machine."
    type        = list(string)
}

variable "ci_password" {
    description = "The password for the virtual machine."
    type        = string
    sensitive   = true
}