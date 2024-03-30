#!/bin/bash

echo -e "\e[33mCopying systemd file\e[om"
cp catalogue.service /etc/systemd/system/

echo -e "\e[33mCopying mongodb repo file file\e[om"
cp mongodb.repo /etc/yum.repos.d/

echo -e "\e[33mDisable current nodejs module \e[om"
dnf module disable nodejs -y

echo -e "\e[33mEnable nodejs:18 module\e[om"
dnf module enable nodejs:18 -y

echo -e "\e[33mInstalling NodeJS and MongoDB.\e[om"
dnf install nodejs mongodb-org-shell -y


echo -e "\e[33mRemoving Old Application directory.\e[om"
mkdir /app

echo -e "\e[33mCreating new application directory.\e[om"
mkdir /app

echo -e "\e[33mDownloading the application content.\e[om"
curl -L -s -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[33mUnzip the application directory.\e[om"
unzip -o /tmp/catalogue.zip -d /app

echo -e "\e[33mInstalling the application dependency.\e[om"
npm install -C /app

echo -e "\e[33mCreating Application User\e[om"
useradd roboshop

echo -e "\e[33mRealod the catalogue service.\e[om"
systemctl daemon-reload
systemctl start catalogue.service
systemctl enable catalogue.service

echo -e "\e[33mLoad the schema to mongodb.\e[om"
mongo --host mongodb.learntechnology.cloud </app/schema/catalogue.js

echo -e "\e[33mRestart the catalogue service.\e[om"
systemctl restart catalogue.service
