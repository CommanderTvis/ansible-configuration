#!/bin/bash
set -e

# Ensure Ansible is installed
if ! command -v ansible-playbook >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y ansible
    ansible-galaxy collection install community.general
fi

ansible-playbook -i 'localhost,' -c local playbook.yaml --ask-become-pass
