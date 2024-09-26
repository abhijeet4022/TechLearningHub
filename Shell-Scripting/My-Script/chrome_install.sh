#!/bin/bash

# Download Google Chrome RPM package
echo "Downloading Google Chrome RPM package..."
wget -q -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# Install Google Chrome
echo "Installing Google Chrome..."
sudo dnf install -y /tmp/google-chrome-stable_current_x86_64.rpm

# Clean up RPM file
rm -f /tmp/google-chrome-stable_current_x86_64.rpm

# Add alias to .bashrc
echo "Setting up alias for Google Chrome..."
#echo "alias chrome='google-chrome --no-sandbox > /dev/null 2>&1 & disown'" >> ~/.bashrc

#  Check if the alias is already in .bashrc and add it only if not present
alias_cmd="alias chrome='google-chrome --no-sandbox > /dev/null 2>&1 & disown'"

if ! grep -qF "$alias_cmd" ~/.bashrc; then
    echo "$alias_cmd" >> ~/.bashrc
fi

# Apply the changes
source ~/.bashrc

echo "Google Chrome installation and alias setup complete."
echo "Type chrome to open the chrome browser."
