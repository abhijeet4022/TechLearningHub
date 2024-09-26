#!/bin/bash

# Create a temporary directory for GCM installation
mkdir -p /tmp/gcm

# Download the Git Credential Manager
curl -Lso /tmp/gcm/gcm-linux_amd64.2.5.1.tar.gz https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.5.1/gcm-linux_amd64.2.5.1.tar.gz

# Extract the downloaded tar.gz file
tar -xzf /tmp/gcm/gcm-linux_amd64.2.5.1.tar.gz -C /tmp/gcm

# Move the GCM binary to /usr/local/bin and make it executable
mv /tmp/gcm/git-credential-manager /usr/local/bin/gcm
chmod +x /usr/local/bin/gcm

# Clean up the temporary directory
rm -rf /tmp/gcm

# Configure Git to use GCM
git config --global credential.helper "/usr/local/bin/gcm --no-ui"
git config --global credential.credentialStore plaintext
git config --global http.timeout 120

# Print confirmation message
echo "Now, Git will use GCM to securely store your credentials. When you interact with a Git repository, it will prompt for credentials once, then securely store them."


# To remove the git variable
# git config --global --unset credential.helper "/usr/local/bin/gcm --no-ui"
# export GCM_CREDENTIAL_STORE=plaintext
