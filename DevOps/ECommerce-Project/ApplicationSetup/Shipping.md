# 08-Shipping
# Shipping service is responsible for finding the distance of the package to be shipped and calculate the price based on that.

# Shipping service is written in Java, Hence we need to install Java.

# Maven is a Java Packaging software, Hence we are going to install maven, This indeed takes care of java installation.

# HINT: Developer has chosen Maven, Check with developer which version of Maven is needed. Here for our requirement java >= 1.8 & maven >=3.5 should work.

    dnf install maven -y

# Configure the application.

# INFO: Our application developed by the developer of our org and it is not having any RPM software just like other softwares. So we need to configure every step manually
# Add application User

    useradd roboshop

# INFO: User roboshop is a function / daemon user to run the application. Apart from that we dont use this user to login to server.

# We keep application in one standard location. This is a usual practice that runs in the organization.

# Lets setup an app directory.

    mkdir /app

# Download the application code to created app directory.

    curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
    unzip -o /tmp/shipping.zip -d /app

# Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.

# Lets download the dependencies & build the application

    cd /app
    mvn clean package
    mv target/shipping-1.0.jar shipping.jar

# We need to setup a new service in systemd so systemctl can manage this service

# INFO: We already discussed in linux basics that advantages of systemctl managing services, Hence we are taking that approach. Which is also a standard way in the OS.

# Setup SystemD Shipping Service

vim /etc/systemd/system/shipping.service
[Unit]
Description=Shipping Service

[Service]
User=roboshop
Environment=CART_ENDPOINT=<CART-SERVER-IPADDRESS>:8080
Environment=DB_HOST=<MYSQL-SERVER-IPADDRESS>
ExecStart=/bin/java -jar /app/shipping.jar
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target


# INFO: Hint! You can create file by using vim /etc/systemd/system/shipping.service

# Load the service.

    systemctl daemon-reload

# INFO: This above command is because we added a new service, We are telling systemd to reload so it will detect new service.

# Start the service.

    systemctl enable shipping
    systemctl start shipping

# For this application to work fully functional we need to load schema to the Database.

# INFO : Schemas are usually part of application code and developer will provide them as part of development.

# We need to load the schema. To load schema we need to install mysql client.

# To have it installed we can use

    dnf install mysql -y

# Load Schema, This also includes the master data of all the countries and their cities with distance to those cities.

    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql


# This service needs a restart because it is dependent on schema, After loading schema only it will work as expected, Hence we are restarting this service. This

    systemctl restart shipping