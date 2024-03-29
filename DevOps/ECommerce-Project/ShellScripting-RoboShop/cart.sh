#!/bin/bash
cp cart.service /etc/systemd/system/
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs  -y
mkdir /app
curl -L -s -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
unzip -o /tmp/cart.zip -d /app
npm install -C /app

useradd roboshop
systemctl daemon-reload
systemctl start cart.service
systemctl enable cart.service

systemctl restart cart.service


