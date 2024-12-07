#!/bin/bash

# vmware-setup.sh
# Script to install VMware Tools on Debian-based and RHEL-based systems, with desktop detection

# Colors for output
GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
CYAN='\e[36m'
RESET='\e[0m'

# ASCII art header
echo -e "${CYAN}"
echo "#############################################"
echo "#       VMware Tools Installation Script     #"
echo "#############################################"
echo -e "${RESET}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${RESET}"
    exit 1
fi

# Function to detect OS type
check_os() {
    echo -e "${YELLOW}Detecting operating system...${RESET}"
    if [ -f /etc/redhat-release ]; then
        OS="rhel"
        echo -e "${GREEN}RHEL-based system detected${RESET}"
    elif [ -f /etc/debian_version ]; then
        OS="debian"
        echo -e "${GREEN}Debian-based system detected${RESET}"
    else
        echo -e "${RED}Unsupported operating system. This script supports Debian-based and RHEL-based systems only.${RESET}"
        exit 1
    fi
}

# Function to detect if the system has a desktop environment
check_desktop() {
    echo -e "${YELLOW}Checking for desktop environment...${RESET}"
    if command -v xfce4-session >/dev/null 2>&1 || command -v gnome-session >/dev/null 2>&1 || command -v startkde >/dev/null 2>&1; then
        DESKTOP=true
        echo -e "${GREEN}Desktop environment detected${RESET}"
    else
        DESKTOP=false
        echo -e "${GREEN}No desktop environment detected (headless mode)${RESET}"
    fi
}

# Main installation function
install_vmware_tools() {
    echo -e "${YELLOW}Starting VMware Tools installation...${RESET}"
    if [ "$OS" == "rhel" ]; then
        echo -e "${CYAN}Installing open-vm-tools for RHEL-based system...${RESET}"
        if [ "$DESKTOP" = true ]; then
            dnf install -y open-vm-tools open-vm-tools-desktop
        else
            dnf install -y open-vm-tools
        fi
    elif [ "$OS" == "debian" ]; then
        echo -e "${CYAN}Installing open-vm-tools for Debian-based system...${RESET}"
        apt-get update
        if [ "$DESKTOP" = true ]; then
            apt-get install -y open-vm-tools open-vm-tools-desktop
        else
            apt-get install -y open-vm-tools
        fi
    fi

    echo -e "${YELLOW}Enabling vmtoolsd service...${RESET}"
    systemctl enable --now vmtoolsd

    echo -e "${YELLOW}Verifying installation...${RESET}"
    if systemctl is-active --quiet vmtoolsd; then
        echo -e "${GREEN}VMware Tools installed and running successfully!${RESET}"
    else
        echo -e "${RED}Installation may have failed. Check status with: systemctl status vmtoolsd${RESET}"
    fi
}

# Run the script
check_os
check_desktop
install_vmware_tools

echo -e "${CYAN}#############################################"
echo "#       Installation Completed!            #"
echo "#############################################"
echo -e "${RESET}"
