#!/bin/bash
source common.sh

echo -e "\n\e[33mConfiguring the erlang and rabbitmq repo.\e[0m" | tee -a $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $log
func_exit_status


echo -e "\n\e[33mInstalling the RabbitMQ Package.\e[0m" | tee -a $log
yum install rabbitmq-server -y &>> $log
func_exit_status

echo -e "\n\e[33mRestarting the rabbitmq-server.\e[0m" | tee -a $log
systemctl enable rabbitmq-server &>> $log
systemctl restart rabbitmq-server &>> $log
func_exit_status

echo -e "\n\e[33mAdding user and password.\e[0m" | tee -a $log
if  rabbitmqctl list_users | grep -i roboshop ; then
  echo "user exist"
else
  rabbitmqctl add_user roboshop roboshop123 &>> /dev/null
fi
func_exit_status


echo -e "\n\e[33mSetting the permissions.\e[0m" | tee -a $log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log
func_exit_status



