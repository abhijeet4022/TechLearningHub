#!/bin/bash
cp catalogue.service /etc/systemd/system/
cp mongodb.repo /etc/yum.repos.d/
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs mongodb-org-shell -y
mkdir /app
curl -L -s -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
unzip -o /tmp/catalogue.zip -d /app
npm install -C /app

useradd roboshop
systemctl daemon-reload
systemctl start catalogue.service
systemctl enable catalogue.service

mongo --host mongodb.learntechnology.cloud </app/schema/catalogue.js

systemctl restart catalogue.service
