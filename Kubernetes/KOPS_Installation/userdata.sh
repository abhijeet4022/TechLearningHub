#!/bin/bash

# Update system
sudo apt-get update -y &>> /tmp/userdata.log

# Change directory
sudo cd /usr/local/bin &>> /tmp/userdata.log

# Download kops binary
sudo curl -LO https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64 &>> /tmp/userdata.log

# Rename kops binary
sudo mv kops-linux-amd64 kops &>> /tmp/userdata.log

# Download kubectl binary
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &>> /tmp/userdata.log

# Set permissions for kops and kubectl
sudo chmod 777 kops &>> /tmp/userdata.log
sudo chmod 777 kubectl &>> /tmp/userdata.log

# Add environment variables to .bashrc
# Check if the variable and alias already exist in ~/.bashrc
grep -q 'export NAME=learntechnology.cloud' ~/.bashrc || sudo tee -a ~/.bashrc <<EOF
export NAME=learntechnology.cloud
export KOPS_STATE_STORE=s3://cluster.learntechnology.cloud
export AWS_REGION=us-east-1
export CLUSTER_NAME=learntechnology.cloud
export EDITOR='/usr/bin/vim'
alias k=kubectl
EOF



# Source .bashrc
sudo source ~/.bashrc &>> /tmp/userdata.log

# Generate SSH keys
sudo sudo ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" &>> /tmp/userdata.log

# Create a directory for cluster deployment
sudo mkdir /cluster_deployment &>> /tmp/userdata.log

# Generate cluster.yaml file for cluster deployment
#kops create cluster --name=learntechnology.cloud \
#--state=s3://cluster.learntechnology.cloud --zones=us-east-1a,us-east-1b \
#--node-count=2 --control-plane-count=1 --node-size=t3.medium --control-plane-size=t3.medium \
#--control-plane-zones=us-east-1a --control-plane-volume-size 10 --node-volume-size 10 \
#--ssh-public-key ~/.ssh/id_rsa.pub \
#--dns-zone=learntechnology.cloud --dry-run --output yaml > /cluster_deployment/cluster.yaml

# Copy cluster.yaml and create the cluster
sudo cd /cluster_deployment &>> /tmp/userdata.log
sudo cp cluster.yaml /cluster_deployment/cluster.yaml &>> /tmp/userdata.log

# Create cluster
sudo kops create -f cluster.yaml &>> /tmp/userdata.log

# Update the cluster
sudo kops update cluster --name learntechnology.cloud --yes --admin &>> /tmp/userdata.log

# kops validate cluster --wait 10m
# kops validate cluster --name learntechnology.cloud
# kops delete cluster --name learntechnology.cloud --yes