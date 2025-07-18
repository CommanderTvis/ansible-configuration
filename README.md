# Kubuntu 25.04 Automated Configuration

This project contains an Ansible playbook for automating the setup and configuration of my personal PC running Kubuntu 25.04.

## Features
- Installs and configures standard and custom APT packages
- Adds needed third-party APT repositories (Brave, VS Code, Docker, 1Password, Tailscale)
- Installs Flatpak and selected flatpak apps
- Configures pipx and installs packages from there
- Sets up global Git configuration
- Enables and starts Syncthing service
- Removes unnecessary default packages
- Upgrades packages

## Usage
Run the provided `build.sh` script to apply the configuration:

```bash
./build.sh
```

You will be prompted for your sudo password during execution.

## Requirements
- Kubuntu 25.04
- Internet connection
