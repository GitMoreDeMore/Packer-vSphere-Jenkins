locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_description = "Built on: ${local.build_date}\n${local.build_by}"
  iso_paths         = ["[${var.vsphere_win_datastore}] ISO/windows/SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-2_MLF_X21-22843.ISO", "[] /vmimages/tools-isoimages/windows.iso"]
}

source "vsphere-iso" "windows-server-standard-desktop" {
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_user
  password            = var.vsphere_password
  insecure_connection = true

  datacenter = var.vsphere_datacenter
  cluster    = var.vsphere_win_cluster
  datastore  = var.vsphere_win_datastore
  folder     = var.vsphere_folder

  vm_name              = "windows2016-template-2"
  guest_os_type        = "windows9Server64Guest"
  firmware             = "efi-secure"
  CPUs                 = 4
  cpu_cores            = 1
  CPU_hot_plug         = false
  RAM                  = 8192
  RAM_hot_plug         = false
  cdrom_type           = "sata"
  disk_controller_type = ["pvscsi"]
  storage {
    disk_size             = 102400
    disk_controller_index = 0
    disk_thin_provisioned = true
  }
  network_adapters {
    network      = var.vsphere_network
    network_card = "vmxnet3"
  }
  remove_cdrom = true
  notes        = local.build_description

  iso_paths = local.iso_paths
  cd_files  = ["../../../scripts/windows/*"]
  cd_content = {
    "autounattend.xml" = templatefile("../../../scripts/unattend-templates/win2016-autounattend.pkrtpl.hcl", {
      build_username     = "administrator"
      build_password     = var.build_password
      vm_inst_os_image   = "Windows Server 2016 SERVERSTANDARD"
      vm_inst_os_kms_key = "WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
    })
  }

  boot_order       = "disk,cdrom"
  boot_wait        = "2s"
  boot_command     = ["<spacebar>"]
  ip_wait_timeout  = "600s"
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Shutdown by Packer\""
  shutdown_timeout = "12000s"

  communicator   = "winrm"
  winrm_username = "administrator"
  winrm_password = var.build_password

  convert_to_template = true
}

build {
  sources = ["source.vsphere-iso.windows-server-standard-desktop"]
  provisioner "powershell" {
    environment_vars = [
      "BUILD_USERNAME=administrator"
    ]
    elevated_user     = "administrator"
    elevated_password = var.build_password
    scripts           = var.scripts
  }

  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'",
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Defender*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }
}