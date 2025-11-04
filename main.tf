resource "proxmox_virtual_environment_download_file" "ubuntu_2504_lxc_img" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = "blade3"
  url          = "http://download.proxmox.com/images/system/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
}

resource "proxmox_virtual_environment_container" "ubuntu_container" {
  description = "Managed by Terraform"
  node_name = "blade3"
  vm_id     = 202
  started   = true

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
    swap = 512
  }

  # newer linux distributions require unprivileged user namespaces
  unprivileged = true
  features {
    nesting = true
  }

  initialization {
    hostname = "ubuntu-container"

    ip_config {
      ipv4 {
        address = "10.14.3.202/16"
        gateway = "10.14.0.1"
      }
    }

    dns {
      servers = [
        "10.14.0.1"
      ]
    }

    user_account {
      password = "12345678"
    }
  }

  network_interface {
    name = "eth0"
    vlan_id = 14
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.ubuntu_2504_lxc_img.id
    type             = "ubuntu"
  }
}
