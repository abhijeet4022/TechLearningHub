# Kubernetes User Setup and Configuration Guide

## 1. Copy CA Certificates
Copy the `kubernetes-ca.crt` and `kubernetes-ca.key` files from the Control-Plane to the Management Node.

- **Control-Plane Path**: `/etc/kubernetes/kops-controller`
- **Management Node Path**: `/tmp`

---

## 2. Create Namespaces
Create two namespaces in your Kubernetes cluster:
- **development**
- **production**

```bash
kubectl create namespace development
kubectl create namespace production
```

---

## 3. Create Users

### 3.1 User: `abhijeet` (Access to `development` Namespace)
Generate a key, CSR, and certificate:
```bash
openssl genrsa -out abhijeet.key 2048
openssl req -new -key abhijeet.key -out abhijeet.csr -subj "/CN=abhijeet/O=development"
openssl x509 -req -in abhijeet.csr -CA kubernetes-ca.crt -CAkey kubernetes-ca.key -CAcreateserial -out abhijeet.crt -days 365
```

---

### 3.2 User: `abhi` (Access to `production` Namespace)
Generate a key, CSR, and certificate:
```bash
openssl genrsa -out abhi.key 2048
openssl req -new -key abhi.key -out abhi.csr -subj "/CN=abhi/O=production"
openssl x509 -req -in abhi.csr -CA kubernetes-ca.crt -CAkey kubernetes-ca.key -CAcreateserial -out abhi.crt -days 365
```

---

### 3.3 User: `adminuser` (Access to the Entire Cluster)
Generate a key, CSR, and certificate:
```bash
openssl genrsa -out adminuser.key 2048
openssl req -new -key adminuser.key -out adminuser.csr -subj "/CN=adminuser/O=clusteradmin"
openssl x509 -req -in adminuser.csr -CA kubernetes-ca.crt -CAkey kubernetes-ca.key -CAcreateserial -out adminuser.crt -days 365
```

Copy the `crt` and `key` files for all users that is generated in PWD to the Control-Plane under a directory such as `/cert/`.

---

## 4. Create Kubeconfig Files

### Sample Kubeconfig for `abhijeet`
```yaml
apiVersion: v1
clusters:
  - cluster:
      certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1...
      server: https://api.learntechnology.cloud
      tls-server-name: api.internal.learntechnology.cloud
    name: learntechnology.cloud
contexts:
  - context:
      cluster: learntechnology.cloud
      namespace: development
      user: abhijeet
    name: abhijeet-context
current-context: abhijeet-context
kind: Config
users:
  - name: abhijeet
    user:
      client-certificate: /cert/abhijeet.crt
      client-key: /cert/abhijeet.key
```

### Repeat for Other Users
Replace the namespace and user details (`abhi` for production, `adminuser` for clusteradmin) to generate kubeconfigs for other users. Use tools like **Beyond Compare** to compare YAML files.

---

## 5. Use Kubeconfig in Control-Plane

For each user, create a file with their kubeconfig content. Example for `abhijeet`:
- **File Name**: `/config/abhijeet-config`

Export the kubeconfig file to interact with the cluster:
```bash
export KUBECONFIG=/config/abhijeet-config
kubectl get pods
```
Repeat for other users as needed.

---
## 6. Create Roles for Normal Users
Apply the role definition using:
```bash
kubectl apply -f role.yaml
```

## 7. Attach Roles with Users (RoleBinding)
Use RoleBinding to associate roles with users:
```bash
kubectl apply -f rolebinding.yaml
```

## 8. Create Roles and ClusterRoleBinding for Admin User
Grant cluster admin access to the `adminuser`:
```bash
kubectl apply -f cluster_admin_access.yaml
```

## 9. Merge All Config Files
Combine all user configurations into a single kubeconfig file:
```bash
KUBECONFIG=abhijeet-config:abhi-config:adminuser-config kubectl config view --merge --flatten > mixed-config.txt
export KUBECONFIG=mixed-config.txt
```

### Use `kubectx` for Context Switching
- **List all contexts**:
  ```bash
  kubectx
  ```
- **Switch context**:
  ```bash
  kubectx <context-name>
  ```

## 10. Install GUI Tool: Portainer
### Repository
- **Link**: [Portainer Repository](https://github.com/portainer/k8s)

### Install Using Helm (NodePort)
```bash
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm install --create-namespace -n portainer portainer portainer/portainer
kubectl get svc -n portainer
```

### Allow NodePort in AWS Security Groups
Ensure the NodePort is allowed in the AWS Security Group for external access.
