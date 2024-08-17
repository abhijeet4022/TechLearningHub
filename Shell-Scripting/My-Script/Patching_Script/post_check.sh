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


rm -rf ${post_checks} &>> /dev/null


# Post Checks
echo -e "\e[34m Performing the Post Check after ${task}\e[0m\n" | tee -a ${post_checks}

echo -e "\e[33m Capturing system hostname and date \e[0m\n" | tee -a ${post_checks}
mount ${sharedrive}
hostname &>> ${post_checks}
date &>> ${post_checks}
func_exit_status

echo -e "\e[33m Capturing the running services after ${task}\e[0m\n" | tee -a ${post_checks}
systemctl list-units --type=service &>> ${post_checks}
systemctl list-units --type=service &>> /tmp/service_post_check.txt
func_exit_status

echo -e "\e[33m Capturing the netstat output. \e[0m\n" | tee -a ${post_checks}
netstat -ntulp  &>> ${post_checks}
func_exit_status

echo -e "\e[33m Capturing the kernel version after ${task}\e[0m\n" | tee -a ${post_checks}
cat /etc/*-release &>> ${post_checks}
uname -rv &>> ${post_checks}
func_exit_status

echo -e "\e[33m Capturing the recent patches updates. \e[0m\n" | tee -a ${post_checks}
rpm -qa --last | head -15 &>> ${post_checks}
func_exit_status

echo -e "\e[33m Capturing the uptime after patching \e[0m\n" | tee -a ${post_checks}
uptime &>> ${post_checks}
func_exit_status



echo -e "\e[32m *** Post_Check Completed *** \e[0m\n" | tee -a ${post_checks}


