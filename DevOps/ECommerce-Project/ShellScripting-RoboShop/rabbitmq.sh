#!/bin/bash
source common.sh
rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo -e "\e[31mRabbitMQ password id missing please pass the password\e[0m"
  exit 1
fi

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

# rabbitmqctl delete_user roboshop
echo -e "\n\e[33mAdding user and password.\e[0m" | tee -a $log
if  rabbitmqctl list_users | grep -i roboshop &>> $log ; then
  echo -e "\e[32mUser already exist\e[0m"
else
  rabbitmqctl add_user roboshop ${rabbitmq_app_password} &>> $log
  func_exit_status
fi


echo -e "\n\e[33mSetting the permissions.\e[0m" | tee -a $log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log
func_exit_status



