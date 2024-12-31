#!/bin/bash
sudo apt-get update -y
cd /usr/local/bin
curl -LO https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64
mv kops-linux-amd64 kops
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod 777 kops
chmod  777 kubectl

cat <<EOF | tee -a ~/.bashrc
export NAME=learntechnology.cloud
export KOPS_STATE_STORE=s3://learntechnology.cloud
export AWS_REGION=us-east-1
export CLUSTER_NAME=learntechnology.cloud
export EDITOR='/usr/bin/vim'
alias k=kubectl
EOF


source ~/.bashrc

# ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa