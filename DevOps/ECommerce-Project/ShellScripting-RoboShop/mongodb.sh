cp mongodb.repo /etc/yum.repos.d/
yum install mongodb-org -y
systemctl start mongod
sed -i.backup '27 s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
systemctl enable mongod
systemctl restart mongod


