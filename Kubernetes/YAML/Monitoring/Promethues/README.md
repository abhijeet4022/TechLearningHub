# Prometheus repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm search repo prometheus-community
helm install prometheus prometheus-community/prometheus


# Grafana repository
helm repo add grafana https://grafana.github.io/helm-charts
helm search repo grafana
helm install grafana grafana/grafana

* Find the grafana credentials.
* kubectl get secret | grep -i grafana
* kubectl get secret grafana -o yaml
* echo -n <admin-password> | base64 -d
