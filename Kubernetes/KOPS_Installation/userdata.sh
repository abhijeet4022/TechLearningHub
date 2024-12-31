#!/bin/bash
apt-get update -y &>> /tmp/userdata.log
cd /usr/local/bin &>> /tmp/userdata.log
curl -LO https://github.com/kubernetes/kops/releases/download/v1.30.2/kops-linux-amd64 &>> /tmp/userdata.log
mv kops-linux-amd64 kops &>> /tmp/userdata.log
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &>> /tmp/userdata.log
chmod 777 kops &>> /tmp/userdata.log
chmod  777 kubectl &>> /tmp/userdata.log

cat <<EOF | tee -a ~/.bashrc
export NAME=learntechnology.cloud
export KOPS_STATE_STORE=s3://cluster.learntechnology.cloud
export AWS_REGION=us-east-1
export CLUSTER_NAME=learntechnology.cloud
export EDITOR='/usr/bin/vim'
alias k=kubectl
EOF


source ~/.bashrc &>> /tmp/userdata.log

ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N "" &>> /tmp/userdata.log

mkdir /cluster_deployment &>> /tmp/userdata.log
#kops create cluster --name=learntechnology.cloud \
#--state=s3://cluster.learntechnology.cloud --zones=us-east-1a,us-east-1b \
#--node-count=2 --control-plane-count=1 --node-size=t3.medium --control-plane-size=t3.medium \
#--control-plane-zones=us-east-1a --control-plane-volume-size 10 --node-volume-size 10 \
#--ssh-public-key ~/.ssh/id_rsa.pub \
#--dns-zone=learntechnology.cloud --dry-run --output yaml > /cluster_deployment/cluster.yaml

cd /cluster_deployment &>> /tmp/userdata.log
cp cluster.yaml /cluster_deployment/cluster.yaml &>> /tmp/userdata.log
kops create -f cluster.yaml &>> /tmp/userdata.log
kops update cluster --name learntechnology.cloud --yes --admin &>> /tmp/userdata.log
# kops validate cluster --wait 10m
# kops validate cluster --name learntechnology.cloud
# kops delete cluster --name learntechnology.cloud --yes

