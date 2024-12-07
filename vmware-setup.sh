#!/bin/bash

# vmware-setup.sh
echo "Installing VMware Tools for Rocky Linux..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo"
    exit 1
fi

# Function to detect OS
check_os() {
    if [ -f /etc/rocky-release ]; then
        echo "Rocky Linux detected"
    else
        echo "This script is only for Rocky Linux"
        exit 1
    fi
}

# Main installation function
install_vmware_tools() {
    echo "Installing open-vm-tools..."
    dnf install -y open-vm-tools open-vm-tools-desktop

    echo "Enabling vmtoolsd service..."
    systemctl enable --now vmtoolsd

    echo "Verifying installation..."
    if systemctl is-active --quiet vmtoolsd; then
        echo "VMware Tools installed and running successfully!"
    else
        echo "Installation may have failed. Check status with: systemctl status vmtoolsd"
    fi
}

# Run the installation
check_os
install_vmware_tools
