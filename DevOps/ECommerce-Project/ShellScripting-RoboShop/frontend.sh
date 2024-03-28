#!/bin/bash
yum install nginx -y
cp roboshop.conf /etc/nginx/default.d/
rm -rf /usr/share/nginx/html/*
curl -L -s -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
unzip -o /tmp/frontend.zip -d /usr/share/nginx/html/
systemctl enable nginx
systemctl restart nginx
