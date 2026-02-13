#!/bin/bash

set -e

echo "==============================="
echo " MySQL 8.0 Installation Script "
echo "==============================="

# Update system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "Installing required packages..."
sudo apt install -y ca-certificates curl gpg lsb-release

# Add MySQL GPG Key
echo "Adding MySQL GPG key..."
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xB7B3B788A8D3785C" | \
sudo gpg --dearmor -o /usr/share/keyrings/mysql.gpg

# Create MySQL repository file
echo "Creating MySQL APT repository..."
sudo tee /etc/apt/sources.list.d/mysql.sources > /dev/null <<EOF
Types: deb
URIs: http://repo.mysql.com/apt/debian
Suites: $(lsb_release -cs)
Components: mysql-8.0
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/mysql.gpg
EOF

# Create MySQL Tools repository file
echo "Creating MySQL Tools repository..."
sudo tee /etc/apt/sources.list.d/mysql-tools.sources > /dev/null <<EOF
Types: deb deb-src
URIs: http://repo.mysql.com/apt/debian
Suites: $(lsb_release -cs)
Components: mysql-tools
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/mysql.gpg
EOF

# Update repository list
echo "Updating package lists..."
sudo apt update

# Install MySQL 8.0
echo "Installing MySQL Community Server..."
sudo apt install -y mysql-community-server

# Restart and enable MySQL
echo "Restarting MySQL service..."
sudo systemctl restart mysql
sudo systemctl enable mysql --now

# Show MySQL status
echo "Checking MySQL service status..."
sudo systemctl status mysql --no-pager

# Show MySQL version
echo "Installed MySQL Version:"
mysql -V

echo "==============================="
echo " MySQL 8.0 Installation Done "
echo "==============================="
