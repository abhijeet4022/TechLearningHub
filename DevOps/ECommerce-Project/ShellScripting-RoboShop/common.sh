log=/tmp/roboshop.log

func_nodejs() {

echo -e "\e[33mCopying systemd file\e[0m\n" | tee -a $log
cp ${component}.service /etc/systemd/system/ &>> $log

echo -e "\e[33mCopying mongodb repo file file\e[0m\n" | tee -a $log
cp mongodb.repo /etc/yum.repos.d/ &>> $log

echo -e "\e[33mDisable current nodejs module \e[0m\n" | tee -a $log
dnf module disable nodejs -y &>> $log

echo -e "\e[33mEnable nodejs:18 module\e[0m\n" | tee -a $log
dnf module enable nodejs:18 -y &>> $log

echo -e "\e[33mInstalling NodeJS and MongoDB.\e[0m\n" | tee -a $log
dnf install nodejs mongodb-org-shell -y &>> $log

echo -e "\e[33mRemoving Old Application directory.\e[0m\n" | tee -a $log
rm -rf /app &>> $log

echo -e "\e[33mCreating new application directory.\e[0m\n" | tee -a $log
mkdir /app &>> $log

echo -e "\e[33mDownloading the application content.\e[0m\n" | tee -a $log
curl -L -s -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> $log

echo -e "\e[33mUnzip the application directory.\e[0m\n" | tee -a $log
unzip -o /tmp/${component}.zip -d /app &>> $log

echo -e "\e[33mInstalling the application dependency.\e[0m\n" | tee -a $log
npm install -C /app &>> $log

echo -e "\e[33mCreating Application User\e[0m\n" | tee -a $log
if id roboshop &>/dev/null; then
    echo -e "\e[32mUser 'roboshop' already exists.\e[0m\n"
else
    useradd -m roboshop &>> $log
fi

echo -e "\e[33mRealod the ${component} service.\e[0m\n" | tee -a $log
systemctl daemon-reload &>> $log
systemctl start ${component}.service &>> $log
systemctl enable ${component}.service &>> $log

echo -e "\e[33mLoad the schema to mongodb.\e[0m\n" | tee -a $log
mongo --host mongodb.learntechnology.cloud </app/schema/${component}.js &>> $log

echo -e "\e[33mRestart the ${component} service.\e[0m\n" | tee -a $log
systemctl restart ${component}.service &>> $log

}