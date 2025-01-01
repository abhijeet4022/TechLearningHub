#!/bin/bash

# Log file
LOG_FILE="/tmp/userdata.log"
CLUSTER_NAME="learntechnology.cloud"
KOPS_STATE_STORE="s3://cluster.learntechnology.cloud"

# Exit on any error
#set -e


# Update system
sudo apt-get update -y &>> ${LOG_FILE}

# Download and install kops
echo "Installing kops..." | tee -a ${LOG_FILE}
curl -Lo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64 &>> ${LOG_FILE}
chmod +x /usr/local/bin/kops &>> ${LOG_FILE}

# Download and install kubectl
echo "Installing kubectl..." | tee -a /tmp/userdata.log
curl -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &>> /tmp/userdata.log
chmod +x /usr/local/bin/kubectl &>> /tmp/userdata.log

# Add environment variables to .bashrc
# Check if the variable and alias already exist in ~/.bashrc
if ! grep -q 'export NAME=learntechnology.cloud' ~/.bashrc; then
  tee -a ~/.bashrc <<EOF
export NAME=learntechnology.cloud
export KOPS_STATE_STORE=s3://cluster.learntechnology.cloud
export AWS_REGION=us-east-1
export CLUSTER_NAME=learntechnology.cloud
export EDITOR='/usr/bin/vim'
alias k=kubectl
EOF
fi


# Source .bashrc
source ~/.bashrc

# Generate SSH keys (if not exists)
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" &>> "$LOG_FILE" ${LOG_FILE}
fi

# Create a directory for cluster deployment
sudo mkdir /cluster_deployment &>> ${LOG_FILE}

# Generate cluster.yaml file for cluster deployment
kops create cluster --name=learntechnology.cloud \
--state=s3://cluster.learntechnology.cloud --zones=us-east-1a,us-east-1b \
--node-count=2 --control-plane-count=1 --node-size=t3.medium --control-plane-size=t3.medium \
--control-plane-zones=us-east-1a --control-plane-volume-size 10 --node-volume-size 10 \
--ssh-public-key ~/.ssh/id_rsa.pub \
--dns-zone=learntechnology.cloud --dry-run --output yaml > /cluster_deployment/cluster.yaml

## Copy cluster.yaml and create the cluster
#cp cluster.yaml /cluster_deployment/cluster.yaml &>> /tmp/userdata.log

# Create cluster
kops create -f /cluster_deployment/cluster.yaml &>> ${LOG_FILE}

# Update the cluster
kops update cluster --name learntechnology.cloud --yes --admin &>> ${LOG_FILE}

# kops validate cluster --wait 10m
# kops validate cluster --name learntechnology.cloud
# kops delete cluster --name learntechnology.cloud --yes
# aws s3 ls s3://cluster.learntechnology.cloud --recursive
# aws s3 rm s3://cluster.learntechnology.cloud --recursive