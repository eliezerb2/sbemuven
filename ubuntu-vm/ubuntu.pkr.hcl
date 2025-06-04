packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu" {
  guest_os_type    = "Ubuntu_64"
  iso_url          = var.iso_path
  iso_checksum     = var.iso_checksum
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  ssh_timeout      = "30m"
  shutdown_command = "echo 'ubuntu' | sudo -S shutdown -P now"
  
  boot_command = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
    "<wait10m>"
  ]
  
  http_directory    = "http"
  memory            = 2048
  cpus              = 2
  disk_size         = 20000
  vm_name           = "ubuntu-22.04"
  headless          = false
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]
  
  provisioner "shell" {
    inline = [
      "echo 'Installing updates...'",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "echo 'Installation completed.'"
    ]
  }
}