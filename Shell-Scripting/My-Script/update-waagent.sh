#!/bin/bash

# Check the current package version of python-azure-agent
echo "Checking the current package version of python-azure-agent..."
sudo zypper info python-azure-agent

# Check available updates
echo "Checking for available updates..."
sudo zypper refresh
sudo zypper info python-azure-agent

# Install the latest package version
echo "Installing the latest version of python-azure-agent..."
sudo zypper install python-azure-agent -y

# Ensure auto update is enabled by checking the configuration
echo "Checking if auto update is enabled..."
if grep -iq 'AutoUpdate.Enabled=y' /etc/waagent.conf; then
    echo "AutoUpdate is already enabled."
else
    echo "AutoUpdate is not enabled. Enabling now..."
    sudo sed -i 's/AutoUpdate.Enabled=n/AutoUpdate.Enabled=y/g' /etc/waagent.conf
    echo "AutoUpdate has been enabled."
fi

# Restart the waagent service
echo "Restarting the waagent service..."
sudo systemctl restart waagent

echo "Script execution completed."
