# Automated Configuration for macOS & Kubuntu 25.04

This project contains Ansible playbooks for automating the setup and configuration of my personal computers running either macOS or Kubuntu 25.04.

## Features
- Installs and configures standard and custom packages for both macOS and Kubuntu
- Adds and configures third-party APT repositories (Brave, VS Code, Docker, 1Password, Tailscale, etc.)
- Installs Flatpak and selected flatpak apps (Kubuntu)
- Configures pipx and installs Python tools
- Sets up global Git configuration with 1Password SSH signing
- Enables and starts Syncthing service
- Removes unnecessary default packages shipped with Kubuntu
- Prunes unmanaged packages in macOS
- Upgrades packages

## Usage
Run the provided `build.sh` script to apply the configuration for your system:

```bash
./build.sh
```

You will be prompted for your sudo password during execution.

## Requirements
- macOS or Kubuntu 25.04
- Internet connection
