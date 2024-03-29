#!/bin/bash
cp payment.service /etc/systemd/system/
yum install python36 gcc python3-devel -y
mkdir /app
curl -L -s -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
unzip -o  /tmp/payment.zip -d /app
pip3.6 install -r /app/requirements.txt
useradd roboshop
systemctl daemon-reload
systemctl enable payment
systemctl start payment