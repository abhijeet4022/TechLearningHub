#!/bin/bash
git pull
if [ $(id -u) -ne 0 ]; then
  echo "You should run as root user"
  exit 1
fi


if [ -d /opt/node_exporter ]; then
  systemctl enable node_exporter
  systemctl start node_exporter
  echo -e "\e[1;32mNode Exporter already running\e[0m"
  exit 0
fi

#URL=$(curl -L -s https://prometheus.io/download/  | grep tar | grep node_exporter | grep linux-amd64  | sed -e "s|>| |g" -e 's|<| |g' -e 's|"| |g' |xargs -n1 | grep ^http | head -1)
#
#FILENAME=$(echo $URL | awk -F / '{print $NF}')
#DIRNAME=$(echo $FILENAME | sed -e 's/.tar.gz//')

echo -e "\e[1;32mCopying Service file\e[0m"
cp ./node_exporter.service /etc/systemd/system/node_exporter.service

#cd /opt
#curl -s -L -O $URL
#tar -xf $FILENAME
#rm -f $FILENAME
#mv $DIRNAME node_exporter

## Calling the disable_selinux.sh script to disable SELinux
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/disable_selinux.sh"

echo -e "\e[1;32mDownloading Node Exporter package\e[0m"
cd /opt
curl -s -L -O https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz

echo -e "\e[1;32mExtracting Node Exporter package\e[0m"
tar -xf node_exporter-1.10.2.linux-amd64.tar.gz
rm -rf node_exporter-1.10.2.linux-amd64.tar.gz
mv  node_exporter-1.10.2.linux-amd64 node_exporter

echo -e "\e[1;32mStarting Node Exporter service\e[0m"
systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter
if [ $? -eq 0 ]; then
  echo -e "\e[1;32mService Started file\e[0m"
else
  echo -e "\e[1;31mFailed to start the Service\e[0m"
fi