# Master Node installation on VM Workstation CentOS 9.
* OS File
1. https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso

* VM Workstation 17 Pro download link.
1. https://www.techspot.com/downloads/downloadnow/189/?evp=f14a48a23bc560f5fbe81b8d83387b41&file=241

# Pre-Requisite.
* System Configuration:
  1. OS: Centos 9
  2. CPU: 2VCPUs
  3. Memory: 4GB
* It's recommended to disable the SWAP partition on all nodes, and SELINUX should be disabled in Master Node.
* To disable the swap.
  1. `swapon -s`
  2. `swapoff -a`
  3. `Remove the SWAP mount point entry from /etc/fstab`
* Set SELinux in permissive mode (effectively disabling it).
  1. `sudo setenforce 0`
  2. `sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config`
* Stop and Disable the firewall.
  1. `sudo systemctl stop firewalld`
  2. `sudo systemctl disable firewalld`
* Reboot the VM.
  1. `init 6`

# Kubernetes official documentation for installation using kubeadm.
1. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# Installation troubleshooting URL.
1. https://admantium.medium.com/kubernetes-with-kubeadm-cluster-installation-from-scratch-810adc1b0a64

# Continue with Installation.
* Configure the kubernetes repository /etc/yum.repos.d/kubernetes.repo.

```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=0
#gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
```
* **Note:** The excluded parameter in the repository definition ensures that the packages related to Kubernetes are not upgraded upon running yum update as there's a special procedure that must be followed for upgrading Kubernetes.

* Set up the repo for containerd. 
  1. `sudo yum install -y yum-utils`
  2. `sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

* Install docker, kubelet, kubeadm and kubectl:
  1. `sudo yum install -y docker-ce containerd kubelet kubeadm kubectl --disableexcludes=kubernetes`

* Enable the kubelet service before running kubeadm:
  1. `sudo systemctl start docker`
  2. `sudo systemctl enable docker`
  3. `sudo systemctl start containerd`
  4. `sudo systemctl enable containerd`
  5. `sudo systemctl start kubelet`
  6. `sudo systemctl enable kubelet`


# Enable ip_forwarding is not required.
* To enable ip_forwarding
```
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
```

* Apply sysctl params without a reboot.
  1. `sudo sysctl --system`
  2. `sudo sysctl -p`
  
* Verify that net.ipv4.ip_forward is set to 1 with:
  1. `sysctl net.ipv4.ip_forward`

# Configure Static-ip
  1. `nmcli connection add con-name static-ip ifname ens224 ipv4.method manual autoconnect yes  type ethernet ipv4.addresses  192.168.22.1/24`
  2. `nmcli con up static-ip`

# Now set up the component using kubeadm utility.
1. `rm -rf /etc/containerd/config.toml`
* If we do not delete this file, kubeadm will look for cri-o not containerd.
* Container configuration for containerd.

```
cat <<EOF | sudo tee /etc/containerd/config.toml
version = 2
[plugins]
[plugins."io.containerd.grpc.v1.cri"]
[plugins."io.containerd.grpc.v1.cri".containerd]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
runtime_type = "io.containerd.runc.v2"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
SystemdCgroup = true
EOF
```
2. `systemct restart containerd`
3. `kubeadm init --apiserver-advertise-address=192.168.22.1 --pod-network-cidr=10.0.0.0/8`
4. `cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`

# To check the Component status and health.
1. `kubectl get pod -A`
2. `kubectl get componentstatus`

# Print the Join command for worker
1. `kubeadm token list`
2. `kubeadm token delete <token>`
3. `kubeadm token create --print-join-command`

# Configure the calico
1. https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises
* This needs to run on master node, and it will configure the L3 bridge network on all nodes including master node. 
* Download the file.
1. `curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml -O`
* Deploy the yaml.
1. `kubectl create -f calico.yaml`
2. `kubectl get pod -A -o wide`

# Certificate path.
1. `/etc/kubernetes/pki/ca.crt`





