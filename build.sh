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

# Run ansible-playbook with OS-specific options
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -n "Enter your password for privilege escalation: "
    read -s PASSWORD
    echo  # Add newline after password input
    ansible-playbook -i 'localhost,'  -c local "$PLAYBOOK" -e "ansible_become_password=$PASSWORD"
    unset PASSWORD
else
    # Use local connection with passwordless sudo
    ANSIBLE_CONFIG=kubuntu.cfg ansible-playbook -i 'localhost,' -c local "$PLAYBOOK"
fi
