#!/bin/bash
component=$1
if [ -z "${component}" ]; then
  echo "Please pass the component name as argument"
  exit 1
fi
sudo set-hostname ${component}   &>> /dev/null
sudo yum install git bash-completion -y &>> /dev/null
git clone https://github.com/abhijeet4022/TechLearningHub.git &>> /dev/null
cd TechLearningHub/DevOps/ECommerce-Project/ShellScripting-RoboShop/
git pull &>> /dev/null ; sudo bash ${component}.sh


