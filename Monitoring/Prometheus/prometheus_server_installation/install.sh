#!/bin/bash

echo -e "\e[1;32mUpdating the script\e[0m"
git pull
if [ $(id -u) -ne 0 ]; then
  echo "You should run as root user"
  exit 1
fi

echo -e "\e[1;32mRemoving old Prometheus installation if any\e[0m"
if [ -d /opt/prometheus ]; then
  systemctl stop prometheus
  rm -rf /opt/prometheus /etc/systemd/system/prometheus.service
fi

# URL=$(curl -L -s https://prometheus.io/download/  | grep tar | grep prometheus- | grep linux-amd64  | sed -e "s|>| |g" -e 's|<| |g' -e 's|"| |g' |xargs -n1 | grep ^http | tail -1)
#URL=$(https://github.com/prometheus/prometheus/releases/download/v3.9.1/prometheus-3.9.1.linux-amd64.tar.gz)
#FILENAME=$(echo $URL | awk -F / '{print $NF}')
#DIRNAME=$(echo $FILENAME | sed -e 's/.tar.gz//')

echo -e "\e[1;32mCopying Prometheus service file\e[0m"
cp ./prometheus.service /etc/systemd/system/prometheus.service

#cd /opt
#curl -L -s -O https://github.com/prometheus/prometheus/releases/download/v3.9.1/prometheus-3.9.1.linux-amd64.tar.gz
#curl -s -L -O $URL
#tar -xf $FILENAME
#rm -f $FILENAME
#mv $DIRNAME prometheus

echo -e "\e[1;32mChange Prometheus directories\e[0m"
cd /opt

echo -e "\e[1;32mDownload Prometheus package\e[0m"
curl -L -s -O https://github.com/prometheus/prometheus/releases/download/v3.9.1/prometheus-3.9.1.linux-amd64.tar.gz

echo -e "\e[1;32mExtracting Prometheus package\e[0m"
tar -xf  prometheus-3.9.1.linux-amd64.tar.gz

echo -e "\e[1;32mCleaning up\e[0m"
rm -rf prometheus-3.9.1.linux-amd64.tar.gz

echo -e "\e[1;32mRenaming Prometheus directory\e[0m"
mv prometheus-3.9.1.linux-amd64 prometheus

## Calling the disable_selinux.sh script to disable SELinux
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/disable_selinux.sh"

echo -e "\e[1;32mStarting Prometheus service\e[0m"
systemctl enable prometheus
systemctl restart prometheus
if [ $? -eq 0 ]; then
  echo "Service started"
else
  echo "Failed to start the Service"
fi