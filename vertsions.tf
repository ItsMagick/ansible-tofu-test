terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.86.0"
    }
  }

  required_version = ">= 1.10.6"
}

provider "proxmox" {
  endpoint  = "https://localhost:1337"
  username  = "root@pam"
  password  = "Test1234!"
  insecure  = true
}
