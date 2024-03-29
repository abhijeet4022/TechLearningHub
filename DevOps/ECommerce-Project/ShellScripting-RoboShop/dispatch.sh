#!/bin/bash
cp dispatch.service /etc/systemd/system
dnf install golang -y
mkdir /app
curl -L -s -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
unzip -o /tmp/dispatch.zip -d /app
cd /app
go mod init dispatch
go get
go build
useradd roboshop
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch