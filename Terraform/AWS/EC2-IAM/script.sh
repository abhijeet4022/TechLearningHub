#!/bin/bash
#<<-EOF  "-" This will help to fix the indentation this should be 1st line

#switch to root user
#sudo su -

#Update the OS
sudo yum update -y 

#install extra package
#yum install epel-release -y 
sudo yum install vim* bash-completion wget unzip mariadb  -y 

#Install apache server
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd 

#Download Website
sudo wget -P /var/www/html https://www.free-css.com/assets/files/free-css-templates/download/page286/deni.zip

#unzip the file
sudo unzip -o /var/www/html/deni.zip -d /var/www/html/

#copy the file from html directory to apache default directory
sudo cp -Rf /var/www/html/html/* /var/www/html

sudo systemctl restart httpd
##EOF
