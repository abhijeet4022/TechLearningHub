#!/bin/bash
sudo su -
yum update -y 
yum install vim* bash-completion wget unzip mariadb  -y     
yum install httpd -y
systemctl start httpd
systemctl enable httpd     
wget -P /var/www/html https://www.free-css.com/assets/files/free-css-templates/download/page286/deni.zip    
unzip -o /var/www/html/deni.zip -d /var/www/html/    
cp -Rf /var/www/html/html/* /var/www/html    
systemctl restart httpd
