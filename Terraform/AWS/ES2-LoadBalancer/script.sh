#!/bin/bash
# Update package lists and install necessary tools and software
sudo yum -y update
sudo yum -y install net-tools httpd
systemctl restart httpd
systemctl enable httpd
# Get the private IP address of the instance
#MYIP=$(hostname -I | awk '{print $1}')
MYIP=$(hostname -I)
# Create a simple HTML page with the instance's IP address
echo "This is: $MYIP" > /var/www/html/index.html
systemctl restart httpd


# #!/bin/bash
# sudo su -
# yum update -y 
# yum install vim* bash-completion wget unzip mariadb  -y     
# yum install httpd -y
# systemctl start httpd
# systemctl enable httpd     
# wget -P /var/www/html https://www.free-css.com/assets/files/free-css-templates/download/page286/deni.zip    
# unzip -o /var/www/html/deni.zip -d /var/www/html/    
# cp -Rf /var/www/html/html/* /var/www/html    
# systemctl restart httpd
