# Ubuntu VirtualBox VM with Packer

This project creates an Ubuntu 22.04 VirtualBox VM using Packer.

## Prerequisites

- [Packer](https://www.packer.io/downloads) (1.7.0+)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (6.1+)

## Usage

### Using Remote ISO (with built-in caching)

```bash
cd ubuntu-vm
packer init .
packer build .
```

### Using Local ISO

1. Download the Ubuntu ISO from https://releases.ubuntu.com/22.04/
2. Run Packer with the local ISO path:

```bash
cd ubuntu-vm
packer init .
packer build -var "iso_path=C:/path/to/ubuntu-22.04.4-live-server-amd64.iso" .
```

## Notes

- Packer automatically caches downloaded ISOs in `%USERPROFILE%\.packer.d\cache` on Windows
- The default username/password for the VM is ubuntu/ubuntu
- The VM has 2GB RAM and 2 CPUs by default