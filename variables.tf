# =====================================
# Proxmox Virtual Environment variables
# =====================================
variable "pve_host" {
  description = "Host IP address for the PVE server"
  type        = string
}

variable "pve_port" {
  description = "Listening port for the PVE server"
  type        = number
  default     = 8006
}

variable "pve_user" {
  description = "Username that configures PVE server"
  type        = string
  default     = "root@pam"
}

variable "pve_password" {
  description = "Password for the username that configures PVE server"
  type        = string
  sensitive   = true
}

variable "pve_target_node" {
  description = "PVE node name"
  type        = string
}

# ========================
# Common Network variables
# ========================
variable "pve_network_name" {
  description = "Name of the network assigned to hosts"
  type        = string
  default     = "eth0"
}

variable "pve_network_bridge" {
  description = "Name of the network bridge"
  type        = string
  default     = "vmbr0"
}

variable "pve_network_gateway" {
  description = "IP address of the LAN gateway"
  type        = string
}

variable "pve_network_firewall" {
  description = "Whether to enable network firewall"
  type        = bool
  default     = true
}

variable "pve_dns_servers" {
  description = "Address of the DNS servers"
  type        = string
  default     = "114.114.114.114"
}

# ========================
# Common Storage variables
# ========================
variable "pve_template_storage" {
  description = "Storage device for QCOW2 OS templates"
  type        = string
  default     = "local"
}

variable "pve_data_storage" {
  description = "Storage device for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "pve_ubuntu_template_name" {
  description = "Template file name for Ubuntu OS"
  type        = string
  default     = "ubuntu-18.04-standard_18.04.1-1_amd64.tar.gz"
}

# =======================
# Common access variables
# =======================
variable "ssh_public_key_file" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_file" {
  description = "Path to the SSH privatekey file"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# =========================
# Virtual machine variables
# =========================
variable "lxc" {
  type = map(object({
    id     = number
    name   = string
    cores  = number
    memory = number
    swap   = number
    disk   = number
    ip     = string
    hwaddr = string
  }))
  default = {}
}

variable "qemu" {
  type = map(object({
    id     = number
    name   = string
    clone  = string
    cores  = number
    memory = number
    disk   = string
    ip     = string
  }))
  default = {}
}
