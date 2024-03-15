#!/bin/bash
clear # To clear secreen
echo -e -n "\n\e[33mPlease enter the username: \e[0m"
read USERNAME

# Delete the user if already exist.
id $USERNAME
if [ $? -eq 0 ]; then
  echo -e "\n\e[31m$USERNAME already exist so removing the $USERNAME user first.\n\e[0m"
  userdel -r $USERNAME
fi

# Create User.
echo -e "\n\e[33mCreating user $USERNAME.\e[0m"
useradd -m $USERNAME
if [ $? -eq 0 ]; then
  echo -e "\e[32m$USERNAME user created successfully.\n\e[0m"
fi

# Set password for user.
echo -e "\n\e[33mPlease enter the Password for $USERNAME\e[0m"
passwd $USERNAME
if [ $? -eq 0 ]; then
  echo -e "\e[32mPassword set successfully for $USERNAME.\n\e[0m"
fi

