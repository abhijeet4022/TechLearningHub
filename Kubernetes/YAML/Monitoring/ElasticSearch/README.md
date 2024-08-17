* Guide to setup ELK.
* https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes

# To check the Elstisearch pos status
kubectl rollout status sts/es-cluster --namespace=kube-logging

# To check the kibana pos status
kubectl rollout status deployment/kibana --namespace=kube-logging

# To check the fluentd statusget get 
kubectl get ds --namespace=kube-logging