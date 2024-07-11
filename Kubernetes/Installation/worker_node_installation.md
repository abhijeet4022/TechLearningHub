# Configure Static-ip
`nmcli connection add con-name static-ip ifname ens224 autoconnect yes  type ethernet ipv4.addresses  192.168.22.2/24 ipv4.method manual`
`nmcli con up static-ip`

# To check the swap status
`swapon -s`
`swapoff -a`
`sudo systemctl stop firewalld`
`sudo systemctl disable firewalld`

# Set up the repo for containerd
`sudo yum install -y yum-utils`
`sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

# Install container socket
`yum install -y docker-ce`
`systemctl start docker kubelet`
`systemctl enable docker kubelet`
`systemctl enable containerd.service`

# Now set up the component using kubeadm utility.
`rm -rf /etc/containerd/config.toml`
# Container configuration
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

`systemctl restart containerd`

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


# Install the package.
`yum install -y kubelet kubeadm --disableexcludes=kubernetes`
`systemctl enable kubelet.service`
`systemctl start kubelet.service`


# Create the join command and run it
`kubeadm join 192.168.22.1:6443 --token 73m574.vn3avhmkotj5694g --discovery-token-ca-cert-hash sha256:f35156cec7ac068ee33532d9c7726ec96cd152e57da2546ce0aeb1264df84138`

# Worker node will keep the certificate in below path
`/var/lib/kubelet/pki`



