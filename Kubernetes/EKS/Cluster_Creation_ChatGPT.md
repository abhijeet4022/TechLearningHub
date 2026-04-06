🧭 1. What you’re building (big picture)

With Amazon Elastic Kubernetes Service (EKS), AWS manages the control plane, and you manage the worker nodes + networking + access.

Architecture overview
Control Plane (managed by AWS)
Kubernetes API server
etcd (cluster state)
Scheduler, controller manager
Data Plane (your responsibility)
Worker nodes (EC2 or Fargate)
Pods & containers
🏗️ 2. Step-by-step: Create EKS Cluster (Custom Config via Console)

Go to:
👉 AWS Console → EKS → Create cluster → Custom configuration

🔹 Step 1: Cluster Configuration
Fields you’ll see:
1. Cluster Name
   Example: my-eks-cluster
2. Kubernetes Version
   Choose latest stable (e.g., 1.29 or 1.30)
   Use case:
   New features, security patches
   Avoid very old versions (deprecated APIs)
3. Cluster Service Role (IAM)

👉 Uses AWS Identity and Access Management

Create or select role with:
AmazonEKSClusterPolicy

📌 Purpose:

Allows EKS control plane to:
Manage load balancers
Work with networking
Communicate with AWS services
4. Secrets Encryption (Optional but recommended)

👉 Uses AWS Key Management Service

Encrypt Kubernetes secrets at rest

📌 Use case:

Storing sensitive data (DB passwords, tokens)
🔹 Step 2: Networking

This is critical — most beginners struggle here.

1. VPC

👉 Uses Amazon Virtual Private Cloud

Choose existing or create new

📌 Best practice:

Use a VPC with:
Public subnets (for Load Balancer)
Private subnets (for nodes)
2. Subnets
   Select at least 2 subnets in different AZs

📌 Why:

High availability
3. Cluster Endpoint Access

Options:

Public
Private
Both

📌 Recommendation:

Both (Public + Private) for flexibility
4. Security Groups

👉 Uses **Amazon EC2 security groups

Controls traffic to control plane
🔹 Step 3: Logging (Optional but useful)
Enable:
API server logs
Audit logs

📌 Use case:

Debugging
Security monitoring
🔹 Step 4: Add-ons (Core components)

These are Kubernetes integrations managed by AWS:

1. CoreDNS
   Service discovery inside cluster
2. kube-proxy
   Networking rules for pods
3. VPC CNI plugin

👉 Uses Amazon VPC CNI

📌 Important:

Assigns IPs from VPC to pods
4. Optional Add-ons
   EBS CSI Driver → storage
   EFS CSI Driver → shared file system
   🔹 Step 5: Create Cluster

⏳ Takes ~10–15 minutes

🖥️ 3. Create Node Group (Worker Nodes)

After cluster is ready:

👉 Go to Cluster → Compute → Add Node Group

🔹 Node Group Components
1. Node IAM Role
   Attach policies:
   AmazonEKSWorkerNodePolicy
   AmazonEC2ContainerRegistryReadOnly
   AmazonEKS_CNI_Policy

📌 Purpose:

Allows nodes to:
Join cluster
Pull images
Configure networking
2. Instance Type

👉 EC2 instances like:

t3.medium (dev)
m5.large (prod)

📌 Use case:

Based on workload (CPU/memory)
3. Scaling Configuration
   Min / Max / Desired nodes

📌 Example:

Min: 2
Desired: 2
Max: 5
4. Disk Size
   Default: 20GB
   Increase if:
   Large containers
   Logs
5. Subnets
   Use private subnets

📌 Why:

Security (no direct internet exposure)
🌐 4. How everything works together
Flow:
You deploy app → kubectl
Request hits EKS API server
Scheduler assigns pod to node
Node pulls image (ECR/DockerHub)
Pod gets IP from VPC CNI
Service exposes via Load Balancer
📦 5. Optional (but important in real setups)
🔸 Load Balancer Controller

👉 Uses AWS Load Balancer Controller

Creates ALB/NLB automatically

📌 Use case:

Expose apps to internet
🔸 Storage

👉 Uses:

Amazon Elastic Block Store → block storage
Amazon Elastic File System → shared storage
🔸 Container Registry

👉 Use Amazon Elastic Container Registry

Store Docker images
🔸 Secrets

👉 Use:

AWS Secrets Manager
AWS Systems Manager Parameter Store
🔐 6. Accessing the Cluster

Use:

aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
⚠️ 7. Common mistakes (very important)
❌ Wrong subnets (no route to internet)
❌ Missing IAM roles/policies
❌ Not using private subnets for nodes
❌ IP exhaustion (VPC CIDR too small)
❌ Not enabling logging
🧠 8. When to use what (quick summary)
Component	Use Case
EKS	Managed Kubernetes
VPC	Network isolation
IAM	Permissions
EC2 Nodes	Run workloads
Fargate	Serverless pods
ECR	Store images
ALB Controller	Expose apps
EBS/EFS	Storage