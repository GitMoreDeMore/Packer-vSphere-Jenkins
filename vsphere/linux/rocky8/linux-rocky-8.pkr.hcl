locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_description = "Built on: ${local.build_date}\n${local.build_by}"
  iso_paths         = ["[${var.vsphere_lin_datastore}] ISO/linux/Rocky-8.6-x86_64-dvd1.iso"]
}

source "vsphere-iso" "linux-rocky" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = true

  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_lin_cluster
  datastore  = var.vsphere_lin_datastore
  folder     = var.vsphere_folder

  vm_name              = "rocky8-template"
  guest_os_type        = "other4xLinux64Guest"
  firmware             = "efi"
  CPUs                 = 4
  cpu_cores            = 1
  CPU_hot_plug         = false
  RAM                  = 8192
  RAM_hot_plug         = false
  cdrom_type           = "sata"
  disk_controller_type = ["pvscsi"]

  dynamic "storage" {
    for_each = var.storage
    content {
      disk_size             = storage.value
      disk_controller_index = 0
      disk_thin_provisioned = true
    }
  }

  network_adapters {
    network      = var.vsphere_network
    network_card = "vmxnet3"
  }
  remove_cdrom = true
  notes        = local.build_description

  iso_paths = local.iso_paths
  cd_content = {
    "/ks.cfg" = templatefile("../../../scripts/ks-templates/rocky-ks.pkrtpl.hcl", {
      build_password = var.build_password
    })
  }

  boot_order = "disk,cdrom"
  boot_wait  = "3s"
  boot_command = [
    "<up>",
    "e",
    "<down><down><end><wait>",
    "text inst.ks=cdrom:/ks.cfg",
    "<enter><wait><leftCtrlOn>x<leftCtrlOff>"
  ]
  ip_wait_timeout = "600s"

  communicator = "ssh"
  ssh_username = "root"
  ssh_password = var.build_password

  convert_to_template = true
}

build {
  sources = ["source.vsphere-iso.linux-rocky"]

  provisioner "shell" {
    script       = "../../../scripts/linux/addsshkeys.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

}
