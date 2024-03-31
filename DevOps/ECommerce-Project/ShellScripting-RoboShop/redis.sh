#!/bin/bash
source common.sh

echo -e "\n\e[33mConfiguring the remi repo.\e[0m" | tee -a $log
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $log
func_exit_status

echo -e "\n\e[33mEnable the redis:remi-6.2.\e[0m" | tee -a $log
dnf  module enable redis:remi-6.2 -y &>> $log
func_exit_status

echo -e "\n\e[33mInstalling redis.\e[0m" | tee -a $log
yum install redis -y &>> $log
func_exit_status

echo -e "\n\e[33mChanging redis config from localhost to internet.\e[0m" | tee -a $log
sed -i.backup '75 s/bind 127.0.0.1/bind 0.0.0.0/'   /etc/redis.conf /etc/redis/redis.conf &>> $log
func_exit_status

echo -e "\n\e[33mRestarting the redis service.\e[0m" | tee -a $log
systemctl enable redis &>> $log
systemctl restart redis &>> $log
func_exit_status




