#!/bin/bash
source common.sh

echo -e "\n\e[33mResetting mysql root password.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $log
func_exit_status


echo -e "\n\e[33mResetting mysql root password.\e[0m" | tee -a $log
yum install rabbitmq-server -y &>> $log
func_exit_status

echo -e "\n\e[33mResetting mysql root password.\e[0m" | tee -a $log
systemctl enable rabbitmq-server &>> $log
systemctl restart rabbitmq-server &>> $log
func_exit_status

echo -e "\n\e[33mResetting mysql root password.\e[0m" | tee -a $log
rabbitmqctl add_user roboshop roboshop123 &>> $log
func_exit_status

echo -e "\n\e[33mResetting mysql root password.\e[0m" | tee -a $log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log
func_exit_status



