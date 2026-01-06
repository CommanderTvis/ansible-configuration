# CLAUDE.md

## Overview

Personal Ansible playbooks for automating macOS and Kubuntu 25.10 system setup. Playbooks run locally on the target machine (no remote hosts).

## Commands

```bash
# Apply configuration (auto-detects OS)
./build.sh

# Install Ansible Galaxy dependencies
ansible-galaxy install -r requirements.yml

# Lint playbooks
ansible-lint

# Dry-run a playbook
ansible-playbook -i 'localhost,' -c local kubuntu.yml --check
```

## Architecture

- `build.sh` - Entry point; detects OS, installs Ansible if needed, runs appropriate playbook with OS-specific options
- `kubuntu.yml` - Kubuntu 25.10 playbook (APT packages, Flatpaks, third-party repos, pipx tools, systemd services, pruning of unmanaged packages)
- `macos.yml` - macOS playbook (Homebrew formulae/casks, mvnd (Maven Daemon) with custom dependency handling, npm global package (yarn), two-pass pruning of unmanaged packages)
- `requirements.yml` - Ansible Galaxy dependency: `community.general` collection v10.0.0+ (required for homebrew, flatpak, git_config, pipx, npm modules)
- `kubuntu.cfg` - Kubuntu-specific Ansible configuration (used via ANSIBLE_CONFIG environment variable in build.sh)

## Notes

- Both playbooks configure Git with 1Password SSH signing (different paths per OS)
- Kubuntu playbook uses shell tasks for adding third-party APT repositories (Brave, VS Code, Docker, 1Password, Tailscale)
- Kubuntu playbook includes comprehensive APT package pruning that respects essential system packages, dependencies, and a protected package list
- macOS playbook includes two-pass Homebrew pruning (handles dependent packages first, then force-removes remaining with --ignore-dependencies)
- macOS playbook installs mvnd@1 (Maven Daemon) as a protected package by first installing its dependencies (excluding openjdk), then installing mvnd with `--ignore-dependencies`, and creating symlinks for mvnd and mvn binaries
- Both playbooks include interactive confirmation prompts before pruning packages
- CI runs `ansible-lint` (v25) on push/PR to master using GitHub Actions on Ubuntu 24.04
