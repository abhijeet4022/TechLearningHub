#!/bin/bash
component=dispatch
source common.sh
rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo -e "\e[31mRabbitMQ password id missing please pass the password\e[0m"
  exit 1
fi

func_golang

