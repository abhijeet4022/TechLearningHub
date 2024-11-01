#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "You should run as root user"
  exit 1
fi

if [ -d /opt/node_exporter ]; then
  systemctl enable node_exporter
  systemctl start node_exporter
  exit 0
fi

URL=$(curl -L -s https://prometheus.io/download/  | grep tar | grep node_exporter | grep linux-amd64  | sed -e "s|>| |g" -e 's|<| |g' -e 's|"| |g' |xargs -n1 | grep ^http | head -1)

FILENAME=$(echo $URL | awk -F / '{print $NF}')
DIRNAME=$(echo $FILENAME | sed -e 's/.tar.gz//')

echo -e "\e[1;32mCopying Service file\e[0m"
cp ./prometheus.service /etc/systemd/system/node_exporter.service

cd /opt
curl -s -L -O $URL
tar -xf $FILENAME
rm -f $FILENAME
mv $DIRNAME node_exporter


systemctl enable node_exporter
systemctl restart node_exporter
if [ $? -eq 0 ]; then
  echo -e "\e[1;32mService Started file\e[0m"
else
  echo -e "\e[1;31mFailed to start the Service\e[0m"
fi