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

# Removing the old Prechecks.
rm -rf ${pre_checks}

echo -e "\e[33m Creating the directory to save the prechecks. \e[0m\n" | tee -a ${output}
mkdir -p ${sharedrive}/${task}/${today_date}/${hostname} &>> "${output}"
func_exit_status


# Continue with precheck
echo -e "\e[34m ***** Pre checks for ${task}. ***** \e[0m\n" | tee -a ${pre_checks}


echo -e "\e[33m Capturing system hostname and date \e[0m\n" | tee -a ${pre_checks}
hostname &>> ${pre_checks}
ip addr show eth0 &>> ${pre_checks}
date &>> ${pre_checks}
func_exit_status

echo -e "\e[33m Checking the running services before ${task}. \e[0m\n" | tee -a ${pre_checks}
systemctl list-units --type=service &>> ${pre_checks}
systemctl list-units --type=service &>> /tmp/service_pre_check.txt
func_exit_status

echo -e "\e[33m Copying the /etc/hosts /etc/fstab files. \e[0m\n" | tee -a ${pre_checks}
cp /etc/hosts /etc/fstab ${sharedrive}/${task}/${today_date}/${hostname}
func_exit_status

echo -e "\e[33m Capturing the netstat output. \e[0m\n" | tee -a ${pre_checks}
netstat -ntulp  &>> ${pre_checks}
func_exit_status


##upto here
echo -e "\e[33m Capturing the available patches name. \e[0m\n" | tee -a ${pre_checks}
yum check-update --security &>> ${pre_checks}
func_exit_status

echo -e "\e[33m Capturing the current os version. \e[0m\n" | tee -a ${pre_checks}
cat /etc/*-release &>> ${pre_checks}
func_exit_status

echo -e "\e[33m Capturing the current kernel version. \e[0m\n" | tee -a ${pre_checks}
uname -rv &>> ${pre_checks}
func_exit_status

echo -e "\e[33m Capturing the uptime before patching \e[0m\n" | tee -a ${pre_checks}
uptime &>> ${pre_checks}
func_exit_status


echo -e "\e[32m ***  Pre_Checks has been completed please run the security-patching.sh script   *** \e[0m\n" | tee -a ${pre_checks}


