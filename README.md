# SBEMUVEN Project

This repository contains tools for creating and managing virtual environments.

## Ubuntu VirtualBox VM

The `ubuntu-vm` directory contains a Packer project that creates an Ubuntu 22.04 VirtualBox VM.

### Prerequisites

- [Packer](https://www.packer.io/downloads) (1.7.0+)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (6.1+)

### Building the VM

#### Using VSCode Tasks

1. Open the project in VSCode
2. Press `Ctrl+Shift+P` and select "Tasks: Run Task"
3. Choose one of the following tasks:
   - "Build Ubuntu VM (Remote ISO)" - Downloads and uses the Ubuntu ISO from the internet
   - "Build Ubuntu VM (Local ISO)" - Uses a locally downloaded ISO file (you'll be prompted for the path)

#### Using PowerShell Script

```powershell
# From the root directory
cd .vscode
.\build-vm.ps1 [-IsoPath "path\to\local.iso"] [-Debug]
```

#### Manual Build

```bash
cd ubuntu-vm
packer init .
packer build .  # For remote ISO
# OR
packer build -var "iso_path=C:/path/to/ubuntu-22.04.4-live-server-amd64.iso" .  # For local ISO
```

### Notes

- Packer automatically caches downloaded ISOs in `%USERPROFILE%\.packer.d\cache` on Windows
- The default username/password for the VM is ubuntu/ubuntu
- The VM has 2GB RAM and 2 CPUs by default
- The `http` directory contains files used for automated installation