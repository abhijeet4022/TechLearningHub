#!/bin/bash

# Log file
LOG_FILE="/tmp/userdata.log"
CLUSTER_NAME="learntechnology.cloud"
KOPS_STATE_STORE="s3://cluster.learntechnology.cloud"
AWS_REGION="us-east-1"
EDITOR="/usr/bin/vim"
DEPLOYMENT_DIR="/cluster_deployment"

# Exit on any error
#set -e

# Update system
echo "Updating system packages..." | tee -a ${LOG_FILE}
sudo apt-get update -y &>> ${LOG_FILE}

# Download and install kops
echo "Installing kops..." | tee -a ${LOG_FILE}
curl -Lo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64 &>> ${LOG_FILE}
chmod +x /usr/local/bin/kops &>> ${LOG_FILE}

# Download and install kubectl
echo "Installing kubectl..." | tee -a ${LOG_FILE}
curl -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &>> ${LOG_FILE}
chmod +x /usr/local/bin/kubectl &>> ${LOG_FILE}

# Add environment variables and alias to .bashrc
echo "Configuring environment variables and alias..." | tee -a ${LOG_FILE}
if ! grep -q "export NAME=$CLUSTER_NAME" ~/.bashrc; then
  cat <<EOF >> ~/.bashrc
export NAME=$CLUSTER_NAME
export KOPS_STATE_STORE=$KOPS_STATE_STORE
export AWS_REGION=$AWS_REGION
export CLUSTER_NAME=$CLUSTER_NAME
export EDITOR=$EDITOR
alias k=kubectl
EOF
fi
source ~/.bashrc

# Generate SSH keys if they do not exist
echo "Generating SSH keys..." | tee -a ${LOG_FILE}
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" &>> ${LOG_FILE}
fi

# Create a directory for cluster deployment
echo "Creating cluster deployment directory at $DEPLOYMENT_DIR..." | tee -a ${LOG_FILE}
sudo mkdir -p ${DEPLOYMENT_DIR} &>> ${LOG_FILE}

# Generate cluster.yaml for deployment
echo "Generating cluster.yaml configuration..." | tee -a ${LOG_FILE}
echo "KOPS_STATE_STORE is set to $KOPS_STATE_STORE & $CLUSTER_NAME" | tee -a ${LOG_FILE}
sudo kops create cluster \
  --name=$CLUSTER_NAME \
  --state=$KOPS_STATE_STORE \
  --zones=us-east-1a,us-east-1b \
  --node-count=2 \
  --control-plane-count=1 \
  --node-size=t3.medium \
  --control-plane-size=t3.medium \
  --control-plane-zones=us-east-1a \
  --control-plane-volume-size=10 \
  --node-volume-size=10 \
  --ssh-public-key=~/.ssh/id_rsa.pub \
  --dns-zone=$CLUSTER_NAME \
  --dry-run --output yaml > ${DEPLOYMENT_DIR}/cluster.yaml

## Copy cluster.yaml and create the cluster
#cp cluster.yaml /cluster_deployment/cluster.yaml &>> /tmp/userdata.log

# Create cluster from the YAML file
echo "Creating the cluster..." | tee -a ${LOG_FILE}
kops create -f ${DEPLOYMENT_DIR}/cluster.yaml &>> ${LOG_FILE}

# Update the cluster
echo "Updating the cluster..." | tee -a ${LOG_FILE}
kops update cluster --name=$CLUSTER_NAME --yes --admin &>> ${LOG_FILE}

## Optional: Validate the cluster
#echo "Validating the cluster (optional)..." | tee -a ${LOG_FILE}
#kops validate cluster --name=$CLUSTER_NAME --wait 10m &>> ${LOG_FILE}
# kops validate cluster --name learntechnology.cloud
# kops delete cluster --name learntechnology.cloud --yes
# aws s3 ls s3://cluster.learntechnology.cloud --recursive
# aws s3 rm s3://cluster.learntechnology.cloud --recursive

echo "Cluster setup is complete!" | tee -a ${LOG_FILE}

echo "KOPS_STATE_STORE is set to $KOPS_STATE_STORE & $CLUSTER_NAME" | tee -a ${LOG_FILE}