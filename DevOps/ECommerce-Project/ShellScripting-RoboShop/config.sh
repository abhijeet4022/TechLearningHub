#!/bin/bash
source common.sh
component=$1
if [ -z "${component}" ]; then
  echo "Please pass the component name as argument"
  exit 1
fi

echo "Install git."
yum install git bash-completion -y &>> $log
func_exit_status

if [ ! -d /home/centos/TechLearningHub ]; then
  echo "Cloning the repo."
  git clone https://github.com/abhijeet4022/TechLearningHub.git &>> $log
  func_exit_status
else
  echo -e "\e[32mDirectory exist\e[0m"
fi


echo "Changing the directory."
cd TechLearningHub/DevOps/ECommerce-Project/ShellScripting-RoboShop/ &>> $log
func_exit_status

echo "Pulling the code."
git pull &>> $log
func_exit_status

echo "Running the script."
sudo bash ${component}.sh



