# Prometheus Configuration Guide

## Installing Helm
```bash
cd /usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 777 get_helm.sh
./get_helm.sh
```
  
## Prometheus Setup
  
### Create Namespace
```bash
kubectl create namespace prom
```
  
### Deploy Prometheus
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n prom
```

### Configure Grafana Service
You can expose the Grafana service using NodePort in one of two ways:

1. Edit the service directly:
```bash
kubectl edit svc prometheus-grafana -n prom
```
Add under spec:
```yaml
spec:
  type: NodePort
```

2. Or use kubectl patch:
```bash
kubectl patch svc prometheus-grafana -n prom -p '{"spec": {"type": "NodePort"}}'
```

### Grafana Dashboard Access
- Username: `admin`
- Password: `prom-operator`
- Access URL: `http://<Control-Plane-IP>:<NodePort>`

### Configure Prometheus Data Source
Find the Prometheus service endpoint FQDN:
```bash
kubectl exec -it prometheus-grafana-fcb7986c6-52jb7 -- nslookup prometheus-kube-prometheus-prometheus
```
Example endpoint: `http://prometheus-kube-prometheus-prometheus.prom.svc.cluster.local:9090`

### Important Dashboards
- Node Monitoring: Navigate to Home - Dashboards - Node Exporter/Nodes
- Pod Monitoring: Navigate to Home - Dashboards - Kubernetes/Compute Resources/Pod

## Horizontal Pod Autoscaling (HPA)

### Custom Metrics Setup
```bash
helm install prometheus-adapter prometheus-community/prometheus-adapter --namespace prom
```

### CPU and Memory Metrics

> Note: For CPU and memory-based HPA, you only need the Metrics Server (no Prometheus Adapter required).

#### Install Metrics Server
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml -n kube-system
```

Verify installation:
```bash
kubectl get deployment metrics-server -n kube-system
kubectl top nodes
kubectl top pods
```
  
### Deploy HPA
```bash
kubectl apply -f hpa.yaml
```
  
### Testing HPA
  
#### Install Stress Tools
```bash
kubectl exec -it web-785c68849b-nxh28 -- /bin/bash
apt-get update && apt-get install -y stress
```

#### Generate Load
CPU stress:
```bash
kubectl exec -it web-785c68849b-8xqnl -- stress --cpu 2 --timeout 300s
```

CPU and Memory stress:
```bash
kubectl exec -it web-785c68849b-8xqnl -- stress --cpu 2 --vm 2 --vm-bytes 128M --timeout 300s
```
  
#### Monitor HPA
```bash
kubectl get hpa
kubectl describe hpa <hpa-name>
```