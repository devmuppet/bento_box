
variable "box_basename" {
  type    = string
  default = "debian-9.13"
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

variable "iso_checksum" {
  type    = string
  default = "b35d8b33c9fc316c03178d8f493ecb858269082337150f82af75c8d4663cc324"
}

variable "iso_name" {
  type    = string
  default = "debian-9.13.0-ppc64el-netinst.iso"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "mirror" {
  type    = string
  default = "http://cdimage.debian.org/cdimage/archive"
}

variable "mirror_directory" {
  type    = string
  default = "9.13.0/ppc64el/iso-cd"
}

variable "name" {
  type    = string
  default = "debian-9.13"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

variable "preseed_path" {
  type    = string
  default = "debian-9/preseed.cfg"
}

variable "qemu_display" {
  type    = string
  default = "none"
}

variable "template" {
  type    = string
  default = "debian-9.13-ppc64el"
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

source "qemu" "autogenerated_1" {
  accelerator         = "kvm"
  boot_command        = ["c<wait>", "setparams 'Automated install'<enter><wait>", "<enter><wait>", "set options=\" preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_path} <wait>", "debian-installer=en_US.UTF-8 <wait>", "auto <wait>", "locale=en_US.UTF-8 <wait>", "kbd-chooser/method=us <wait>", "keyboard-configuration/xkb-keymap=us <wait>", "netcfg/get_hostname={{ .Name }} <wait>", "netcfg/get_domain=vagrantup.com <wait>", "fb=false <wait>", "debconf/frontend=noninteractive <wait>", "console-setup/ask_detect=false <wait>", "console-keymaps-at/keymap=us <wait>", "grub-installer/bootdev=/dev/vda1 <wait>", "\"", "<enter><wait>", "boot_one<wait>", "<enter><wait>", "boot<enter>"]
  boot_wait           = "5s"
  cpus                = "${var.cpus}"
  disk_size           = "${var.disk_size}"
  headless            = "${var.headless}"
  http_directory      = "${local.http_directory}"
  iso_checksum        = "${var.iso_checksum}"
  iso_url             = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  machine_type        = "pseries"
  memory              = "${var.memory}"
  output_directory    = "${var.build_directory}/packer-${var.template}-qemu"
  qemu_binary         = "qemu-system-ppc64le"
  qemuargs            = [["-m", "${var.memory}"], ["-display", "${var.qemu_display}"]]
  shutdown_command    = "echo 'vagrant' | sudo -S /sbin/shutdown -hP now"
  ssh_password        = "vagrant"
  ssh_port            = 22
  ssh_timeout         = "10000s"
  ssh_username        = "vagrant"
  use_default_display = true
  vm_name             = "${var.template}"
}

build {
  sources = ["source.qemu.autogenerated_1"]

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/vagrant", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["${path.root}/scripts/update.sh", "${path.root}/../_common/motd.sh", "${path.root}/../_common/sshd.sh", "${path.root}/scripts/networking.sh", "${path.root}/scripts/sudoers.sh", "${path.root}/../_common/vagrant.sh", "${path.root}/scripts/systemd.sh", "${path.root}/../_common/virtualbox.sh", "${path.root}/../ubuntu/scripts/vmware.sh", "${path.root}/../_common/parallels.sh", "${path.root}/scripts/cleanup.sh", "${path.root}/../_common/minimize.sh"]
  }

  post-processor "vagrant" {
    output = "${var.build_directory}/${var.box_basename}.<no value>.box"
  }
}
