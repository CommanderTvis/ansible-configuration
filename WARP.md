# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

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

- `build.sh` - Entry point; detects OS, installs Ansible if needed, runs appropriate playbook
- `kubuntu.yml` - Kubuntu 25.10 playbook (APT packages, Flatpaks, third-party repos, pipx tools, systemd services)
- `macos.yml` - macOS playbook (Homebrew formulae/casks, npm packages, prunes unmanaged packages)
- `requirements.yml` - Ansible Galaxy dependency: `community.general` collection (required for homebrew, flatpak, git_config, pipx modules)
- `ansible.cfg` - Uses localhost inventory, privilege escalation via sudo

## Notes

- Both playbooks configure Git with 1Password SSH signing
- Kubuntu playbook uses shell tasks for adding third-party APT repositories (Brave, VS Code, Docker, 1Password, Tailscale, Warp)
- macOS playbook includes an interactive prune step that removes Homebrew packages not in the managed list
- CI runs `ansible-lint` on push/PR to master
