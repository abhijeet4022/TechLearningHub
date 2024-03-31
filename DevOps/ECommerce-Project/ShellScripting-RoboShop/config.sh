#!/bin/bash
source common.sh
component=$1
if [ -z "${component}" ]; then
  echo "Please pass the component name as argument"
  exit 1
fi

echo -e "\e[33mInstalling git\e[0m."
yum install git bash-completion -y &>> $log
func_exit_status

echo -e "\e[33mCloning the repo.\e[0m."
if [ ! -d /home/centos/TechLearningHub ]; then
  git clone https://github.com/abhijeet4022/TechLearningHub.git &>> $log
  func_exit_status
else
  echo -e "\e[32mDirectory exist\e[0m"
fi

echo -e "\e[33mChanging the directory.\e[0m."
cd TechLearningHub/DevOps/ECommerce-Project/ShellScripting-RoboShop/ &>> $log
func_exit_status

echo -e "\e[33mPulling the code.\e[0m."
git pull &>> $log
func_exit_status

echo -e "\e[33mRunning the main script.\e[0m."
sudo bash ${component}.sh



