# Automated Configuration for macOS & Kubuntu 26.04

This project contains local Ansible playbooks for setting up and maintaining my personal computers running macOS or Kubuntu 26.04. The macOS playbook targets Apple Silicon with Homebrew under `/opt/homebrew`. The Linux entry point also accepts Ubuntu 26.04 and installs the Kubuntu desktop if needed.

## Features

### Common Features

- Installs and configures standard development and productivity packages
- Sets up global Git configuration with 1Password SSH signing
- Manages GraalVM 25 and 21 through SDKMAN, selects 25 as the default, and removes other installed Java candidates
- Shows pending package installations and upgrades

### macOS Specific

- Installs Homebrew packages (development tools, CLI utilities, media tools)
- Installs Homebrew cask applications (GUI apps, fonts, development environments)
- Installs and upgrades Bun globally via npm
- Installs Python package manager (uv) via Homebrew
- Installs Rosetta 2 if needed and Claude Code via its native installer
- Configures Apple container and the socktainer Docker API service
- Configures Ghostty, shell profiles, SSH, login items, and macOS preferences
- Sets network-service DNS servers to Cloudflare's `1.1.1.1` and `1.0.0.1`
- Upgrades managed formulae and casks, plus outdated formulae outside the protected list
- Prunes unmanaged Homebrew packages with user confirmation

### Kubuntu Specific

- Adds and configures third-party APT repositories (Brave, Docker, 1Password, Tailscale, Warp)
- Installs Flatpak and selected Flatpak applications (Obsidian, Anki, Zulip, Popsicle, Zed)
- Bootstraps uv through pipx and protects the system Python environment against pip installs
- Installs Bun and provides Claude Code and yt-dlp wrappers through bunx and uvx
- Performs a full APT upgrade
- Enables and starts Syncthing service for file synchronization
- Prunes unmanaged Flatpak applications and APT packages with user confirmation
- Installs NVIDIA driver 580 and removes selected default KDE applications

## Usage

### Fresh macOS installation

On a new Apple Silicon Mac, open Terminal and paste:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/CommanderTvis/ansible-configuration/master/macos-install.sh)"
```

The script installs Homebrew (including Apple Command Line Tools if missing) and Git, clones this repository into `~/ansible-configuration` over HTTPS, and runs the macOS setup. Use an administrator account and enter your password when prompted; do not run the command with `sudo`.

The script refuses to overwrite an existing `~/ansible-configuration`. To rerun setup, use the existing checkout as described below. Review the package lists and configuration changes before starting; the overwrite and pruning behavior described below also applies to this installer.

### Existing checkout

Run the provided `build.sh` script to apply the configuration for your system:

```bash
./build.sh
```

The script detects the OS, installs Ansible if needed, and installs or upgrades the `community.general` collection. On macOS, it also installs or upgrades Ansible and ansible-lint through Homebrew and prompts for your sudo password. On Linux, the configuration expects passwordless sudo; pass `-K` to prompt instead:

```bash
./build.sh -K
```

Additional arguments are forwarded to `ansible-playbook`. Review the package lists before running: both playbooks prompt before pruning unmanaged packages, and the macOS pruning includes forced formula removal. The playbooks also overwrite configuration files they manage, including `.zprofile`, `.zshrc`, and `.ssh/config` on macOS.

## Validation

```bash
uvx ansible-lint
ansible-playbook -i 'localhost,' -c local macos.yml --syntax-check
ansible-playbook -i 'localhost,' -c local kubuntu.yml --syntax-check
```

GitHub Actions runs ansible-lint on pushes to `master` and on pull requests.

## Requirements

- Apple Silicon macOS (the fresh-install script installs Homebrew), or Ubuntu/Kubuntu 26.04
- Internet connection
- Sudo privileges
