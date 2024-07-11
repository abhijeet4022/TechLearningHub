# Master Node installation

# Pre-requisite 
OS: Centos
CPU: 2vcpu
Memory: 4GB

# It's recommended to disable the SWAP partition on all node and SELINUX should be disabled in Master Node.

# To check the swap status
`swapon -s`
`swapoff -a`

# Set SELinux in permissive mode (effectively disabling it)
`sudo setenforce 0`
`sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config`


# Kubernetes official documentation for installation using kubeadm
`https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/`

# This overwrites any existing configuration in /etc/yum.repos.d/kubernetes.repo
`cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=0
#gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF`
# Note: The exclude parameter in the repository definition ensures that the packages related to Kubernetes are not upgraded upon running yum update as there's a special procedure that must be followed for upgrading Kubernetes.

# Set up the repo for containerd 
`sudo yum install -y yum-utils`
`sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

# Install kubelet, kubeadm and kubectl:
`sudo yum install -y docker-ce containerd kubelet kubeadm kubectl --disableexcludes=kubernetes`

# Enable the kubelet service before running kubeadm:
`sudo systemctl start docker`
`sudo systemctl enable docker`
`sudo systemctl start containerd`
`sudo systemctl enable containerd`
`sudo systemctl start kubelet`
`sudo systemctl enable --now kubelet`
`sudo systemctl stop firewalld`
`sudo systemctl disable firewalld`

# To enable ip_forwarding
`echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf`
`sudo sysctl -p`

# Configure Static-ip
`nmcli connection add con-name static-ip ifname ens224 ipv4.method manual autoconnect yes  type ethernet ipv4.addresses  192.168.22.1/24`
`nmcli con up static-ip`

# Now set up the component using kubeadm utility.
`rm -rf /etc/containerd/config.toml`
`systemctl restart containerd`
* If we did not delete this file, kubeadm will look for cri-o not containerd.
`kubeadm init --apiserver-advertise-address=192.168.22.1 --pod-network-cidr=10.0.0.0/8`
`cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`

# To check the Component status and health.
`kubectl get pod -A`
`kubectl get componentstatus`



kubeadm join 192.168.22.1:6443 --token 3s04y1.gkfrr61e5sz16lik --discovery-token-ca-cert-hash sha256:99f18805fe8fddf2bca58de4c840ccbeedc4eb84b96905fcfd4423cb039290f0






https://admantium.medium.com/kubernetes-with-kubeadm-cluster-installation-from-scratch-810adc1b0a64





