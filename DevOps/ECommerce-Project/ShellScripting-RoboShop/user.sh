#!/bin/bash
cp user.service /etc/systemd/system/
cp mongodb.repo /etc/yum.repos.d/
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs mongodb-org-shell -y
mkdir /user
curl -L -s -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
unzip -o /tmp/user.zip -d /user
npm install -C /user

useradd roboshop
systemctl daemon-reload
systemctl start user.service
systemctl enable user.service

mongo --host 127.0.0.1 </user/schema/catalogue.js

systemctl restart user.service
systemctl restart nginx
