# 05-User
# User is a microservice that is responsible for User Logins and Registrations Service in RobotShop e-commerce portal.
# HINT: Developer has chosen NodeJs, Check with developer which version of NodeJS is needed. Developer has set a context that it can work with NodeJS >18

# Install NodeJS, By default NodeJS 10 is available, We would like to enable 18 version and install list.

# HINT: You can list modules by using dnf module list

    dnf module disable nodejs -y
    dnf module enable nodejs:18 -y

# Install NodeJS

    dnf install nodejs -y

# Configure the application. Here
# INFO: Our application developed by the user is not having any RPM software just like other softwares. So we need to configure every step manually

# RECAP : We already discussed in Linux basics section that applications should run as nonroot user.

# Add application User

    useradd roboshop

# INFO: User roboshop is a function / daemon user to run the application. Apart from that we dont use this user to login to server.

# Also, username roboshop has been picked because it more suits to our project name.

# INFO: We keep application in one standard location. This is a usual practice that runs in the organization.

# Lets setup an app directory.

    mkdir /app

# Download the application code to created app directory.

    curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
    unzip -o /tmp/user.zip -d /app

# Every application is developed by development team will have some common softwares that they use as libraries. This application also have the same way of defined dependencies in the application configuration.

# Lets download the dependencies.

    cd /app
    npm install

# We need to setup a new service in systemd so systemctl can manage this service

# INFO: We already discussed in linux basics that advantages of systemctl managing services, Hence we are taking that approach. Which is also a standard way in the OS.

# Setup SystemD User Service

vim /etc/systemd/system/user.service
[Unit]
Description = User Service
[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=<REDIS-SERVER-IP>
Environment=MONGO_URL="mongodb://<MONGODB-SERVER-IP-ADDRESS>:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target

# :::hint RECAP You can create file by using vim /etc/systemd/system/user.service :::

# Load the service.

    systemctl daemon-reload

# INFO: This above command is because we added a new service, We are telling systemd to reload so it will detect new service.

# Start the service.

    systemctl enable user
    systemctl start user