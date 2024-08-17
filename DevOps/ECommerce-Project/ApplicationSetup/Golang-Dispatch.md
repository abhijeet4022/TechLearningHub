# 11-Dispatch
# Dispatch is the service which dispatches the product after purchase. It is written in GoLang, So wanted to install GoLang.

# Developer has chosen GoLang, Check with developer which version of GoLang is needed.

# Install GoLang

    dnf install golang -y

# Configure the application.
# Add application User
    useradd roboshop
# Lets setup an app directory.
    mkdir /app
# Download the application code to created app directory.
    curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
    unzip -o /tmp/dispatch.zip -d /app
# Lets download the dependencies & build the software.
    cd /app
    go mod init dispatch
    go get
    go build
# We need to setup a new service in systemd so systemctl can manage this service
# Setup SystemD Payment Service

vim /etc/systemd/system/dispatch.service
[Unit]
Description = Dispatch Service
[Service]
User=roboshop
Environment=AMQP_HOST=RABBITMQ-IP
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target

# Load the service.
    systemctl daemon-reload
# Start the service.

    systemctl enable dispatch
    systemctl start dispatch