#!/bin/bash
component=$1
if [ -z "${component}" ]; then
  echo "Please pass the component name as argument"
  exit 1
fi
set-hostname ${component}
yum install git bash-completion -y
git clone https://github.com/abhijeet4022/TechLearningHub.git
cd TechLearningHub/DevOps/ECommerce-Project/ShellScripting-RoboShop/
git pull &>> /dev/null ; sudo bash ${component}.sh


