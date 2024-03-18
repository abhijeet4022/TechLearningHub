#!/bin/bash

# Clear the Screen
clear

# Variable declaration
PACKAGE_NAME=("vim" "bash-completion" "git" "docker")

# Using for loop to iterate the package
for package in "${PACKAGE_NAME[@]}"; do
  ( rpm -qa | grep -i $package  && which $package ) &>> /dev/null
  if [ $? -ne 0 ]; then
    echo -e "\n\e[33mInstalling the $package package.\e[0m"
    yum install -y $package &>> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "\e[32m-- $package Package installed successfully\e[0m"
    else
        echo -e "\e[31m-- $package Package installation is failed\e[0m"
    fi
  else
    echo -e "\n\e[32m$package Package already available in OS.\n\e[0m"
  fi
  echo ""
done

