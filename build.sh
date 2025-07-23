#!/bin/bash
set -e

# Check OS and set playbook
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLAYBOOK="macos.yaml"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check Ubuntu version
    if ! grep -q "Ubuntu 25.04" /etc/os-release; then
        echo "Error: Only Ubuntu 25.04 is supported on Linux"
        exit 1
    fi
    # Check for Kubuntu
    if ! apt list --installed 2>/dev/null | grep -q kubuntu-desktop; then
        echo "Error: Kubuntu desktop environment required"
        exit 1
    fi
    PLAYBOOK="kubuntu.yaml"
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
    ansible-galaxy collection install community.general
fi

ansible-playbook -i 'localhost,' -c local "$PLAYBOOK" --ask-become-pass
