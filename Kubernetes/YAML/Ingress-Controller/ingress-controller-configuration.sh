# Installation Guide - https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-manifests/

echo -e "\e[32mCloning the NGINX Repository:\e[0m"
sudo mkdir /root/ingress-controller
cd /root/ingress-controller
git clone https://github.com/nginxinc/kubernetes-ingress.git --branch v3.6.0
cd /root/ingress-controller/kubernetes-ingress
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate a namespace and a service account:\e[0m"
kubectl apply -f deployments/common/ns-and-sa.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate a cluster role and binding for the service account:\e[0m"
kubectl apply -f deployments/rbac/rbac.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mNGINX App Protect only Create the App Protect role and binding:\e[0m"
kubectl apply -f deployments/rbac/ap-rbac.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate a secret for the default NGINX server’s TLS certificate and key:\e[0m"
kubectl apply -f examples/shared-examples/default-server-secret/default-server-secret.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate a ConfigMap to customize your NGINX settings:\e[0m"
kubectl apply -f deployments/common/nginx-config.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate an IngressClass resource. NGINX Ingress Controller won’t start without an IngressClass resource:\e[0m"
cat <<EOF | sudo tee deployments/common/ingress-class.yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: nginx.org/ingress-controller
EOF
kubectl apply -f deployments/common/ingress-class.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mCreate custom resource definitions (CRDs) for various components:\e[0m"
kubectl apply -f config/crd/bases/k8s.nginx.org_virtualservers.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_virtualserverroutes.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_transportservers.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_policies.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_globalconfigurations.yaml
echo -e "\e[32mDone\e[0m"


echo -e "\n\e[32mCreate core custom resource definitions:\e[0m"
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/v3.6.1/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/v3.6.1/deploy/crds-nap-waf.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mDeploy NGINX Ingress Controller:\e[0m"
kubectl apply -f deployments/deployment/nginx-ingress.yaml
echo -e "\e[32mDone\e[0m"

echo -e "\n\e[32mNGINX Ingress Controller Status:\e[0m"
sleep 120
kubectl get pods --namespace=nginx-ingress
echo -e "\e[32mDone\e[0m"

#echo -e "\n\e[32m Access NGINX Ingress Controller.\e[0m"
#kubectl create -f deployments/service/nodeport.yaml
#echo -e "\e[32mDone\e[0m"

