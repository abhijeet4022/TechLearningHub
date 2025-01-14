#!/bin/bash

# Log file
LOG_FILE="/tmp/userdata.log"
CLUSTER_NAME="learntechnology.cloud"
KOPS_STATE_STORE="s3://cluster.learntechnology.cloud"
AWS_REGION="us-east-1"
EDITOR="/usr/bin/vim"
DEPLOYMENT_DIR="/cluster_deployment"

# Countdown timer function
timer() {
  local SECONDS_LEFT=$1
  while [ $SECONDS_LEFT -gt 0 ]; do
    MIN=$((SECONDS_LEFT / 60))
    SEC=$((SECONDS_LEFT % 60))
    printf "\e[33mRemaining Time: %02d:%02d\e[0m\n" $MIN $SEC | tee -a ${LOG_FILE}
    sleep 30
    SECONDS_LEFT=$((SECONDS_LEFT - 30))
  done
}

# set the hostname
echo -e "\n\e[32mSetting the hostname...\e[0m" | tee -a ${LOG_FILE}
hostnamectl set-hostname k8s-bastion &>> ${LOG_FILE}

# Update system
echo -e "\n\e[32mUpdating system packages...\e[0m" | tee -a ${LOG_FILE}
sudo apt-get update -y &>> ${LOG_FILE}

# Download and install kops
echo -e "\n\e[32mInstalling kops...\e[0m" | tee -a ${LOG_FILE}
curl -Lo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64 &>> ${LOG_FILE}
chmod +x /usr/local/bin/kops &>> ${LOG_FILE}

# Download and install kubectl
echo -e "\n\e[32mInstalling kubectl...\e[0m" | tee -a ${LOG_FILE}
curl -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &>> ${LOG_FILE}
chmod +x /usr/local/bin/kubectl &>> ${LOG_FILE}

# Download and install kubens
echo -e "\n\e[32mInstalling kubens...\e[0m" | tee -a ${LOG_FILE}
sudo curl -Lo /usr/local/bin/kubens.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens_v0.9.5_linux_x86_64.tar.gz &>> ${LOG_FILE}
sudo tar -zxf /usr/local/bin/kubens.tar.gz -C /usr/local/bin/ &>> ${LOG_FILE}
sudo rm -rf /usr/local/bin/LICENSE /usr/local/bin/kubens.tar.gz &>> ${LOG_FILE}

# Download and install kubectx
echo -e "\n\e[32mInstalling kubectx...\e[0m" | tee -a ${LOG_FILE}
sudo curl -Lso /usr/local/bin/kubectx.tar.gz https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx_v0.9.5_linux_x86_64.tar.gz &>> ${LOG_FILE}
sudo tar -zxf /usr/local/bin/kubectx.tar.gz -C /usr/local/bin/ &>> ${LOG_FILE}
sudo rm -rf /usr/local/bin/LICENSE /usr/local/bin/kubectx.tar.gz &>> ${LOG_FILE}

# Download and install helm
echo -e "\n\e[32mInstalling helm...\e[0m" | tee -a ${LOG_FILE}
sudo curl -Lso /usr/local/bin/helm.tar.gz https://get.helm.sh/helm-v3.13.0-linux-amd64.tar.gz &>> ${LOG_FILE}
sudo tar -zxf /usr/local/bin/helm.tar.gz -C /usr/local/bin/ &>> ${LOG_FILE}
sudo mv /usr/local/bin/linux-amd64/helm /usr/local/bin/ &>> ${LOG_FILE}
sudo rm -rf /usr/local/bin/helm.tar.gz /usr/local/bin/linux-amd64 &>> ${LOG_FILE}

# Add environment variables and alias to /etc/profile
echo -e "\n\e[32mConfiguring environment variables and alias...\e[0m" | tee -a ${LOG_FILE}
if ! grep -q "export NAME=$CLUSTER_NAME" /etc/profile; then
  cat <<EOF >> /etc/profile
export NAME=$CLUSTER_NAME
export KOPS_STATE_STORE=$KOPS_STATE_STORE
export AWS_REGION=$AWS_REGION
export CLUSTER_NAME=$CLUSTER_NAME
export EDITOR=$EDITOR
export DEPLOYMENT_DIR=$DEPLOYMENT_DIR
alias k=kubectl
EOF
source /etc/profile
fi

# Generate SSH keys if they do not exist
echo -e "\n\e[32mGenerating SSH keys...\e[0m" | tee -a ${LOG_FILE}
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" &>> ${LOG_FILE}
fi

# Create a directory for cluster deployment
echo -e "\n\e[32mCreating cluster deployment directory at $DEPLOYMENT_DIR...\e[0m" | tee -a ${LOG_FILE}
sudo mkdir -p ${DEPLOYMENT_DIR} &>> ${LOG_FILE}

# Generate cluster.yaml for deployment
echo -e "\n\e[32mGenerating cluster.yaml configuration...\e[0m" | tee -a ${LOG_FILE}
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

# Create cluster from the YAML file
echo -e "\n\e[32mCreating the cluster...\e[0m" | tee -a ${LOG_FILE}
sudo -E kops create -f ${DEPLOYMENT_DIR}/cluster.yaml &>> ${LOG_FILE}

# Update the cluster
echo -e "\n\e[32mUpdating the cluster...\e[0m" | tee -a ${LOG_FILE}
sudo -E kops update cluster --name=$CLUSTER_NAME --yes --admin &>> ${LOG_FILE}
echo -e "\n\e[32mPlease wait for 10 minutes to bring up the cluster...\e[0m" | tee -a ${LOG_FILE}
# Call the timer function for 10 minutes (600 seconds)
timer 600

# Create the .kube directory for the root user
echo -e "\n\e[32mCreate the .kube directory for the root user...\e[0m" | tee -a ${LOG_FILE}
sudo mkdir -p /root/.kube  /home/ubuntu/.kube

# Move the Kubernetes configuration file to the root user's .kube directory
echo -e "\n\e[32mMove the Kubernetes configuration file to the root and ubuntu user's .kube directory\e[0m" | tee -a ${LOG_FILE}
sudo cp /.kube/config /home/ubuntu/.kube/config
sudo cp /.kube/config /root/.kube/config
echo -e "\n\e[32mSetting the .kube directory ownership and permission...\e[0m" | tee -a ${LOG_FILE}
sudo chown -R root:ubuntu /home/ubuntu/.kube
sudo chmod -R 770 /root/.kube /home/ubuntu/.kube

# Output a completion message
echo -e "\n\e[32mKubernetes configuration has been set up successfully.\e[0m" | tee -a "$LOG_FILE"


## Optional: Validate the cluster
#echo -e "\n\e[32mValidating the cluster (optional)...\e[0m" | tee -a ${LOG_FILE}
#kops validate cluster --name=$CLUSTER_NAME --wait 10m &>> ${LOG_FILE}
# kops validate cluster --name learntechnology.cloud --wait 10m
# kops delete cluster --name learntechnology.cloud --yes
# aws s3 ls s3://cluster.learntechnology.cloud --recursive
# aws s3 rm s3://cluster.learntechnology.cloud --recursive
# kops export kubeconfig learntechnology.cloud --admin
# cat ~/.kube/config



#echo -e "\e[32mChecking the status of pods...\e[0m" | tee -a ${LOG_FILE}
#
## Loop until the command exits with 0
#while true; do
#  kubectl get pods -A &>> ${LOG_FILE}
#  if [ $? -eq 0 ]; then
#    echo -e "\e[32mkubectl get pods -A succeeded!\e[0m" | tee -a ${LOG_FILE}
#    break
#  else
#    echo -e "\e[33mWaiting for the pods to be ready...\e[0m" | tee -a ${LOG_FILE}
#    sleep 10 # Wait for 10 seconds before retrying
#  fi
#done