#!/bin/bash

# Variables

# SSH User Name
user_name="ec2-user"
# SSH password
#ssh_password="Abhi@8434"
# Path to the file containing server list
servers="./servers_list.txt"
# Path to SSH key pair
home_dir=/root
public_key="/$home_dir/.ssh/id_rsa.pub" 
# STDOUT and STDERR file
output=/tmp/output.txt

rm -f ${output}


# Check if server file exists.
echo -e "\e[34m Checking if server file exists. \e[0m" | tee -a ${output}
# Check if server file exists.
if [ ! -f ${servers} ]; then
  echo -e "\e[31m Server file $SERVER_FILE not found. \e[0m\n" | tee -a ${output}
  exit 1
else
  echo -e "\e[32m File exist. \e[0m\n" | tee -a ${output}
fi

# Check if public_key file exists.
echo -e "\e[34m Checking if public_key file exists.\e[0m" | tee -a ${output}
if [ ! -f ${public_key} ]; then
  echo -e "\e[31m public_key is not available. \e[0m\n" | tee -a ${output}
  exit 2
else
  echo -e "\e[32m Key exist. \e[0m\n" | tee -a ${output}
fi

# Check sshpass command install or not.
which sshpass &>> ${output}
if [ $? -ne 0 ]; then
  echo -e "\e[34m Installing sshpass command \e[0m\n"
  yum install sshpass -y &>> ${output}
  echo -e "\e[32m Command Installed \e[0m\n"
fi

# Prompt user for SSH password
read -s -p "Enter ec2-user password: " ssh_password
echo
echo ""

# Copying public key to remote host.
for ip in $(cat "$servers"); do
  echo -e "\e[34m Copying SSH public key to $ip... \e[0m" | tee -a ${output}
  sshpass -p ${ssh_password} ssh-copy-id -i ${public_key} -o StrictHostKeyChecking=no ${user_name}@${ip} &>>  ${output}
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SSH public key copied successfully to $ip. \e[0m\n" | tee -a ${output}
  else
    echo -e "\e[31m Failed to copy SSH public key to $ip.\e[0m\n" | tee -a ${output}
  fi
done






