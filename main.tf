terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.6.7"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://${var.pve_host}:${var.pve_port}/api2/json"
  pm_user         = var.pve_user
  pm_password     = var.pve_password
}

resource "proxmox_lxc" "lxc" {
  for_each = var.lxc

  lifecycle {
    ignore_changes = [
      network,
      ostype,
      ostemplate,
      ssh_public_keys,
      rootfs,
      start,
      storage,
    ]
  }

  vmid     = each.value.id
  hostname = each.value.name
  cores    = each.value.cores
  memory   = each.value.memory
  swap     = each.value.swap
  network {
    name     = var.pve_network_name
    bridge   = var.pve_network_bridge
    firewall = var.pve_network_firewall
    gw       = var.pve_network_gateway
    ip       = "${each.value.ip}/24"
    hwaddr   = each.value.hwaddr
  }
  nameserver      = var.pve_dns_servers
  ostemplate      = "${var.pve_template_storage}:vztmpl/${var.pve_ubuntu_template_name}"
  ssh_public_keys = file(var.ssh_public_key_file)
  storage         = var.pve_data_storage
  rootfs          = "${var.pve_data_storage}:${each.value.disk}"
  target_node     = var.pve_target_node
  unprivileged    = true
  onboot          = true
  start           = true

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y python3"
    ]
    connection {
      type        = "ssh"
      host        = each.value.ip
      user        = "root"
      private_key = file(var.ssh_private_key_file)
    }
  }
}

resource "proxmox_vm_qemu" "qemu" {
  for_each = var.qemu

  lifecycle {
    ignore_changes = [
      network,
      bootdisk,
      nameserver,
      scsihw,
    ]
  }

  vmid        = each.value.id
  name        = each.value.name
  target_node = var.pve_target_node
  clone       = each.value.clone
  cores       = each.value.cores
  memory      = each.value.memory
  disk {
    id           = 0
    type         = "scsi"
    storage      = "local-lvm"
    storage_type = "lvm"
    size         = each.value.disk
  }
  network {
    id     = 0
    model  = "e1000"
    bridge = "vmbr0"
  }
  ssh_user  = "root"
  os_type   = "cloud-init"
  ciuser    = "root"
  ipconfig0 = "ip=${each.value.ip}/24,gw=${var.pve_network_gateway}"
  sshkeys   = file(var.ssh_public_key_file)

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y python3"
    ]
    connection {
      type        = "ssh"
      host        = each.value.ip
      user        = "root"
      private_key = file(var.ssh_private_key_file)
    }
  }
}
