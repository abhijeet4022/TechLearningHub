#!/bin/bash

# Variable the will use while running the function.
component=payment
# Linking with common.sh file
source common.sh


rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo -e "\e[31mRabbitMQ password id missing please pass the password\e[0m"
  exit 1
fi


# Calling the nodejs function to be executed
func_python 





