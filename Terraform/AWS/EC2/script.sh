#!/bin/bash
#<<-EOF  "-" This will help to fix the indentation this should be 1st line

#switch to root user
sudo su -

#Update the OS
yum update -y 

#install extra package
#yum install epel-release -y 
yum install vim* bash-completion wget unzip mariadb  -y 

#Install apache server
yum install httpd -y
systemctl start httpd
systemctl enable httpd 

#Download Website
wget -P /var/www/html https://www.free-css.com/assets/files/free-css-templates/download/page286/deni.zip

#unzip the file
unzip -o /var/www/html/deni.zip -d /var/www/html/

#copy the file from html directory to apache default directory
cp -Rf /var/www/html/html/* /var/www/html

systemctl restart httpd
##EOF
