# Kubernetes Secrets Guide

## Generic Secrets
To create a generic secret:
```bash
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=mysecretpass
```

## TLS Secrets
To create a TLS secret:
```bash
kubectl create secret tls <secret-name> --cert=path/to/tls.crt --key=path/to/tls.key

# Example
kubectl create secret tls my-tls-secret \
  --cert=/etc/ssl/certs/mydomain.crt \
  --key=/etc/ssl/private/mydomain.key
```

## Docker Registry Secrets
To create a registry secret:
```bash
kubectl create secret docker-registry docker-pwd \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<token> \
  --docker-email=<email>
```