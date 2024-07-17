# Master Node installation on VM Workstation CentOS 9.

# Pre-requisite.
* System Configuration:
  1. OS: Centos 9
  2. CPU: 2VCPUs
  3. Memory: 4GB
* It's recommended to disable the SWAP partition on all node and SELINUX should be disabled in Master Node.
* To disable the swap.
    `swapon -s`
    `swapoff -a`
    `Remove the SWAP mount point entry from /etc/fstab`
* Set SELinux in permissive mode (effectively disabling it).
    `sudo setenforce 0`
    `sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config`
* Stop and Disable the firewall.
    `sudo systemctl stop firewalld`
    `sudo systemctl disable firewalld`
* Reboot the VM.
    `init 6`


# Kubernetes official documentation for installation using kubeadm.
    `https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/`
# Installation troubleshooting URL.
    `https://admantium.medium.com/kubernetes-with-kubeadm-cluster-installation-from-scratch-810adc1b0a64`

* Configure the kubernetes repository /etc/yum.repos.d/kubernetes.repo. 
`cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=0
#gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF`
* **Note:** The excluded parameter in the repository definition ensures that the packages related to Kubernetes are not upgraded upon running yum update as there's a special procedure that must be followed for upgrading Kubernetes.

* Set up the repo for containerd. 
    `sudo yum install -y yum-utils`
    `sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

* Install kubelet, kubeadm and kubectl:
    `sudo yum install -y docker-ce containerd kubelet kubeadm kubectl --disableexcludes=kubernetes`

# Enable the kubelet service before running kubeadm:
`sudo systemctl start docker`
`sudo systemctl enable docker`
`sudo systemctl start containerd`
`sudo systemctl enable containerd`
`sudo systemctl start kubelet`
`sudo systemctl enable kubelet`


# To enable ip_forwarding
`cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF`

# Apply sysctl params without reboot
`sudo sysctl --system`
`sudo sysctl -p`
# Verify that net.ipv4.ip_forward is set to 1 with:
`sysctl net.ipv4.ip_forward`

# Configure Static-ip
`nmcli connection add con-name static-ip ifname ens224 ipv4.method manual autoconnect yes  type ethernet ipv4.addresses  192.168.22.1/24`
`nmcli con up static-ip`

# Now set up the component using kubeadm utility.
`rm -rf /etc/containerd/config.toml`
* If we did not delete this file, kubeadm will look for cri-o not containerd.
# Container configuration for containerd.
`cat <<EOF | sudo tee /etc/containerd/config.toml
version = 2
[plugins]
[plugins."io.containerd.grpc.v1.cri"]
[plugins."io.containerd.grpc.v1.cri".containerd]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
runtime_type = "io.containerd.runc.v2"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
SystemdCgroup = true
EOF`

`systemct restart containerd`

`kubeadm init --apiserver-advertise-address=192.168.22.1 --pod-network-cidr=10.0.0.0/8`
`cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`

# To check the Component status and health.
`kubectl get pod -A`
`kubectl get componentstatus`

# Print the Join command for worker
`kubeadm token list`
`kubeadm token delete <token>`
`kubeadm token create --print-join-command`


https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises
# Configure the calico
# This needs to run on master node, and it will configure the L3 bridge network on all nodes including master node. 

* Download the file.
`curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml -O`
* Deploy the yaml.
`kubectl create -f calico.yaml`
`kubectl get pod -A -o wide`

# Certificate path.
`/etc/kubernetes/pki/ca.crt`





