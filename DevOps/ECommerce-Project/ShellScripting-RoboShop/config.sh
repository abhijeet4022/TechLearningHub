#!/bin/bash
source common.sh
component=$1
if [ -z "${component}" ]; then
  echo "Please pass the component name as argument"
  exit 1
fi

echo "Install git."
yum install git bash-completion -y
func_exit_status

echo "Cloning the repo."
git clone https://github.com/abhijeet4022/TechLearningHub.git
func_exit_status

echo "Changing the directory."
cd TechLearningHub/DevOps/ECommerce-Project/ShellScripting-RoboShop/
func_exit_status

echo "Pulling the code."
git pull
func_exit_status

echo "Running the script."
sudo bash ${component}.sh



