
variable "box_basename" {
  type    = string
  default = "ubuntu-21.10"
}

variable "build_directory" {
  type    = string
  default = "../../builds"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "65536"
}

variable "git_revision" {
  type    = string
  default = "__unknown_git_revision__"
}

variable "guest_additions_url" {
  type    = string
  default = ""
}

variable "headless" {
  type    = string
  default = ""
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "hyperv_generation" {
  type    = string
  default = "2"
}

variable "hyperv_switch" {
  type    = string
  default = "bento"
}

variable "iso_checksum" {
  type    = string
  default = "e84f546dfc6743f24e8b1e15db9cc2d2c698ec57d9adfb852971772d1ce692d4"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-21.10-live-server-amd64.iso"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "mirror" {
  type    = string
  default = "http://releases.ubuntu.com"
}

variable "mirror_directory" {
  type    = string
  default = "impish"
}

variable "name" {
  type    = string
  default = "ubuntu-21.10"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

variable "preseed_path" {
  type    = string
  default = "preseed.cfg"
}

variable "qemu_display" {
  type    = string
  default = "none"
}

variable "template" {
  type    = string
  default = "ubuntu-21.10-amd64"
}

variable "version" {
  type    = string
  default = "TIMESTAMP"
}
# The "legacy_isotime" function has been provided for backwards compatability, but we recommend switching to the timestamp and formatdate functions.

locals {
  build_timestamp = "${legacy_isotime("20060102150405")}"
  http_directory  = "${path.root}/http"
}

source "hyperv-iso" "autogenerated_1" {
  boot_command       = [" <wait>", " <wait>", " <wait>", " <wait>", " <wait>", "c", "<wait>", "set gfxpayload=keep", "<enter><wait>", "linux /casper/vmlinuz quiet<wait>", " autoinstall<wait>", " ds=nocloud-net<wait>", "\\;s=http://<wait>", "{{ .HTTPIP }}<wait>", ":{{ .HTTPPort }}/<wait>", " ---", "<enter><wait>", "initrd /casper/initrd<wait>", "<enter><wait>", "boot<enter><wait>"]
  boot_wait          = "5s"
  communicator       = "ssh"
  cpus               = "${var.cpus}"
  disk_size          = "${var.disk_size}"
  enable_secure_boot = false
  generation         = "${var.hyperv_generation}"
  http_directory     = "${local.http_directory}"
  iso_checksum       = "${var.iso_checksum}"
  iso_url            = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  memory             = "${var.memory}"
  output_directory   = "${var.build_directory}/packer-${var.template}-hyperv"
  shutdown_command   = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password       = "vagrant"
  ssh_port           = 22
  ssh_timeout        = "10000s"
  ssh_username       = "vagrant"
  switch_name        = "${var.hyperv_switch}"
  vm_name            = "${var.template}"
}

source "parallels-iso" "autogenerated_2" {
  boot_command           = [" <wait>", " <wait>", " <wait>", " <wait>", " <wait>", "c", "<wait>", "set gfxpayload=keep", "<enter><wait>", "linux /casper/vmlinuz quiet<wait>", " autoinstall<wait>", " ds=nocloud-net<wait>", "\\;s=http://<wait>", "{{ .HTTPIP }}<wait>", ":{{ .HTTPPort }}/<wait>", " ---", "<enter><wait>", "initrd /casper/initrd<wait>", "<enter><wait>", "boot<enter><wait>"]
  boot_wait              = "5s"
  cpus                   = "${var.cpus}"
  disk_size              = "${var.disk_size}"
  guest_os_type          = "ubuntu"
  http_directory         = "${local.http_directory}"
  iso_checksum           = "${var.iso_checksum}"
  iso_url                = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  memory                 = "${var.memory}"
  output_directory       = "${var.build_directory}/packer-${var.template}-parallels"
  parallels_tools_flavor = "lin"
  prlctl_version_file    = ".prlctl_version"
  shutdown_command       = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password           = "vagrant"
  ssh_port               = 22
  ssh_timeout            = "10000s"
  ssh_username           = "vagrant"
  vm_name                = "${var.template}"
}

source "qemu" "autogenerated_3" {
  boot_command     = [" <wait>", " <wait>", " <wait>", " <wait>", " <wait>", "c", "<wait>", "set gfxpayload=keep", "<enter><wait>", "linux /casper/vmlinuz quiet<wait>", " autoinstall<wait>", " ds=nocloud-net<wait>", "\\;s=http://<wait>", "{{ .HTTPIP }}<wait>", ":{{ .HTTPPort }}/<wait>", " ---", "<enter><wait>", "initrd /casper/initrd<wait>", "<enter><wait>", "boot<enter><wait>"]
  boot_wait        = "5s"
  cpus             = "${var.cpus}"
  disk_size        = "${var.disk_size}"
  headless         = "${var.headless}"
  http_directory   = "${local.http_directory}"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  memory           = "${var.memory}"
  output_directory = "${var.build_directory}/packer-${var.template}-qemu"
  qemuargs         = [["-m", "${var.memory}"], ["-display", "${var.qemu_display}"]]
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password     = "vagrant"
  ssh_port         = 22
  ssh_timeout      = "10000s"
  ssh_username     = "vagrant"
  vm_name          = "${var.template}"
}

source "virtualbox-iso" "autogenerated_4" {
  boot_command            = [" <wait>", " <wait>", " <wait>", " <wait>", " <wait>", "c", "<wait>", "set gfxpayload=keep", "<enter><wait>", "linux /casper/vmlinuz quiet<wait>", " autoinstall<wait>", " ds=nocloud-net<wait>", "\\;s=http://<wait>", "{{ .HTTPIP }}<wait>", ":{{ .HTTPPort }}/<wait>", " ---", "<enter><wait>", "initrd /casper/initrd<wait>", "<enter><wait>", "boot<enter><wait>"]
  boot_wait               = "5s"
  cpus                    = "${var.cpus}"
  disk_size               = "${var.disk_size}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_additions_url     = "${var.guest_additions_url}"
  guest_os_type           = "Ubuntu_64"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "${local.http_directory}"
  iso_checksum            = "${var.iso_checksum}"
  iso_url                 = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  memory                  = "${var.memory}"
  output_directory        = "${var.build_directory}/packer-${var.template}-virtualbox"
  shutdown_command        = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  ssh_username            = "vagrant"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.template}"
}

source "vmware-iso" "autogenerated_5" {
  boot_command        = [" <wait>", " <wait>", " <wait>", " <wait>", " <wait>", "c", "<wait>", "set gfxpayload=keep", "<enter><wait>", "linux /casper/vmlinuz quiet<wait>", " autoinstall<wait>", " ds=nocloud-net<wait>", "\\;s=http://<wait>", "{{ .HTTPIP }}<wait>", ":{{ .HTTPPort }}/<wait>", " ---", "<enter><wait>", "initrd /casper/initrd<wait>", "<enter><wait>", "boot<enter><wait>"]
  boot_wait           = "5s"
  cpus                = "${var.cpus}"
  disk_size           = "${var.disk_size}"
  guest_os_type       = "ubuntu-64"
  headless            = "${var.headless}"
  http_directory      = "${local.http_directory}"
  iso_checksum        = "${var.iso_checksum}"
  iso_url             = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  memory              = "${var.memory}"
  output_directory    = "${var.build_directory}/packer-${var.template}-vmware"
  shutdown_command    = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password        = "vagrant"
  ssh_port            = 22
  ssh_timeout         = "10000s"
  ssh_username        = "vagrant"
  tools_upload_flavor = "linux"
  vm_name             = "${var.template}"
  vmx_data = {
    "cpuid.coresPerSocket"    = "1"
    "ethernet0.pciSlotNumber" = "32"
  }
  vmx_remove_ethernet_interfaces = true
}

build {
  sources = ["source.hyperv-iso.autogenerated_1", "source.parallels-iso.autogenerated_2", "source.qemu.autogenerated_3", "source.virtualbox-iso.autogenerated_4", "source.vmware-iso.autogenerated_5"]

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/vagrant", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["${path.root}/scripts/update.sh", "${path.root}/../_common/motd.sh", "${path.root}/../_common/sshd.sh", "${path.root}/scripts/networking.sh", "${path.root}/scripts/sudoers.sh", "${path.root}/scripts/vagrant.sh", "${path.root}/../_common/virtualbox.sh", "${path.root}/scripts/vmware.sh", "${path.root}/../_common/parallels.sh", "${path.root}/scripts/hyperv.sh", "${path.root}/scripts/cleanup.sh", "${path.root}/../_common/minimize.sh"]
  }

  post-processor "vagrant" {
    output = "${var.build_directory}/${var.box_basename}.<no value>.box"
  }
}
