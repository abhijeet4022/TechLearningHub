cp mongodb.repo /etc/yum.repos.d/
yum install mongodb-org -y
systemctl start mongod
# Need to change the ip from 127.0.0.1 to 0.0.0.0

systemctl enable mongod
systemctl restart mongod


