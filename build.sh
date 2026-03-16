#!/bin/bash
set -e

# Check OS and set playbook
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLAYBOOK="macos.yml"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check Ubuntu version
    if ! grep -q "Ubuntu 25.10" /etc/os-release; then
        echo "Error: Only Ubuntu 25.10 is supported on Linux"
        exit 1
    fi
    # Warn if Kubuntu is not installed (playbook will install it)
    if ! dpkg -l kubuntu-desktop 2>/dev/null | grep -q '^ii'; then
        echo "Warning: kubuntu-desktop not installed. The playbook will install it."
    fi
    PLAYBOOK="kubuntu.yml"
else
    echo "Error: Unsupported operating system"
    exit 1
fi

# Install Ansible
if ! command -v ansible-playbook >/dev/null 2>&1; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ansible
    else
        sudo apt update
        sudo apt install -y ansible
    fi
    ansible-galaxy install -r requirements.yml
fi

# Ensure gh is installed and authenticated on macOS (needed for private Homebrew taps)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v gh >/dev/null 2>&1; then
        brew install gh
    fi
    if ! gh auth status >/dev/null 2>&1; then
        echo "GitHub CLI is not authenticated. Logging in (needed for private Homebrew taps)..."
        gh auth login
    fi
fi

# Run ansible-playbook with OS-specific options
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Password is collected manually and passed two ways:
    # 1. --become-password-file: feeds the become plugin for `become: true` tasks
    # 2. -e ansible_become_password: exposes it as a template variable for
    #    homebrew_cask's sudo_password parameter (-K alone does not do this)
    IFS= read -rsp "Enter your password for privilege escalation: " PASSWORD
    echo
    ansible-playbook -i 'localhost,' -c local "$PLAYBOOK" \
        --become-password-file <(printf '%s' "$PASSWORD") \
        -e "ansible_become_password=$(printf '%s' "$PASSWORD" | python3 -c 'import json,sys;print(json.dumps(sys.stdin.read()))')" "$@"
    unset PASSWORD
else
    # Use local connection with passwordless sudo
    ANSIBLE_CONFIG=kubuntu.cfg ansible-playbook -i 'localhost,' -c local "$PLAYBOOK" "$@"
fi
