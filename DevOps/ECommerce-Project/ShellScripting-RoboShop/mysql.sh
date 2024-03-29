#!/bin/bash
cp mysql.repo /etc/yum.repos.d/
dnf module disable mysql -y
yum install mysql-community-server -y
systemctl start mysqld
mysql_secure_installation --set-root-pass RoboShop@1
systemctl enable mysqld
systemctl restart mysqld

