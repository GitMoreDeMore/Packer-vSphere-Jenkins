packer {
  required_version = ">= 1.8.3"
  required_plugins {
    vsphere = {
      version = ">= v1.0.8"
      source  = "github.com/hashicorp/vsphere"
    }
  }
  required_plugins {
    windows-update = {
      version = ">= 0.14.1"
      source  = "github.com/rgl/windows-update"
    }
  }
}