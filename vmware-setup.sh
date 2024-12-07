#!/bin/bash

# vmware-setup.sh
# Script to install VMware Tools on Debian-based and RHEL-based systems, with desktop detection

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo"
    exit 1
fi

# Function to detect OS type
check_os() {
    if [ -f /etc/redhat-release ]; then
        OS="rhel"
        echo "RHEL-based system detected"
    elif [ -f /etc/debian_version ]; then
        OS="debian"
        echo "Debian-based system detected"
    else
        echo "Unsupported operating system. This script supports Debian-based and RHEL-based systems only."
        exit 1
    fi
}

# Function to detect if the system has a desktop environment
check_desktop() {
    if command -v xfce4-session >/dev/null 2>&1 || command -v gnome-session >/dev/null 2>&1 || command -v startkde >/dev/null 2>&1; then
        DESKTOP=true
        echo "Desktop environment detected"
    else
        DESKTOP=false
        echo "No desktop environment detected (headless mode)"
    fi
}

# Main installation function
install_vmware_tools() {
    if [ "$OS" == "rhel" ]; then
        echo "Installing open-vm-tools for RHEL-based system..."
        if [ "$DESKTOP" = true ]; then
            dnf install -y open-vm-tools open-vm-tools-desktop
        else
            dnf install -y open-vm-tools
        fi
    elif [ "$OS" == "debian" ]; then
        echo "Installing open-vm-tools for Debian-based system..."
        apt-get update
        if [ "$DESKTOP" = true ]; then
            apt-get install -y open-vm-tools open-vm-tools-desktop
        else
            apt-get install -y open-vm-tools
        fi
    fi

    echo "Enabling vmtoolsd service..."
    systemctl enable --now vmtoolsd

    echo "Verifying installation..."
    if systemctl is-active --quiet vmtoolsd; then
        echo "VMware Tools installed and running successfully!"
    else
        echo "Installation may have failed. Check status with: systemctl status vmtoolsd"
    fi
}

# Run the script
check_os
check_desktop
install_vmware_tools
