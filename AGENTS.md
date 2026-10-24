# CLAUDE.md

## Overview

Personal Ansible playbooks for automating macOS and Kubuntu 26.04 system setup. Playbooks run locally on the target machine (no remote hosts).

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
- `macos-install.sh` - Fresh Apple Silicon bootstrap; installs Homebrew and Git, clones this repo into `~/ansible-configuration`, runs `build.sh`
- `kubuntu.yml` - Kubuntu 26.04 playbook (APT packages, Flatpaks, third-party repos, pipx tools, systemd services, pruning of unmanaged packages)
- `macos.yml` - macOS playbook (Homebrew formulae/casks, npm global package (bun), two-pass pruning of unmanaged packages)
- `requirements.yml` - Ansible Galaxy dependency: `community.general` collection v10.0.0+ (required for homebrew, flatpak, git_config, pipx, npm modules)
- `kubuntu.cfg` - Kubuntu-specific Ansible configuration (used via ANSIBLE_CONFIG environment variable in build.sh)

## Notes

- macOS playbook strips the roots behind the compromised eMudhra intermediate CAs (AAA Certificate Services, emSign ECC Root CA - G3) from `/etc/ssl/cert.pem`, which `/usr/bin/curl`, git and system Python trust without revocation checks. macOS updates restore the file, so rerun the playbook after each one
- SDKMAN/GraalVM management exists only in the Kubuntu playbook
- Both playbooks configure Git with 1Password SSH signing (different paths per OS)
- Kubuntu playbook uses shell tasks for adding third-party APT repositories (Brave, Docker, 1Password, Tailscale, Warp)
- Kubuntu playbook includes comprehensive APT package pruning that respects essential system packages, dependencies, and a protected package list
- macOS playbook includes two-pass Homebrew pruning (handles dependent packages first, then force-removes remaining with --ignore-dependencies)
- Both playbooks include interactive confirmation prompts before pruning packages
- CI runs `ansible-lint` (v26) on push/PR to master using GitHub Actions on Ubuntu 24.04
- macOS build.sh collects the become password manually and passes it two ways: `--become-password-file` feeds the become plugin for `become: true` tasks, and `-e ansible_become_password=` (JSON-escaped) exposes it as a template variable for `homebrew_cask`'s `sudo_password` parameter. `-K` alone does not expose it as a template variable, and `-e` alone does not feed the become plugin on local connections.
