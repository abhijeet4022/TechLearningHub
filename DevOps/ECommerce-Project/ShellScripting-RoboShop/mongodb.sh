#!/bin/bash
source common.sh

echo -e "\n\e[33mCopying repo file.\e[0m" | tee -a $log
cp mongodb.repo /etc/yum.repos.d/ &>> $log
func_exit_status

echo -e "\n\e[33mInstalling mongodb-org.\e[0m" | tee -a $log
yum install mongodb-org -y &>> $log
func_exit_status

echo -e "\n\e[33mChanging mondodb config from localhost to internet.\e[0m" | tee -a $log
sed -i.backup '27 s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf &>> $log
func_exit_status

echo -e "\n\e[33mRestarting the mongod service.\e[0m" | tee -a $log
systemctl enable mongod &>> $log
systemctl restart mongod &>> $log
func_exit_status








