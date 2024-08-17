#!/bin/bash

# Variable the will use while running the function.
component=shipping
schema_type=mysql
mysql_root_password=$1
# Linking with common.sh file
source common.sh
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31m Input password missing.\e[0m"
  exit 1
fi

# Calling the nodejs function to be executed
func_java


