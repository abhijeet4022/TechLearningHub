# How to Upgrade Kubernetes (EKS) with Zero Downtime

## Kubernetes Release Lifecycle
- Kubernetes releases new versions approximately **every three months**.
- Only the **latest three versions** are supported at any given time. Ensure your EKS cluster stays within this support window.

---

## Pre-Requisites

1. **Test in Lower Environments**
    - Always test the upgrade in a **staging or non-production environment** before upgrading production clusters.
    - Note that **downgrading an EKS cluster is not supported**, so testing is crucial. If the upgrade causes issues, you may need to create a new cluster, which can significantly impact operations.

2. **Review Release Notes**
    - Refer to the official Kubernetes release notes: [https://kubernetes.io/releases/](https://kubernetes.io/releases/).
    - Pay attention to:
        - **API version changes**: Identify deprecated APIs or features.
            - Example: The `extensions/v1beta1` API group for Ingress was replaced with `networking.k8s.io/v1`.
        - Deprecation of older features and new compatibility requirements.

3. **Control Plane and Data Plane Compatibility**
    - The **control plane** and **data plane (nodes)** must run with same versions.
    - Ensure **kubelet versions** on worker nodes match the upgraded control plane version.

4. **Cluster Auto-Scaler Compatibility**
    - If using the **Cluster Auto-Scaler**, ensure it matches the Kubernetes version of the control plane.

5. **Ensure Sufficient Resources**
    - Verify that the cluster has at least **5 available IPs** in the subnets used during cluster creation. These are required for new pods and additional resources during the upgrade.

6. **Backup the Cluster**
    - Backup cluster resources using tools like `Velero`:
      ```bash
      velero backup create <backup_name> --include-namespaces <namespace>
      ```
    - Take snapshots of persistent volumes and stateful data (e.g., databases).

7. **Node Cordon and Drain Strategy**
    - Before upgrading nodes, **cordon** (mark as unschedulable) and **drain** them:
      ```bash
      kubectl cordon <node_name>
      kubectl drain <node_name> --ignore-daemonsets --delete-emptydir-data
      ```

---

## Upgrade Process

### 1. Upgrade the Control Plane
- Use **AWS Management Console**, `eksctl`, or AWS CLI to upgrade the control plane.

#### Using AWS CLI:
```bash
aws eks update-cluster-version --name <cluster_name> --kubernetes-version <new_version>
```

#### Using eksctl:
```bash
eksctl upgrade cluster --name <cluster_name> --version <new_version>
```

- AWS **EKS automatically handles High Availability (HA)** for the control plane, including disaster recovery (DR) and API server scaling.
- Post-upgrade, verify the control plane version:
  ```bash
  kubectl version --short
  ```

### 2. Upgrade the Data Plane (Nodes)
The data plane includes **AWS-managed node groups**, **self-managed nodes**, or **Fargate profiles**.

#### For AWS Managed Node Groups:
1. Update the node group version:
   ```bash
   aws eks update-nodegroup-version \
       --cluster-name <cluster_name> \
       --nodegroup-name <nodegroup_name> \
       --kubernetes-version <new_version>
   ```
2. Verify the node group version:
   ```bash
   aws eks describe-nodegroup --cluster-name <cluster_name> --nodegroup-name <nodegroup_name>
   ```

#### For Self-Managed Nodes:
1. Update the **launch template** or AMI ID to match the new Kubernetes version.
    - Retrieve the latest AMI ID for the new version:
      ```bash
      aws ssm get-parameters --names /aws/service/eks/optimized-ami/<version>/amazon-linux-2/recommended/image_id --region <region>
      ```
    - Update the launch template with the new AMI ID.

2. Roll out the changes:
    - Terminate nodes in a rolling manner. New nodes will be created with the updated AMI.

#### For Fargate Profiles:
- Fargate profiles are managed by AWS and are upgraded automatically after the control plane upgrade.

#### Node Rollout Without Downtime:
- Use the following process to avoid downtime during node upgrades:
    - **Cordon and Drain**:
      ```bash
      kubectl cordon <node_name>
      kubectl drain <node_name> --ignore-daemonsets --delete-emptydir-data
      ```
    - Ensure new nodes join the cluster and workloads are migrated automatically.

---

### 3. Upgrade Add-Ons
Kubernetes add-ons such as `CoreDNS`, `KubeProxy`, and third-party tools (e.g., AWS VPC CNI, Prometheus) must also be updated.

#### Using AWS CLI:
1. List installed add-ons:
   ```bash
   aws eks list-addons --cluster-name <cluster_name>
   ```
2. Update add-ons:
   ```bash
   aws eks update-addon \
       --cluster-name <cluster_name> \
       --addon-name <addon_name> \
       --addon-version <new_version>
   ```

#### Using eksctl:
```bash
eksctl utils update-aws-node --cluster <cluster_name>
eksctl utils update-coredns --cluster <cluster_name>
eksctl utils update-kube-proxy --cluster <cluster_name>
```

#### Verify Add-On Status:
- After upgrading, ensure add-ons are functioning correctly:
  ```bash
  kubectl get pods -n kube-system
  ```

---

## Post-Upgrade Validation
1. Validate the cluster health:
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```
2. Test critical applications and services in the cluster.
3. Monitor logs and metrics using tools like **CloudWatch**, **Prometheus**, or **Grafana**.

---

## How to Ensure Zero Downtime
- Perform the upgrade during **maintenance windows**.
- Use a **blue-green or canary deployment strategy** for applications.
- Scale up nodes and resources temporarily to ensure sufficient capacity during upgrades.
- Monitor application and cluster performance closely throughout the process.

---
