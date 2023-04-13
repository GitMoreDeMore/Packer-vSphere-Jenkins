packer {
  required_version = ">= 1.8.3"
  required_plugins {
    vsphere = {
      version = ">= v1.0.8"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}