# Variable defined
log=/tmp/roboshop.log

func_exit_status(){
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILED \e[0m"
  fi 
}

# Creating systemd function to deal the services.
func_systemd(){

echo -e "\n\e[33mRealod the ${component} service.\e[0m" | tee -a $log
systemctl daemon-reload &>> $log
systemctl start ${component}.service &>> $log
systemctl enable ${component}.service &>> $log
func_exit_status

}



# Application pre requisites.
func_appprereq() {

echo -e "\n\e[33mCopying systemd file.\e[0m" | tee -a $log
cp ${component}.service /etc/systemd/system/ &>> $log
func_exit_status

echo -e "\n\e[33mRemoving Old Application directory.\e[0m" | tee -a $log
rm -rf /app &>> $log
func_exit_status

echo -e "\n\e[33mCreating new application directory.\e[0m" | tee -a $log
mkdir /app &>> $log
func_exit_status

echo -e "\n\e[33mDownloading the application content.\e[0m" | tee -a $log
curl -L -s -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> $log
func_exit_status

echo -e "\n\e[33mUnzip the application directory.\e[0m" | tee -a $log
unzip -o /tmp/${component}.zip -d /app &>> $log
func_exit_status

echo -e "\n\e[33mCreating Application User.\e[0m" | tee -a $log
if id roboshop &>/dev/null; then
    echo -e "\e[32mUser 'roboshop' already exists.\e[0m"
else
    useradd -m roboshop &>> $log
    func_exit_status
fi

}


func_schema_setup() {

if [ "${schema_type}" == "mongodb" ]; then
echo -e "\n\e[33mLoad the schema to mongodb.\e[0m" | tee -a $log
mongo --host mongodb.learntechnology.cloud </app/schema/${component}.js &>> $log
func_exit_status
fi

if [ "${schema_type}" == "mysql" ]; then
echo -e "\n\e[33mLoad the schema to mongodb.\e[0m" | tee -a $log
mysql -h mysql.learntechnology.cloud -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>> $log
func_exit_status
fi

}




# Frontend Setup
func_frontend() {
  
echo -e "\n\e[33mInstalling the Nginx.\e[0m" | tee -a $log
yum install nginx -y &>> $log
func_exit_status

echo -e "\n\e[33mCopying reverse proxy file.\e[0m" | tee -a $log
cp roboshop.conf /etc/nginx/default.d/ &>> $log
func_exit_status

echo -e "\n\e[33mRemoving default nginx content.\e[0m" | tee -a $log
rm -rf /usr/share/nginx/html/* &>> $log
func_exit_status

echo -e "\n\e[33mDownloading the frontend content.\e[0m" | tee -a $log
curl -L -s -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> $log
func_exit_status

echo -e "\n\e[33mUnziping the the frontend content.\e[0m" | tee -a $log
unzip -o /tmp/${component}.zip -d /usr/share/nginx/html/ &>> $log
func_exit_status

echo -e "\n\e[33mRestarting the Nginx Service.\e[0m" | tee -a $log
systemctl enable nginx &>> $log
systemctl restart nginx &>> $log
func_exit_status

}





# Creating the function for Catalogue, User $ Cart Services.
func_nodejs() {

echo -e "\n\e[33mCopying mongodb repo file file.\e[0m" | tee -a $log
cp mongodb.repo /etc/yum.repos.d/ &>> $log
func_exit_status

echo -e "\n\e[33mDisable current nodejs module.\e[0m" | tee -a $log
dnf module disable nodejs -y &>> $log
func_exit_status

echo -e "\n\e[33mEnable nodejs:18 module.\e[0m" | tee -a $log
dnf module enable nodejs:18 -y &>> $log
func_exit_status

echo -e "\n\e[33mInstalling NodeJS and MongoDB.\e[0m" | tee -a $log
dnf install nodejs mongodb-org-shell -y &>> $log
func_exit_status

func_appprereq

echo -e "\n\e[33mInstalling the application dependency.\e[0m" | tee -a $log
npm install -C /app &>> $log
func_exit_status


func_schema_setup
func_systemd

}




# Creating the function for Shipping Service.
func_java() {
echo -e "\n\e[33mInstalling the Maven and MySql.\e[0m" | tee -a $log
yum install maven mysql -y &>> $log
func_exit_status

func_appprereq

echo -e "\n\e[33mDownloading Dependencies and making artifact.\e[0m" | tee -a $log
mvn clean package -f /app/pom.xml &>> $log
mv /app/target/${component}-1.0.jar /app/${component}.jar &>> $log
func_exit_status

func_schema_setup
func_systemd

}




# Creating function for Payment service.
func_python() {

echo -e "\n\e[33mInstalling the Python package.\e[0m" | tee -a $log
yum install python36 gcc python3-devel -y &>> $log
func_exit_status

func_appprereq

sed -i.backup "s/rabbitmq_app_password/${rabbitmq_app_password}/" /etc/systemd/system/${component}.service

echo -e "\n\e[33mDownloading the dependency.\e[0m" | tee -a $log
pip3.6 install -r /app/requirements.txt &>> $log
func_exit_status

func_systemd

}



# Creating function for Dispatch service.
func_golang(){

echo -e "\n\e[33mInstalling the golang package.\e[0m" | tee -a $log
dnf install golang -y &>> $log
func_exit_status

func_appprereq
sed -i.backup "s/rabbitmq_app_password/${rabbitmq_app_password}/" /etc/systemd/system/${component}.service

echo -e "\n\e[33mDownloading the application dependency and creating artifact.\e[0m" | tee -a $log
cd /app &>> $log
go mod init ${component} &>> $log
go get &>> $log
go build &>> $log
func_exit_status

func_systemd

}