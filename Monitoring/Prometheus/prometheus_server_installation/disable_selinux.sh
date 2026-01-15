#!/bin/bash

YELLOW='\e[33m'
NC='\e[0m'
GREEN='\e[32m'

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo -e "\e[32mChecking SELinux status.\e[0m"
# Check if SELinux tools exist
if ! command -v getenforce >/dev/null 2>&1; then
    echo -e "\e[31mSELinux does not appear to be installed.\e[0m"
    exit 0
fi

STATUS=$(getenforce)

echo -e "${YELLOW}[WARN] Current SELinux status: $STATUS${NC}"

if [[ "$STATUS" == "Enforcing" || "$STATUS" == "Permissive" ]]; then
    echo -e "\e[31mDisabling SELinux at runtime...\e[0m"
    setenforce 0
    ## "Disabling SELinux permanently in /etc/selinux/config..."
    if [[ -f /etc/selinux/config ]]; then
        sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
    else
        echo "SELINUX=disabled" > /etc/selinux/config
    fi

    echo -e "\e[32mSELinux has been disabled.\e[0m"
    echo -e "\e[33mA reboot is required for permanent changes to take effect.\e[0m"

else
    echo -e "${GREEN}[INFO] SELinux is already disabled no action required.${NC}"
fi
