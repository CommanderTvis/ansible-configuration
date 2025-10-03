# Automated Configuration for macOS & Kubuntu 25.04

This project contains Ansible playbooks for automating the setup and configuration of my personal computers running either macOS or Kubuntu 25.04.

## Features

### Common Features
- Installs and configures standard development and productivity packages
- Sets up global Git configuration with 1Password SSH signing
- Upgrades all managed packages to latest versions

### macOS Specific
- Installs Homebrew packages (development tools, CLI utilities, media tools)
- Installs Homebrew cask applications (GUI apps, fonts, development environments)
- Installs yarn globally via npm
- Installs Python package manager (uv) via Homebrew
- Prunes unmanaged Homebrew packages with user confirmation

### Kubuntu Specific
- Adds and configures third-party APT repositories (Brave, VS Code, Docker, 1Password, Tailscale)
- Installs Flatpak and selected flatpak applications (Obsidian, Telegram, Anki, etc.)
- Configures pipx and installs Python development tools (poetry, uv)
- Enables and starts Syncthing service for file synchronization
- Removes unnecessary default packages (kate)
- Supports NVIDIA driver installation

## Usage
Run the provided `build.sh` script to apply the configuration for your system:

```bash
./build.sh
```

You will be prompted for your sudo password during execution.

## Requirements
- macOS or Kubuntu 25.04
- Internet connection
