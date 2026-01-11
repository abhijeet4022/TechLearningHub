#!/bin/bash
git pull
if [ $(id -u) -ne 0 ]; then
  echo "You should run as root user"
  exit 1
fi

if [ -d /opt/prometheus ]; then
  systemctl stop prometheus
  rm -rf /opt/prometheus /etc/systemd/system/prometheus.service
fi

# URL=$(curl -L -s https://prometheus.io/download/  | grep tar | grep prometheus- | grep linux-amd64  | sed -e "s|>| |g" -e 's|<| |g' -e 's|"| |g' |xargs -n1 | grep ^http | tail -1)
#URL=$(https://github.com/prometheus/prometheus/releases/download/v3.9.1/prometheus-3.9.1.linux-amd64.tar.gz)
#FILENAME=$(echo $URL | awk -F / '{print $NF}')
#DIRNAME=$(echo $FILENAME | sed -e 's/.tar.gz//')

cp ./prometheus.service /etc/systemd/system/prometheus.service

#cd /opt
#curl -L -s -O https://github.com/prometheus/prometheus/releases/download/v3.9.1/prometheus-3.9.1.linux-amd64.tar.gz
#curl -s -L -O $URL
#tar -xf $FILENAME
#rm -f $FILENAME
#mv $DIRNAME prometheus

cd /opt
curl -L -s -O https://github.com/prometheus/prometheus/releases/download/v3.9.1/prometheus-3.9.1.linux-amd64.tar.gz
tar -xf  prometheus-3.9.1.linux-amd64.tar.gz
rm -rf prometheus-3.9.1.linux-amd64.tar.gz
mv prometheus-3.9.1.linux-amd64 prometheus


systemctl enable prometheus
systemctl restart prometheus
if [ $? -eq 0 ]; then
  echo "Service started"
else
  echo "Failed to start the Service"
fi