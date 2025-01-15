#!/bin/bash

# Step 1: Run zypper refresh and capture output
echo "Refreshing repositories..."
refresh_output=$(zypper refresh 2>&1)

# Step 2: Extract problematic repositories
problematic_repos=$(echo "$refresh_output" | grep -oP '(?<=Repository ).*?(?= is invalid|refresh failed)' | awk '{print $1}')

# Step 3: Check if there are any problematic repositories
if [[ -n "$problematic_repos" ]]; then
  echo "Problematic repositories detected: $problematic_repos"

  # Disable problematic repositories
  for repo in $problematic_repos; do
    echo "Disabling repository: $repo"
    zypper mr -d "$repo"
  done
else
  echo "No problematic repositories detected."
fi

# Step 4: Install the httpd package
echo "Installing httpd package..."
zypper install -y httpd

# Step 5: Re-enable problematic repositories
if [[ -n "$problematic_repos" ]]; then
  for repo in $problematic_repos; do
    echo "Re-enabling repository: $repo"
    zypper mr -e "$repo"
  done
fi

# Unset the refresh_output variable
unset refresh_output
unset problematic_repos

echo "Script execution completed."
