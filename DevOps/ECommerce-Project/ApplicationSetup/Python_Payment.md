# 10-Payment
# This service is responsible for payments in RoboShop e-commerce app. This service is written on Python 3.6, So need it to run this app.

# HINT: Developer has chosen Python, Check with developer which version of Python is needed.

# Install Python 3.6
    dnf install python36 gcc python3-devel -y

# Configure the application.
# INFO: Our application developed by the developer of our org and it is not having any RPM software just like other softwares. So we need to configure every step manually

# Add application User
    useradd roboshop
# Lets setup an app directory.
    mkdir /app

# Download the application code to created app directory.

    curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
    unzip -o /tmp/payment.zip -d /app


# Download the dependencies.
    cd /app
    pip3.6 install -r requirements.txt

# We need to setup a new service in systemd so systemctl can manage this service
# Setup SystemD Payment Service

vim /etc/systemd/system/payment.service
[Unit]
Description=Payment Service

[Service]
User=root
WorkingDirectory=/app
Environment=CART_HOST=<CART-SERVER-IPADDRESS>
Environment=CART_PORT=8080
Environment=USER_HOST=<USER-SERVER-IPADDRESS>
Environment=USER_PORT=8080
Environment=AMQP_HOST=<RABBITMQ-SERVER-IPADDRESS>
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123

ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 $MAINPID
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target

# Load the service.
    systemctl daemon-reload
# Start the service.

    systemctl enable payment
    systemctl start payment