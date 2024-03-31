#!/bin/bash
mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31m Input password missing.\e[0m"
  exit 1
fi


source common.sh

echo -e "\n\e[33mConfiguring Repo for MySQL 5.\e[0m" | tee -a $log
cp mysql.repo /etc/yum.repos.d/ &>> $log
func_exit_status


echo -e "\n\e[33mDisable existing mysql.\e[0m" | tee -a $log
dnf module disable mysql -y &>> $log
func_exit_status


echo -e "\n\e[33mInstalling Mysql-community-server package.\e[0m" | tee -a $log
yum install mysql-community-server -y &>> $log
func_exit_status


echo -e "\n\e[33mResetting mysql root password.\e[0m" | tee -a $log
mysql_secure_installation --set-root-pass "${mysql_root_password}"
func_exit_status


echo -e "\n\e[33mRestarting the mysqld service.\e[0m" | tee -a $log
systemctl enable mysqld &>> $log
systemctl restart mysqld &>> $log
func_exit_status
