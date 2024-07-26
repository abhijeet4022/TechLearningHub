echo -e "\e[32mDownload calicoctl:\e[0m"
curl -L https://github.com/projectcalico/calico/releases/download/v3.28.0/calicoctl-linux-amd64 -o calicoctl
chmod +x calicoctl
mv calicoctl /usr/local/bin
echo -e "\e[32Done\e[0m"

echo -e "\e[32mConfigure calicoctl:\e[0m"
mkdir -p /etc/calico
cat <<EOF | tee /etc/calico/calicoctl.cfg
apiVersion: projectcalico.org/v3
kind: CalicoAPIConfig
metadata:
spec:
  datastoreType: "kubernetes"
  kubeconfig: '/root/.kube/config'
EOF
echo -e "\e[32Done\e[0m"






