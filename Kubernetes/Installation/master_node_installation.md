# Master Node installation
OS: Centos
CPU: 2vcpu
Memory: 4GB

# Kubernetes official documentation for installation using kubeadm
`https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/`

# Set SELinux in permissive mode (effectively disabling it)
`sudo setenforce 0`
`sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config`

# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
`cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF`
# Note: The exclude parameter in the repository definition ensures that the packages related to Kubernetes are not upgraded upon running yum update as there's a special procedure that must be followed for upgrading Kubernetes.

# Install kubelet, kubeadm and kubectl:
`sudo yum install -y containerd kubelet kubeadm kubectl --disableexcludes=kubernetes`

# Enable the kubelet service before running kubeadm:
`sudo systemctl enable --now kubelet`
`sudo systemctl start kubelet`

