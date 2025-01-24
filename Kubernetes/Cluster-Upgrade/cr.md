### Install eksctl
```bash
curl -Lo /usr/local/bin/eksctl_Linux_amd64.tar.gz https://github.com/eksctl-io/eksctl/releases/download/v0.202.0/eksctl_Linux_amd64.tar.gz
tar -xzvf /usr/local/bin/eksctl_Linux_amd64.tar.gz -C /usr/local/bin
rm -f eksctl_Linux_amd64.tar.gz
eksctl version
```
**Explanation:**
- Downloads and installs the `eksctl` binary for managing Amazon EKS clusters.
- Verifies the installation by checking the installed version of `eksctl`.

---
# Create EKS Cluster

### Step 1: Create an EKS Cluster
```bash
eksctl create cluster --name=observability \
--region=us-east-1 \
--zones=us-east-1a,us-east-1b \
--without-nodegroup
```
**Explanation:**
- Creates an Amazon EKS cluster named `observability` in the `us-east-1` region across availability zones `us-east-1a` and `us-east-1b`.
- The `--without-nodegroup` flag creates only the control plane without worker nodes.

**Flags:**
- `--name=observability`: Name of the cluster.
- `--region=us-east-1`: AWS region for the cluster.
- `--zones=us-east-1a,us-east-1b`: Availability zones for HA.
- `--without-nodegroup`: Excludes worker nodes during initial setup.

---

### Step 2: Associate IAM OIDC Provider
```bash
eksctl utils associate-iam-oidc-provider \
--region us-east-1 \
--cluster observability \
--approve
```
**Explanation:**
- Associates an IAM OpenID Connect (OIDC) provider with the EKS cluster, allowing the cluster to use IAM roles for Kubernetes Service Accounts (IRSA).
- Enables Kubernetes service accounts to assume IAM roles for AWS service access.

**Flags:**
- `--region us-east-1`: AWS region of the cluster.
- `--cluster observability`: Name of the EKS cluster.
- `--approve`: Automatically approves the OIDC provider setup.

## Create eks pod identity agent addon.
```bash
eksctl create addon \
  --name eks-pod-identity-agent \
  --cluster observability \
  --region us-east-1 \
  --force
```

```bash
eksctl get addons --cluster observability --region us-east-1
```
---

### Step 3: Create a Node Group
```bash
eksctl create nodegroup --cluster=observability \
--region=us-east-1 \
--name=observability-ng-private \
--node-type=t3.medium \
--nodes-min=2 \
--nodes-max=3 \
--node-volume-size=20 \
--managed \
--asg-access \
--external-dns-access \
--full-ecr-access \
--appmesh-access \
--alb-ingress-access \
--node-private-networking
```
**Explanation:**
- Creates a managed node group with specific configurations for the `observability` cluster.

**Flags:**
- `--cluster=observability`: Specifies the cluster name.
- `--region=us-east-1`: AWS region of the cluster.
- `--name=observability-ng-private`: Names the node group.
- `--node-type=t3.medium`: Instance type for worker nodes.
- `--nodes-min=2`: Minimum number of nodes.
- `--nodes-max=3`: Maximum number of nodes (for autoscaling).
- `--node-volume-size=20`: Allocates 20 GB storage per node.
- `--managed`: AWS manages provisioning, and health monitoring of nodes.
- `--asg-access`: Enables use of Auto Scaling Group (ASG) for scaling.
- `--external-dns-access`: Grants permissions for Kubernetes to manage external DNS (e.g., Route 53).
- `--full-ecr-access`: Allows full access to Amazon Elastic Container Registry (ECR).
- `--appmesh-access`: Provides access to AWS App Mesh for service mesh capabilities.
- `--alb-ingress-access`: Enables management of Application Load Balancer (ALB) ingress controllers.
- `--node-private-networking`: Deploys nodes in private subnets for security.

---

### Workflow Summary:
1. **Cluster Creation**:
    - Sets up a managed control plane (handled by AWS).
    - High availability is ensured with multiple availability zones.
    - Worker nodes are excluded initially for flexibility.

2. **IAM OIDC Provider Association**:
    - Links IAM roles with Kubernetes service accounts for secure access to AWS resources.

3. **Node Group Creation**:
    - Adds worker nodes with autoscaling capabilities.
    - Configures nodes for private networking and grants permissions for AWS integrations.

---

### Update ./kube/config file
```bash
aws eks update-kubeconfig --name observability
```
**Explanation:**
- Updates the `~/.kube/config` file to include the credentials for the `observability` cluster.
- Allows `kubectl` commands to interact with the EKS cluster.

---

### Delete the EKS Cluster
```bash
eksctl delete cluster --name observability
```
**Explanation:**
- Deletes the `observability` cluster along with its associated resources (control plane and nodes).
- Ensures cleanup of all resources associated with the cluster.