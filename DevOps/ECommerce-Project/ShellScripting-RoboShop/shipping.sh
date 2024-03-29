#!/bin/bash
cp shipping.service /etc/systemd/system/
yum install maven mysql -y
mkdir /app
curl -L -s -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
unzip -o /tmp/shipping.zip -d /app
mvn clean package -f /app/pom.xml
mv /app/target/shipping-1.0.jar /app/shipping.jar
useradd roboshop
systemctl daemon-reload
systemctl start shipping
systemctl enable shipping

mysql -h mysql.learntechnology.cloud -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping



