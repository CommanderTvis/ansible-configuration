#!/bin/bash
set -e

# Check OS and set playbook
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLAYBOOK="macos.yml"
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

# Run ansible-playbook with OS-specific options
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -n "Enter your password for privilege escalation: "
    read -s PASSWORD
    echo  # Add newline after password input
    ansible-playbook -i 'localhost,' -c local "$PLAYBOOK" -e "ansible_become_password=$PASSWORD"
    unset PASSWORD  # Clear password from memory for security
else
    ansible-playbook -i 'localhost,' -c local "$PLAYBOOK" --ask-become-pass
fi
