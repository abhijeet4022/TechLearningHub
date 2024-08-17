#!/bin/bash
# All Variables
sharedrive=/mnt/syslog17logs
today_date=$(date +"%d-%m-%y")
hostname=$(hostname)
task=patching
log=/tmp/patching_output.txt
output=/tmp/mountdrive.txt
pre_checks=${sharedrive}/${task}/${today_date}/${hostname}/"${hostname}_pre_check_${today_date}.txt"
post_checks=${sharedrive}/${task}/${today_date}/${hostname}/"${hostname}_post_check_${today_date}.txt"

# Command Status.
func_exit_status(){
  if [ $? -eq 0 ]; then
    echo -e "\e[32m Success \e[0m\n"
  else
    echo -e "\e[31m Failed \e[0m\n"
  fi
}


echo -e "\e[34m Updating the security patches. \e[0m\n" | tee -a ${log}

echo -e "\e[33m Removing old caches \e[0m\n" | tee -a ${log}
yum clean all &>> ${log}
func_exit_status

echo -e "\e[33m Updating the security ${task}\e[0m\n" | tee -a ${log}
yum update --security -y &>> ${log}
if [ $? -eq 0 ]; then
    echo -e "\e[32m Security update has been completed please reboot the system \e[0m\n"
  else
    echo -e "\e[31m Security update has been failed. \e[0m\n"
fi

