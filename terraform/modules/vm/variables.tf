# ──────────────────────────────────────────────
# modules/vm/variables.tf
# Paramètres nécessaires pour créer une VM
# ──────────────────────────────────────────────


# ── Identité ───────────────────────────────────

variable "vm_name" {
  type        = string
  description = "Nom de la VM dans Proxmox (ex: vm-ldap)"
}

variable "vm_id" {
  type        = number
  description = "ID unique de la VM dans Proxmox (ex: 102)"
}

variable "pve_node" {
  type        = string
  description = "Nœud Proxmox cible (pve1 ou pve2)"
}


# ── Ressources ─────────────────────────────────

variable "cores" {
  type        = number
  description = "Nombre de vCPUs alloués"
  default     = 2
}

variable "memory_mb" {
  type        = number

  description = "RAM en mégaoctets (ex: 2048 = 2Go)"
  default     = 2048
}


# ── Stockage ───────────────────────────────────

variable "disk_gb" {
  type        = number
  description = "Taille du disque principal en Go"
  default     = 20
}

variable "disk_datastore" {
  type        = string
  description = "Datastore Proxmox pour le disque (local-lvm en dev, truenas-nfs en prod)"
  default     = "local-lvm"
}


# ── Réseau ─────────────────────────────────────

variable "vlan_id" {
  type        = number
  description = "VLAN ID (10=MGMT, 20=Core, 30=Apps, 40=BDD, 50=SAN)"
}

variable "ip_address" {
  type        = string
  description = "IP de la VM avec masque CIDR (ex: 10.10.20.38/24)"
}

variable "gateway" {
  type        = string
  description = "Passerelle du VLAN (ex: 10.10.20.254)"
}


# ── Accès ──────────────────────────────────────

variable "ssh_public_key" {
  type        = string
  description = "Clé SSH publique pour accéder à la VM"
}

variable "ci_password" {
  type        = string
  description = "Mot de passe cloud-init de la VM"
  sensitive   = true
}


# ── OS ─────────────────────────────────────────

variable "os_template" {
  type        = string
  description = "Nom du template cloud-init à utiliser"
  default     = "debian-13"
}