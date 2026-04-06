# AWS EKS Cluster Creation by Console with Custom Configuration (`EKS 1.34`)

> **Important note**
> - AWS Console labels change over time.
> - Kubernetes/EKS version availability can also vary by **region** and **account**.
> - Use this document as a practical guide, but always verify the exact options visible in your AWS Console before clicking **Create**.
> - If `1.34` is not shown in your console, use the latest version currently supported in your region.

---

## 1. Objective

This document explains how to create an **Amazon EKS cluster** from the **AWS Management Console** using **Custom configuration** and what each major field/component means.

The goal is to help you understand:

- what you need before starting,
- what every important option does,
- what values are commonly selected,
- what is recommended for **development**, **testing**, and **production**.

---

## 2. What is created in EKS cluster setup?

When you create an EKS cluster, you are mainly creating the following components:

1. **EKS Control Plane**
   - Managed by AWS.
   - Runs Kubernetes API server and core control plane components.
   - AWS manages high availability and health of the control plane.

2. **Networking configuration**
   - VPC
   - Subnets
   - Security groups
   - API endpoint access rules

3. **IAM integration**
   - Cluster IAM role
   - Node IAM role
   - Access/authentication configuration

4. **Data plane / worker nodes**
   - Managed node groups, self-managed nodes, or Fargate.
   - These run your application pods.

5. **Observability and security settings**
   - Control plane logs
   - Secrets encryption
   - Tags
   - Add-ons

---

## 3. Before creating the cluster

Prepare the following items first.

> From this point onward, for each step try to think in four parts:
> 1. **What you fill in the console**
> 2. **What you must create before this step**
> 3. **Example value / naming pattern**
> 4. **Which AWS service, IAM role, or policy is involved**

### 3.1 VPC and subnets

You need a VPC with subnets in at least **two Availability Zones**.

Recommended design:

- **Private subnets** → for worker nodes
- **Public subnets** → optional, usually for internet-facing load balancers or NAT routing

**What should already exist:**
- 1 VPC
- at least 2 private subnets in different AZs
- optional 2 public subnets in different AZs
- internet gateway for public traffic
- NAT gateway if private subnets need outbound internet access
- route tables correctly associated to each subnet

**Recommended example naming:**
- VPC: `vpc-prod-eks-main`
- Private subnets:
  - `subnet-prod-eks-private-a`
  - `subnet-prod-eks-private-b`
  - `subnet-prod-eks-private-c`
- Public subnets:
  - `subnet-prod-eks-public-a`
  - `subnet-prod-eks-public-b`

**Example network plan:**

| Component | Example value |
|---|---|
| VPC CIDR | `10.10.0.0/16` |
| Private subnet A | `10.10.1.0/24` |
| Private subnet B | `10.10.2.0/24` |
| Private subnet C | `10.10.3.0/24` |
| Public subnet A | `10.10.11.0/24` |
| Public subnet B | `10.10.12.0/24` |

**Service involved:**
- **Amazon VPC**

**Important practical note:**
- If you plan to create load balancers from Kubernetes `Service` resources later, subnet tagging is often required by related integrations. Common tags you may see in AWS guidance are:
  - public subnet: `kubernetes.io/role/elb = 1`
  - private subnet: `kubernetes.io/role/internal-elb = 1`
- Always verify the current AWS guidance for your EKS and load balancer setup.

### 3.2 IAM roles

Usually you need at least:

1. **Cluster IAM role**
   - Used by the EKS control plane to interact with AWS services.

2. **Node IAM role**
   - Used by EC2 worker nodes to join the cluster and pull container images.

**Create these roles before starting the console flow.**

#### A. Cluster IAM role

**Suggested role names:**
- `eks-cluster-role-dev`
- `eks-cluster-role-test`
- `eks-cluster-role-prod`

**Used by:**
- **Amazon EKS control plane**

**Typical trust relationship / principal:**
- `eks.amazonaws.com`

**Common AWS-managed policy to attach:**
- `AmazonEKSClusterPolicy`

**What this role is for:**
- allows EKS control plane to manage cluster-related AWS interactions required by the service

**Do not use this role for:**
- EC2 worker nodes
- application pods
- administrators logging in to AWS

#### B. Node IAM role

**Suggested role names:**
- `eks-node-role-dev`
- `eks-node-role-test`
- `eks-node-role-prod`

**Used by:**
- **EC2 instances** in the managed node group

**Typical trust relationship / principal:**
- `ec2.amazonaws.com`

**Common AWS-managed policies to attach:**
- `AmazonEKSWorkerNodePolicy`
- `AmazonEC2ContainerRegistryPullOnly` *(or the AWS-managed read-only ECR pull policy visible in your account/console)*
- `AmazonEKS_CNI_Policy` *(commonly attached for IPv4 clusters; in some designs teams move CNI permissions away from the node role and grant them to the VPC CNI add-on/service account instead)*

**What this role is for:**
- lets nodes join the cluster
- lets nodes pull container images from Amazon ECR
- lets node networking components work with AWS networking APIs

#### C. Optional pod/application IAM roles

These are **not** the same as cluster or node roles.

**Examples:**
- `eks-irsa-s3-read-role`
- `eks-pod-role-external-dns`
- `eks-pod-role-ebs-csi`

**Used by:**
- specific Kubernetes service accounts or pod identity mappings

**Purpose:**
- lets an application or add-on access AWS services such as:
  - S3
  - Route 53
  - Secrets Manager
  - DynamoDB
  - EBS APIs

**Service involved:**
- **IAM**
- **EKS access / pod identity / IRSA-related integration** depending on your setup

#### D. Simple role summary table

| Role | Example name | Used by | Common policies |
|---|---|---|---|
| Cluster role | `eks-cluster-role-prod` | EKS control plane | `AmazonEKSClusterPolicy` |
| Node role | `eks-node-role-prod` | EC2 worker nodes | `AmazonEKSWorkerNodePolicy`, ECR pull policy, commonly `AmazonEKS_CNI_Policy` |
| Pod/app role | `eks-pod-role-s3-reader` | Pod/service account | Only the app-specific least-privilege policy |

### 3.3 Optional KMS key

If you want Kubernetes secrets encrypted using your own key, create or identify a **KMS key** before starting.

**Suggested key alias examples:**
- `alias/eks-dev-secrets`
- `alias/eks-prod-secrets`

**What to create first:**
- a customer-managed KMS key in the same region as the EKS cluster

**What you will fill in the console:**
- KMS key ARN or selected key name

**Service involved:**
- **AWS KMS**

**Practical note:**
- the key policy must allow the right administrative team and the EKS-related usage path required by your design; verify access before cluster creation

### 3.4 Tooling for post-creation access

After the cluster is created, you will usually need:

- `aws` CLI
- `kubectl`

Example command after cluster creation:

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
```

### 3.5 Recommended prerequisite inventory with examples

Use something like the following before opening the EKS console.

| Component | Example name | Required? | Service / notes |
|---|---|---|---|
| VPC | `vpc-prod-eks-main` | Yes | Amazon VPC |
| Private subnets | `subnet-prod-eks-private-a/b/c` | Yes | At least 2 AZs |
| Public subnets | `subnet-prod-eks-public-a/b` | Optional | Useful for ALB/NAT paths |
| Cluster IAM role | `eks-cluster-role-prod` | Yes | IAM role for EKS control plane |
| Node IAM role | `eks-node-role-prod` | Usually yes | IAM role for EC2 nodes |
| KMS key | `alias/eks-prod-secrets` | Optional | For Kubernetes secrets encryption |
| CloudWatch log group strategy | `/aws/eks/prod-eks-payments/cluster` | Optional but recommended | For control plane logs |
| Admin access role | `eks-admin-role-prod` | Strongly recommended | For cluster administration |
| SSH key pair | `eks-prod-admin-key` | Optional | Only if node SSH access is required |

---

## 4. Recommended high-level design for custom configuration

For most standard environments, the following is a good starting point:

| Component | Recommended choice |
|---|---|
| EKS version | `1.34` if available in your region |
| API endpoint access | `Public and Private` during setup, later restrict if needed |
| Nodes | Managed node group |
| Node placement | Private subnets |
| Capacity type | On-Demand for production, Spot for cost optimization where appropriate |
| Secrets encryption | Enable with KMS if security/compliance requires it |
| Control plane logs | Enable at least `API`, `Audit`, and `Authenticator` |
| Add-ons | Install/update `VPC CNI`, `CoreDNS`, `kube-proxy`, and storage CSI driver as needed |
| Tags | Add `Environment`, `Application`, `Owner`, `CostCenter` |

---

## 5. Console navigation path

Typical navigation:

1. Open **AWS Console**
2. Go to **Amazon EKS**
3. Select **Clusters**
4. Click **Create cluster**
5. Choose **Custom configuration**

Depending on the AWS Console version, the screens may appear in slightly different order, but the main configuration areas are usually the same.

---

## 6. Cluster configuration page - every component explained

This is the most important part of the setup because it defines the base identity of the cluster.

### 6.1 Cluster name

**What it is:**
- The name of your EKS cluster.

**Why it matters:**
- Used in AWS Console, CLI, monitoring, tagging, and kubeconfig.

**Recommendation:**
- Use a meaningful name such as:
  - `dev-eks-01`
  - `test-eks-app1`
  - `prod-eks-payments`

**Best practice:**
- Include environment and application name.

**What you fill in the console:**
- a unique cluster name

**Example values:**
- `dev-eks-orders`
- `uat-eks-billing`
- `prod-eks-payments`

**Recommended naming pattern:**
- `<environment>-eks-<application>`

**Service involved:**
- **Amazon EKS**

---

### 6.2 Kubernetes version

**What it is:**
- The Kubernetes control plane version used by the cluster.

**For your requirement:**
- Select **`1.34`** if it is available.

**Why it matters:**
- Determines API behavior, feature availability, and compatibility with:
  - managed node groups,
  - add-ons,
  - workloads,
  - Helm charts,
  - admission controllers.

**Important notes:**
- EKS versions are not available forever.
- Not every AWS region shows the same version at the same time.
- **Downgrade is not supported**. If you choose the wrong version, rollback is not simple.

**Recommendation:**
- Use `1.34` only after validating:
  - application compatibility,
  - add-on compatibility,
  - node AMI support,
  - Helm chart compatibility.

**What you fill in the console:**
- choose the control plane version from the drop-down

**Example value:**
- `1.34`

**What to verify before selecting:**
- available in your AWS region
- supported by required EKS add-ons
- compatible with your node AMI choice
- compatible with your Helm charts / manifests / admission webhooks

**Service involved:**
- **Amazon EKS**

---

### 6.3 Cluster service IAM role

**What it is:**
- IAM role assumed by the EKS control plane.

**Why it matters:**
- Allows the control plane to manage AWS resources needed by EKS.

**Typical requirement:**
- A dedicated IAM role created for EKS cluster usage.

**Recommendation:**
- Use a separate role such as:
  - `eks-cluster-role-dev`
  - `eks-cluster-role-prod`

**Best practice:**
- Do not reuse broad administrator roles if a dedicated cluster role is available.

**What you fill in the console:**
- select the IAM role that EKS control plane will assume

**What you should create before this step:**
- IAM role in **IAM > Roles**
- trusted entity/service principal for EKS
- required policy attachment

**Recommended example:**

| Item | Example |
|---|---|
| Role name | `eks-cluster-role-prod` |
| Trusted service | `eks.amazonaws.com` |
| Policy to attach | `AmazonEKSClusterPolicy` |
| Used for | EKS control plane |

**Service involved:**
- **IAM**
- **Amazon EKS**

**How to think about this role:**
- this role is for the **cluster control plane** only
- it is not the role for EC2 worker nodes
- it is not the role for application pods

**If you are creating by console, the preparation is usually:**
1. Go to **IAM**
2. Create role
3. Select trusted service for EKS
4. Attach `AmazonEKSClusterPolicy`
5. Name it, for example `eks-cluster-role-prod`
6. Return to the EKS cluster creation page and select this role

**Good practice:**
- one cluster role per environment or per cluster family
- example:
  - `eks-cluster-role-dev`
  - `eks-cluster-role-uat`
  - `eks-cluster-role-prod`

**Avoid:**
- selecting `AdministratorAccess`
- reusing a personal IAM user or unrelated admin role
- mixing cluster role and node role responsibilities into one role

---

### 6.4 Secrets encryption

Sometimes this appears on the cluster configuration page, and in some console layouts it may appear under a security section.

**What it is:**
- Encrypts Kubernetes `Secret` objects using AWS KMS.

**Why it matters:**
- Adds an extra layer of protection for sensitive information such as:
  - database passwords,
  - API keys,
  - tokens,
  - certificates.

**What you fill:**
- KMS key ARN or select a KMS key from the list.

**When to enable:**
- Strongly recommended for production and compliance-focused environments.

**When it may be optional:**
- Small lab or test environments where simplicity is more important than strict controls.

**Recommendation:**
- Enable it for production clusters.

**What you fill in the console:**
- choose the KMS key to encrypt Kubernetes secrets

**What you should create before this step:**
- customer-managed KMS key
- alias for easy identification
- key policy reviewed by your security/admin team

**Recommended example:**

| Item | Example |
|---|---|
| KMS key alias | `alias/eks-prod-secrets` |
| Region | same as cluster region |
| Used for | Kubernetes `Secret` encryption |

**Service involved:**
- **AWS KMS**
- **Amazon EKS**

**When teams usually enable this:**
- production
- regulated workloads
- workloads storing credentials or API tokens in Kubernetes secrets

---

### 6.5 Cluster authentication / access configuration

Depending on console version, you may see settings related to:

- cluster authentication mode,
- access entries,
- admin permissions for cluster creator,
- IAM-based cluster access.

**What it is:**
- Defines how users and roles are allowed to authenticate and administer the cluster.

**Why it matters:**
- Without correct access configuration, the cluster may be created but administrators cannot manage it properly.

**Common options you may see:**

1. **Grant cluster creator admin access**
   - Good for initial setup.
   - Useful in labs and early-stage environments.

2. **Access entries / IAM access management**
   - Lets you define which IAM users or roles can access the cluster.
   - Better for controlled enterprise administration.

**Recommendation:**
- For learning or setup: allow the cluster creator admin access.
- For production: define controlled IAM roles and access entries clearly.

**What you fill in the console:**
- whether the creator gets admin rights
- whether access is handled through EKS access entries / IAM integration shown in the console

**What you should create before this step for production:**
- dedicated admin IAM role such as `eks-admin-role-prod`
- optional read-only/auditor role such as `eks-viewer-role-prod`

**Example access design:**

| Access type | Example name | Purpose |
|---|---|---|
| Cluster admin role | `eks-admin-role-prod` | Full cluster administration |
| Platform ops role | `eks-platform-ops-role` | Operational management |
| Read-only role | `eks-viewer-role-prod` | Audit / visibility only |

**Service involved:**
- **IAM**
- **Amazon EKS access management**

**Recommendation by environment:**
- Lab: creator admin access can be acceptable
- Production: prefer dedicated IAM roles, not personal identities

---

## 7. Networking page - every component explained

Networking is one of the most important areas in EKS because a wrong selection here causes most deployment and connectivity issues.

### 7.1 VPC

**What it is:**
- The virtual network where the EKS cluster resources operate.

**Why it matters:**
- All node groups, pods, load balancers, and API connectivity depend on the selected VPC design.

**Recommendation:**
- Use a dedicated application VPC or a shared VPC approved by your organization.

**What you fill in the console:**
- select the VPC ID/name where the cluster will live

**What you should create before this step:**
- VPC with correct CIDR
- route tables
- NAT/internet design
- DNS support enabled in the VPC

**Example values:**
- VPC name: `vpc-prod-eks-main`
- VPC CIDR: `10.10.0.0/16`

**Service involved:**
- **Amazon VPC**

---

### 7.2 Subnets

**What it is:**
- The subnets that EKS uses for cluster networking.

**Why it matters:**
- EKS requires subnet placement across multiple AZs for high availability.

**Best practice:**
- Select subnets from at least **two Availability Zones**.
- Prefer **private subnets** for worker nodes.

**Important notes:**
- Public subnets are not usually recommended for worker nodes in production.
- Ensure enough free IP addresses are available.
- IP exhaustion is a common problem in EKS.

**Recommendation:**
- Use 2 or 3 private subnets across different AZs.

**What you fill in the console:**
- select the subnet IDs to associate with the cluster

**What you should create before this step:**
- private subnets in at least two AZs
- optional public subnets if your design needs them
- correct route tables

**Example values:**
- `subnet-prod-eks-private-a`
- `subnet-prod-eks-private-b`
- `subnet-prod-eks-private-c`

**Service involved:**
- **Amazon VPC**

**Operational note:**
- worker nodes are commonly launched in private subnets
- public subnets are often used for internet-facing load balancers, not for production worker nodes

---

### 7.3 Security groups

**What it is:**
- Firewall rules that control inbound and outbound traffic.

**Why it matters:**
- The cluster security group controls communication between:
  - control plane,
  - nodes,
  - add-ons,
  - internal services.

**Common approach:**
- Use the default cluster security group created by EKS, or provide a pre-approved dedicated security group.

**Recommendation:**
- Start with AWS-managed defaults if you are learning.
- In production, use controlled security groups reviewed by networking/security teams.

**What you fill in the console:**
- choose existing security groups or allow EKS to create/manage the default cluster security group depending on the screen shown

**What you should create before this step if using custom security groups:**
- cluster security group
- optional node security group
- reviewed ingress/egress rules

**Example values:**
- Cluster SG: `sg-prod-eks-cluster`
- Node SG: `sg-prod-eks-nodes`

**Typical intent of rules:**
- control plane to node communication
- node to control plane communication
- node to node communication if required by workloads/add-ons
- egress to AWS APIs, image registries, and required destinations

**Service involved:**
- **Amazon EC2 Security Groups**

**Practical warning:**
- avoid opening broad inbound rules without justification
- do not use `0.0.0.0/0` casually on administrative ports such as SSH

---

### 7.4 Kubernetes API server endpoint access

This decides how you will access the Kubernetes API server.

**Common options:**

1. **Public**
   - API server accessible through the internet.
   - Easier for administration from laptops.
   - Higher exposure if CIDR restrictions are too open.

2. **Private**
   - API server accessible only inside the VPC/network path connected to the VPC.
   - More secure.
   - Requires private connectivity such as VPN, Direct Connect, bastion, or management host.

3. **Public and Private**
   - Both access paths are enabled.
   - Often used during setup or migration.

**Recommendation:**
- For labs: `Public and Private` or `Public` with restricted source CIDR.
- For production: prefer `Private` or `Public and Private` with tightly controlled CIDRs.

**What you fill in the console:**
- `Public`, `Private`, or `Public and Private`

**Example production-style choice:**
- `Public and Private` during initial setup
- restrict public CIDR to office/VPN ranges only
- later move to `Private` only if your admin path supports it

**Service involved:**
- **Amazon EKS endpoint configuration**

---

### 7.5 Public access CIDR ranges

If public access is enabled, you may be asked to define which source IP ranges can reach the API endpoint.

**What it is:**
- CIDR blocks allowed to access the Kubernetes API endpoint.

**Why it matters:**
- `0.0.0.0/0` means the whole internet can try to reach the endpoint.

**Recommendation:**
- Avoid `0.0.0.0/0` unless it is a temporary lab.
- Restrict to:
  - office public IP,
  - VPN IP range,
  - jump host public IP,
  - approved admin network.

**What you fill in the console:**
- the source network ranges allowed to reach the public API endpoint

**Example values:**
- `203.0.113.10/32` → single office public IP
- `198.51.100.0/24` → company VPN range

**Service involved:**
- **Amazon EKS public API endpoint control**

---

### 7.6 IP family

**Common choices:**
- `IPv4`
- `IPv6`

**What it is:**
- Defines how cluster IP addressing works.

**Recommendation:**
- Use **IPv4** unless your organization specifically requires IPv6 and has designed networking for it.

**Why IPv4 is usually chosen:**
- Simpler,
- more common,
- easier integration with existing tooling,
- fewer surprises in traditional enterprise environments.

**What you fill in the console:**
- choose `IPv4` or `IPv6`

**Example value:**
- `IPv4`

**Service involved:**
- **Amazon EKS networking**

---

### 7.7 Service CIDR / Kubernetes network range

In some console versions this may be visible or defaulted automatically.

**What it is:**
- Internal IP range used for Kubernetes `Service` objects.

**Why it matters:**
- Must not overlap with VPC CIDR, on-prem networks, or connected networks.

**Recommendation:**
- If the console lets you change it, choose a non-overlapping range that fits your network design.

**What you fill in the console:**
- Kubernetes service network CIDR if the field is exposed

**Example value:**
- `172.20.0.0/16`

**Important design rule:**
- this range must not overlap with:
  - VPC CIDR
  - on-prem networks
  - peered VPCs

**Service involved:**
- **Amazon EKS service networking**

---

## 8. Observability page - every component explained

Observability settings help you troubleshoot the cluster later.

### 8.1 Control plane logging

You may see options to enable one or more of the following log types:

- `API`
- `Audit`
- `Authenticator`
- `Controller manager`
- `Scheduler`

Below is what each one means.

#### API log
- Records Kubernetes API server activity.
- Useful to understand requests sent to the cluster.

#### Audit log
- Records who did what and when.
- Very important for security investigations and compliance.

#### Authenticator log
- Helps troubleshoot IAM authentication and access issues.
- Very helpful when users cannot access the cluster.

#### Controller manager log
- Helps diagnose issues in cluster controllers.

#### Scheduler log
- Helps troubleshoot pod scheduling behavior.

**Recommendation:**
- Minimum recommended for production:
  - `API`
  - `Audit`
  - `Authenticator`

**If you want deeper troubleshooting:**
- Enable all control plane logs.

**Important note:**
- More logs = more CloudWatch cost.

**What you fill in the console:**
- select which control plane logs to enable

**Recommended example for production:**
- enable all 5 log types if troubleshooting visibility is important

**Minimal recommended example:**
- `API`
- `Audit`
- `Authenticator`

**Service involved:**
- **Amazon CloudWatch Logs**
- **Amazon EKS**

---

### 8.2 CloudWatch integration

Depending on the console flow, control plane logs are usually sent to **CloudWatch Logs**.

**Why it matters:**
- Required for troubleshooting control plane issues.
- Useful for incident response and historical tracking.

**Recommendation:**
- Enable logging intentionally and define retention policy later according to your environment policy.

**What you should prepare:**
- log retention standard decided by your team
- naming/ownership convention for log groups

**Example approach:**

| Item | Example |
|---|---|
| Log group pattern | `/aws/eks/prod-eks-payments/cluster` |
| Retention | `30 days`, `90 days`, or per company policy |
| Owner tag | `platform-team` |

**Service involved:**
- **Amazon CloudWatch Logs**

---

## 9. Security-related settings - what they mean

Some security options may appear on separate pages depending on the AWS Console experience.

### 9.1 Secrets encryption with KMS

Already explained earlier, but from a security point of view:

- protects Kubernetes secrets at rest,
- supports stronger compliance posture,
- is commonly enabled in production.

**Example resource:**
- KMS key alias: `alias/eks-prod-secrets`

**Related AWS service:**
- **AWS KMS**

### 9.2 Endpoint access model

This is also a security decision:

- `Public` = easier access, higher exposure
- `Private` = lower exposure, needs private admin connectivity
- `Public and Private` = flexible, but public CIDRs must be restricted

### 9.3 IAM-based administration

Use IAM roles/users carefully.

**Recommendation:**
- Avoid using personal admin users for long-term production management.
- Prefer role-based administration.

**Example roles to create:**
- `eks-admin-role-prod`
- `eks-platform-ops-role`
- `eks-viewer-role-prod`

**Related AWS service:**
- **IAM**

---

## 10. Add-ons page - every component explained

After or during cluster creation, AWS may allow you to select core add-ons.

These are extremely important because the cluster is not very useful without them.

### 10.1 Amazon VPC CNI

**Purpose:**
- Gives pods network connectivity inside the VPC.

**Why it matters:**
- Without correct CNI behavior, pods may fail to get IP addresses.

**Recommendation:**
- Install and keep it compatible with your EKS version.

**Service involved:**
- **EKS add-on**
- **Amazon VPC**

**IAM note:**
- for IPv4 clusters, AWS networking API permissions are required somewhere in your design
- in some environments those permissions are on the node role via `AmazonEKS_CNI_Policy`
- in stricter environments teams grant them directly to the add-on/service account instead

---

### 10.2 CoreDNS

**Purpose:**
- Provides DNS service inside the Kubernetes cluster.

**Why it matters:**
- Pods use this for service discovery.

**Recommendation:**
- Install it by default.

**Service involved:**
- **EKS add-on**

**Example:**
- keep the AWS-recommended compatible version for your EKS cluster version

---

### 10.3 kube-proxy

**Purpose:**
- Manages Kubernetes service networking on nodes.

**Why it matters:**
- Required for cluster networking and service traffic routing.

**Recommendation:**
- Install and use the version compatible with EKS `1.34`.

**Service involved:**
- **EKS add-on**

---

### 10.4 EBS CSI driver

**Purpose:**
- Enables Kubernetes workloads to use Amazon EBS volumes dynamically.

**Use when:**
- Your applications need persistent storage.

**Recommendation:**
- Install it for stateful applications.

**What to create before using it properly:**
- an IAM role for the driver/service account or the pod identity path used by your environment

**Example role name:**
- `eks-pod-role-ebs-csi`

**Service involved:**
- **Amazon EBS**
- **EKS add-on**

---

### 10.5 EFS CSI driver

**Purpose:**
- Lets workloads mount Amazon EFS.

**Use when:**
- Multiple pods need shared file storage.

**What to create before using it properly:**
- EFS file system
- mount targets in required subnets
- IAM role/pod identity path as needed

**Example resources:**
- file system: `efs-prod-shared-apps`
- role: `eks-pod-role-efs-csi`

**Service involved:**
- **Amazon EFS**
- **EKS add-on / CSI integration**

---

### 10.6 Pod Identity / IRSA related add-ons

Depending on your environment, you may also configure IAM integration for pods.

**Purpose:**
- Allows pods to access AWS services securely without storing static credentials.

**Recommendation:**
- Use IAM roles for service accounts or the current AWS-recommended pod identity mechanism for production workloads.

**Example roles:**
- `eks-pod-role-external-dns`
- `eks-pod-role-cluster-autoscaler`
- `eks-pod-role-app-s3-read`

**Example service access mapping:**

| Pod/Add-on | Example AWS service | Example role |
|---|---|---|
| External DNS | Route 53 | `eks-pod-role-external-dns` |
| App needing secrets | Secrets Manager | `eks-pod-role-app-secrets-read` |
| App needing object storage | S3 | `eks-pod-role-app-s3-read` |

**Important principle:**
- do not give application pods the node role
- create separate least-privilege roles per workload or per add-on

---

## 11. Managed node group creation - every component explained

In many real environments, after the control plane is created, the next step is to create a **managed node group**.

Even if the cluster is created successfully, your applications cannot run until compute is attached.

### 11.1 Node group name

**What it is:**
- Name of the worker node group.

**Recommendation:**
- Use descriptive names such as:
  - `ng-system`
  - `ng-app`
  - `ng-prod-general`

**What you fill in the console:**
- node group name

**Recommended naming pattern:**
- `ng-<environment>-<purpose>`

**Example values:**
- `ng-prod-general`
- `ng-prod-system`
- `ng-dev-apps`

---

### 11.2 Node IAM role

**What it is:**
- IAM role attached to EC2 nodes.

**Why it matters:**
- Lets nodes:
  - join the cluster,
  - pull images,
  - talk to AWS services as allowed.

**Recommendation:**
- Use a dedicated node role.

**What you fill in the console:**
- the EC2 instance role used by the node group

**What you should create before this step:**
- IAM role trusted by EC2
- required AWS-managed policies attached

**Recommended example:**

| Item | Example |
|---|---|
| Role name | `eks-node-role-prod` |
| Trusted service | `ec2.amazonaws.com` |
| Policies | `AmazonEKSWorkerNodePolicy`, ECR pull policy, commonly `AmazonEKS_CNI_Policy` |

**Service involved:**
- **IAM**
- **Amazon EC2**
- **Amazon EKS**

**Explanation of common policies:**
- `AmazonEKSWorkerNodePolicy` → allows node integration with the EKS cluster
- ECR pull policy → allows pulling container images from Amazon ECR
- `AmazonEKS_CNI_Policy` → commonly used so pod networking components can work with VPC networking APIs in IPv4 designs

---

### 11.3 AMI type / operating system

Common options may include:

- Amazon Linux
- Bottlerocket
- GPU AMIs
- ARM/x86 variants

**How to choose:**
- Use standard Linux AMI for general-purpose workloads.
- Use Bottlerocket if your organization prefers minimal OS images.
- Use GPU AMI only if GPU workloads are required.
- Use ARM only if your application images support ARM architecture.

**Recommendation:**
- For most normal workloads, use a standard general-purpose Linux AMI with version support matching EKS `1.34`.

**What you fill in the console:**
- AMI family / OS type / architecture

**Example practical choices:**
- standard x86 general-purpose cluster → Amazon Linux x86
- ARM-based cost-optimized workloads → ARM only if your images support it
- hardened minimal OS path → Bottlerocket

---

### 11.4 Capacity type

Common choices:

- `On-Demand`
- `Spot`

**On-Demand**
- Stable
- Best for production and critical workloads
- More expensive

**Spot**
- Cheaper
- Can be interrupted by AWS
- Better for fault-tolerant workloads

**Recommendation:**
- Production critical apps → On-Demand
- Batch/stateless/cost-sensitive workloads → Spot or mixed strategy

**What you fill in the console:**
- `On-Demand` or `Spot`

**Example:**
- `ng-prod-general` → `On-Demand`
- `ng-dev-batch` → `Spot`

---

### 11.5 Instance types

**What it is:**
- EC2 instance family and size used by worker nodes.

**How to choose:**
- General purpose: `t3`, `t4g`, `m5`, `m6i`, etc.
- Memory heavy: `r` family
- Compute heavy: `c` family

**Recommendation:**
- For small environments, start with a general-purpose instance type.
- Choose based on application CPU/memory requirements.

**What you fill in the console:**
- one or more EC2 instance types for the node group

**Example values:**
- small lab: `t3.medium`
- general production entry point: `m6i.large` or organization-approved equivalent
- ARM path: `t4g.large` only if images support ARM

**Service involved:**
- **Amazon EC2**

---

### 11.6 Disk size

**What it is:**
- Root volume size for worker nodes.

**Why it matters:**
- Stores:
  - container images,
  - logs,
  - writable container layers,
  - temporary data.

**Recommendation:**
- Do not keep the default blindly.
- Increase it if you use:
  - many large images,
  - logging agents,
  - monitoring agents,
  - heavy workloads.

**What you fill in the console:**
- root disk size in GiB

**Example values:**
- lab: `20 GiB`
- normal application nodes: `50-100 GiB` depending on image/log footprint

**Service involved:**
- **Amazon EBS**

---

### 11.7 Scaling configuration

Usually you fill:

- **Desired size**
- **Minimum size**
- **Maximum size**

**What they mean:**

- **Desired** = how many nodes you want now
- **Minimum** = lowest number autoscaling can go to
- **Maximum** = highest number autoscaling can grow to

**Example:**
- Min = `2`
- Desired = `2`
- Max = `5`

**Recommendation:**
- Use at least `2` nodes for better availability in non-lab environments.

**What you fill in the console:**
- min, desired, max node counts

**Example production starter values:**
- min = `2`
- desired = `2`
- max = `6`

**Service involved:**
- **EKS managed node group scaling**
- often later combined with cluster autoscaling tooling

---

### 11.8 Subnets for node group

**What it is:**
- The subnets where worker nodes will be launched.

**Recommendation:**
- Use **private subnets** for production nodes.

**What you fill in the console:**
- subnet IDs for the node group

**Example values:**
- `subnet-prod-eks-private-a`
- `subnet-prod-eks-private-b`
- `subnet-prod-eks-private-c`

---

### 11.9 Remote access / SSH key pair

Some console flows allow remote SSH configuration.

**What it is:**
- Lets administrators log in to worker nodes.

**Recommendation:**
- Enable only if your operational model requires it.
- Restrict source access carefully.

**Security note:**
- If you do not need SSH, do not enable it.

**What you fill in the console:**
- EC2 key pair name if enabling SSH access

**Example value:**
- `eks-prod-admin-key`

**Service involved:**
- **Amazon EC2 Key Pairs**

---

### 11.10 Labels and taints

**Labels**
- Key/value metadata used for workload scheduling and identification.

**Taints**
- Prevent normal pods from scheduling unless explicitly tolerated.

**Use cases:**
- dedicated nodes for monitoring,
- dedicated nodes for GPU,
- dedicated nodes for system workloads.

**What you fill in the console:**
- optional labels and taints for the node group

**Example labels:**
- `workload=general`
- `environment=prod`
- `team=platform`

**Example taints:**
- `dedicated=system:NoSchedule`
- `gpu=true:NoSchedule`

---

### 11.11 Launch template

**What it is:**
- Advanced configuration for node provisioning.

**Use when you need:**
- custom AMI,
- custom bootstrap,
- custom disk/network configuration,
- advanced EC2 settings.

**Recommendation:**
- For normal use, managed defaults are simpler.
- Use a launch template only when you have a real customization need.

**Example launch template name:**
- `lt-eks-prod-general`

**Use this when you specifically need:**
- custom EBS volume configuration
- custom user data/bootstrap behavior approved for your environment
- IMDS or network interface settings beyond default wizard behavior

---

## 12. Fargate option - when to use it

Instead of EC2 worker nodes, some workloads can run on **AWS Fargate**.

**Use Fargate when:**
- you want serverless pod execution,
- you do not want to manage EC2 worker nodes,
- workloads are simple and fit the Fargate operating model.

**Do not choose Fargate blindly because:**
- it is not ideal for every workload,
- cost and limitations may differ from EC2-based nodes,
- some DaemonSet-heavy or privileged workloads may not fit well.

**What you typically create for Fargate:**
- Fargate profile name such as `fp-prod-default`
- namespace/label selectors
- pod execution role such as `eks-fargate-pod-execution-role`

**Service involved:**
- **AWS Fargate for EKS**
- **IAM**

---

## 13. Tags page - every component explained

Tags are often skipped, but they are very important.

### 13.1 What tags are used for

Tags help with:

- cost allocation,
- automation,
- access governance,
- inventory,
- reporting.

### 13.2 Recommended tags

| Tag key | Example value | Purpose |
|---|---|---|
| `Name` | `prod-eks-payments` | Resource identification |
| `Environment` | `prod` | Environment classification |
| `Application` | `payments` | Application mapping |
| `Owner` | `platform-team` | Ownership |
| `CostCenter` | `CC1001` | Cost reporting |
| `ManagedBy` | `console` / `terraform` | Operations clarity |

**Example tag set for a production cluster:**

| Key | Value |
|---|---|
| `Name` | `prod-eks-payments` |
| `Environment` | `prod` |
| `Application` | `payments` |
| `Owner` | `platform-team` |
| `CostCenter` | `CC1001` |
| `ManagedBy` | `console` |
| `Criticality` | `high` |

---

## 14. Review and create page - what to verify before clicking Create

Before you create the cluster, verify all important selections.

### Checklist before final submit

- [ ] Cluster name is correct
- [ ] Kubernetes version is `1.34` if available and approved
- [ ] Correct cluster IAM role is selected
- [ ] Cluster IAM role has the expected EKS trust relationship and `AmazonEKSClusterPolicy`
- [ ] Right VPC is selected
- [ ] At least two subnets in different AZs are selected
- [ ] Route tables / NAT / internet path are already validated
- [ ] API endpoint access model is correct
- [ ] Public CIDR is restricted if public access is enabled
- [ ] Secrets encryption decision is reviewed
- [ ] KMS key exists and is the correct regional key if encryption is enabled
- [ ] Required control plane logs are enabled
- [ ] Add-ons are selected appropriately
- [ ] Node group configuration matches workload needs
- [ ] Node IAM role exists with required policies
- [ ] Tags are added correctly

---

## 15. Sample custom configuration for a production-style cluster

This is a practical reference example.

| Item | Example value |
|---|---|
| Cluster name | `prod-eks-payments` |
| EKS version | `1.34` |
| Cluster IAM role | `eks-cluster-role-prod` |
| Cluster IAM policy | `AmazonEKSClusterPolicy` |
| VPC | `vpc-prod-shared-01` |
| Subnets | `private-subnet-a`, `private-subnet-b`, `private-subnet-c` |
| Endpoint access | `Public and Private` initially, with restricted public CIDR |
| Public CIDR | Office/VPN CIDR only |
| IP family | `IPv4` |
| Secrets encryption | Enabled with customer-managed KMS key |
| KMS key alias | `alias/eks-prod-secrets` |
| Control plane logs | `API`, `Audit`, `Authenticator`, `Scheduler`, `Controller manager` |
| Node group type | Managed node group |
| Node IAM role | `eks-node-role-prod` |
| Node role policies | `AmazonEKSWorkerNodePolicy`, ECR pull policy, commonly `AmazonEKS_CNI_Policy` |
| Node AMI | Supported general-purpose Linux AMI |
| Capacity type | `On-Demand` |
| Instance type | `m6i.large` (example) |
| Disk size | `50 GiB` |
| Min/Desired/Max | `2 / 2 / 6` |
| Node subnet | Private subnets only |
| Cluster admin role | `eks-admin-role-prod` |
| Tags | `Environment=prod`, `Application=payments`, `Owner=platform-team` |

---

## 16. Post-creation tasks

After the cluster is created, perform the following.

### 16.1 Update kubeconfig

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

### 16.2 Validate the cluster

```bash
kubectl get nodes
kubectl get pods -A
```

### 16.3 Verify add-ons

```bash
aws eks list-addons --cluster-name <cluster-name>
```

### 16.4 Verify endpoint access and logging

- Confirm the API endpoint is reachable only as intended.
- Confirm CloudWatch log groups are being created.

---

## 17. Common mistakes during EKS cluster creation

1. **Choosing the wrong subnets**
   - Causes connectivity, node join, or load balancer issues.

2. **Allowing public API access from everywhere**
   - Security risk.

3. **Using very small subnet CIDRs**
   - Leads to IP exhaustion.

4. **Not enabling useful control plane logs**
   - Makes troubleshooting harder later.

5. **Skipping secrets encryption in production**
   - Weakens security posture.

6. **Selecting unsupported or untested add-on combinations**
   - Can cause cluster instability.

7. **Creating the cluster but forgetting compute**
   - Control plane exists, but workloads cannot run.

8. **Not verifying version compatibility**
   - Especially for `1.34`, add-ons and applications must be checked.

---

## 18. Final recommendation

If you are creating an EKS cluster with **custom configuration** by console, focus on these decisions first:

1. **Correct Kubernetes version** (`1.34` only if available and tested)
2. **Correct VPC and private subnets**
3. **Secure API endpoint access**
4. **Proper IAM roles**
5. **Useful logging and encryption**
6. **Right node group sizing and instance type**
7. **Compatible add-ons**

If these are selected properly, the cluster foundation will be much more stable and secure.

---

## 19. Short summary

- Use **Custom configuration** for better control.
- Select **EKS 1.34** only if it is visible and approved.
- Prefer **private subnets** for nodes.
- Restrict **public API access**.
- Enable **logs** and **KMS encryption** where needed.
- Use a **managed node group** unless you need special customization.
- Always validate cluster access, add-ons, and node health after creation.

---

If needed, this document can be extended further with:

- screenshots-based step-by-step console flow,
- IAM role creation steps,
- VPC prerequisite design,
- managed node group creation with examples,
- EKS add-on compatibility checklist for version `1.34`.

