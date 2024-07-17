# Worker Node Installation.
* Configure Static-ip
1. `nmcli connection add con-name static-ip ifname ens224 autoconnect yes  type ethernet ipv4.addresses  192.168.22.2/24 ipv4.method manual`
2. `nmcli con up static-ip`
* Note: Replace the name as per environment.
* To list the device name.
1. `nmcli dev status`
2. `nmcli con show`

* To disable the swap.
1. `swapon -s`
2. `swapoff -a`
3. `Remove the SWAP mount point entry from /etc/fstab`

* Stop the firewalld.
1. `sudo systemctl stop firewalld`
2. `sudo systemctl disable firewalld`

* Set up the repo for containerd.
1. `sudo yum install -y yum-utils`
2. `sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`

* Configure the kubernetes repo /etc/yum.repos.d/kubernetes.repo
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

* Install the required package and start the services.
1. `yum install -y docker-ce kubelet kubeadm --disableexcludes=kubernetes`
2. `systemctl enable kubelet.service`
3. `systemctl start kubelet.service`
4. `systemctl start docker kubelet`
5. `systemctl enable docker kubelet`
6. `systemctl enable containerd.service`

* Container socket configuration.
1. `rm -rf /etc/containerd/config.toml`

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

2. `systemctl restart containerd`


# Create the join command from worker node and run it.
* Example
1. `kubeadm join 192.168.22.1:6443 --token 73m574.vn3avhmkotj5694g --discovery-token-ca-cert-hash sha256:f35156cec7ac068ee33532d9c7726ec96cd152e57da2546ce0aeb1264df84138`

* Worker node will keep the certificate in below path.
1. `/var/lib/kubelet/pki`



