#!/bin/bash

# Download Google Chrome RPM package
echo "Downloading Google Chrome RPM package..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# Install Google Chrome
echo "Installing Google Chrome..."
sudo dnf install -y ./google-chrome-stable_current_x86_64.rpm

# Clean up RPM file
rm -f google-chrome-stable_current_x86_64.rpm

# Add alias to .bashrc
echo "Setting up alias for Google Chrome..."
echo "alias chrome='google-chrome --no-sandbox > /dev/null 2>&1 & disown'" >> ~/.bashrc

# Apply the changes
source ~/.bashrc

echo "Google Chrome installation and alias setup complete."
echo "Type chrome to open the chrome browser."
