#!/bin/bash
git pull &> /tmp/grafana.log

echo -e "\e[1;32mConfiguring Repo\e[0m"
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF


echo -e "\e[1;32mInstalling Grafana\e[0m"
yum install grafana -y &>> /tmp/grafana.log


systemctl enable grafana-server &>> /tmp/grafana.log
systemctl restart grafana-server &>> /tmp/grafana.log
if [ $? -eq 0 ]; then
  echo -e "\e[1;32mService Started file\e[0m"
else
  echo -e "\e[1;31mFailed to start the Service\e[0m"
fi