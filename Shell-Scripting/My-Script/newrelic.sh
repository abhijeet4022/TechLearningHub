#!/bin/bash

# Assign command-line arguments to variables
NEW_RELIC_API_KEY="$1"
if [ -z "${NEW_RELIC_API_KEY}" ]; then
  echo -e "\e[31mInput NEW_RELIC_API_KEY Missing:\e[0m"
  echo -e "\e[31mPlease run the script like this: sudo bash newrelic.sh \"NEW_RELIC_API_KEY\" \"NEW_RELIC_ACCOUNT_ID\"\e[0m"
  echo -e "\e[31mExample: sudo bash newrelic.sh \"NRAK-0FXXJ5XXXXXXXEQQEGDXXXXJ7XY\" \"63XXX38\"\e[0m"
  exit 1
fi

NEW_RELIC_ACCOUNT_ID="$2"
if [ -z "${NEW_RELIC_ACCOUNT_ID}" ]; then
  echo -e "\e[31mInput NEW_RELIC_ACCOUNT_ID Missing:\e[0m"
  echo -e "\e[31mPlease run the script like this: sudo bash newrelic.sh \"NEW_RELIC_API_KEY\" \"NEW_RELIC_ACCOUNT_ID\"\e[0m"
  echo -e "\e[31mExample: sudo bash newrelic.sh \"NRAK-0FA0J5ZNVMO00EQQEGDVOO1J7XY\" \"6338338\"\e[0m"
  exit 1
fi


#############################################################################
######################### Please Don't change any thing #####################
#############################################################################


# Exit on any error
#set -e


# Function to display a message
echo_info() {
    echo -e "\n\e[32m[INFO]\e[0m $1"
}


# Function to display success or failure
check_status() {
    if [[ $? -eq 0 ]]; then
        echo -e "\e[32m[SUCCESS]\e[0m"
    else
        echo -e "\e[31m[FAILED]\e[0m"
        exit 1
    fi
}


####################################################################################
################### Main script starts from here ##################################
####################################################################################

# Check if New Relic agent is already installed
echo_info "Checking if New Relic is already installed..."
if systemctl status newrelic-infra >/dev/null 2>&1; then
  echo_info "New Relic agent is already installed. Exiting the script."
  exit 0
else
  echo_info "New Relic agent is not installed continuing with the installation."
fi

# Determine the OS distribution
OS_DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
# SUSE-specific operations
if [[ "$OS_DISTRO" == "SLES" || "$OS_DISTRO" == "openSUSE Leap" ]]; then
  # Run zypper refresh and capture output
  echo_info "Refreshing repositories..."
  refresh_output=$(zypper refresh 2>&1)


  # Extract problematic repositories
  echo_info "Extracting problematic repositories..."
  problematic_repos=$(echo "$refresh_output" | grep -oP '(?<=Repository ).*?(?= is invalid|refresh failed)' | awk '{print $1}')
  if [[ -n "$problematic_repos" ]]; then
      echo_info "Problematic repositories detected: $problematic_repos"
  else
      echo_info "No problematic repositories detected."
  fi

  # Disable problematic repositories
  if [[ -n "$problematic_repos" ]]; then
      for repo in $problematic_repos; do
	    repo_cleaned=$(echo "$repo" | sed "s/^['\"]\([^'\"]*\)['\"]$/\1/")
          echo_info "Disabling repository: $repo_cleaned"
          zypper mr -d "$repo_cleaned"
          check_status
      done
  fi
fi


# Install New Relic
echo_info "Installing New Relic..."
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && \
NEW_RELIC_API_KEY="$NEW_RELIC_API_KEY" \
NEW_RELIC_ACCOUNT_ID="$NEW_RELIC_ACCOUNT_ID" \
/usr/local/bin/newrelic install
check_status



echo_info "Restart New Relic..."
systemctl restart newrelic-infra
check_status



# Re-enable problematic repositories
if [[ -n "$problematic_repos" ]]; then
  for repo in $problematic_repos; do
    repo_cleaned=$(echo "$repo" | sed "s/^['\"]\([^'\"]*\)['\"]$/\1/")
    echo_info "Enabling repository: $repo_cleaned"
    zypper mr -e "$repo_cleaned"
    check_status
  done
fi

####################################################################################
############################# Unset the Variables ##################################
####################################################################################

# Unset the refresh_output variable
unset refresh_output
unset problematic_repos

echo_info "Script execution completed successfully."
