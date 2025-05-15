### 1. How do you handle credentials for a PHP application accessing MySQL or any other secrets in Docker?
- Use AWS Systems Manager Parameter Store or environment variables and pass them securely via docker-compose or Kubernetes Secrets.

### 2. What is the command to check running container logs?
- `docker logs <container_id>`

### 3. Have you upgraded any Kubernetes clusters?
- No

### 4. How do you deploy an application in a Kubernetes cluster?
- Create a Deployment YAML File and apply it using `kubectl apply -f <filename>.yaml` or using command line `kubectl run <deployment_name> --image=<image_name> --port=<port_number>`.
- Then expose the deployment using `kubectl expose deployment <deployment_name> --type=NodePort --port=<port_number> --target-port=<port_number> --name=<service_name>`.

### 5. How do you communicate with a Jenkins server and a Kubernetes cluster?
- To communicate with a Jenkins server and a Kubernetes cluster (like EKS), Jenkins interacts with Kubernetes using the Kubernetes plugin or by directly configuring the server with the necessary credentials to access the Kubernetes API.

Here's how the integration typically works:

- **Kubernetes Plugin in Jenkins**: First, you need to install the Kubernetes plugin in Jenkins. This plugin helps Jenkins communicate with Kubernetes, manage pods, and perform tasks like deployments.
- **Update the kubeconfig File**: To allow Jenkins to communicate with the Kubernetes cluster, you need to ensure that the Jenkins server has access to the kubeconfig file. This file contains the necessary credentials and connection details to access the Kubernetes cluster. For EKS, you can update the kubeconfig file by using the AWS CLI command:
    ```bash
    aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
    ```
  This command will update the local kubeconfig file with the necessary credentials for accessing the EKS cluster.
- **Jenkins Configuration**: Once the kubeconfig file is available, you can configure Jenkins to use it. In Jenkins, go to `Manage Jenkins > Configure System` and configure the Kubernetes Cloud section to provide the necessary connection details. Jenkins can either use the local kubeconfig or you can store it as a secret and pass it via pipeline scripts.

### 6. Can you describe the CI/CD workflow in your project?
- **Code Commit**: Developers push code to GitHub, triggering a Jenkins pipeline via a webhook.
- **Jenkins Pipeline**:
    1. **Source Code Checkout (Tags, New Releases, etc.)**:
        - Pull the latest source code from the repository to ensure you're working with the most recent updates or specific tags for releases.
    2. **Build (Downloading Dependencies and Compiling)**:
        - Install necessary dependencies and compile the code to prepare it for testing and deployment.
    3. **Testing (Unit Testing or Integration Testing)**:
        - Run unit tests and integration tests to ensure the code behaves as expected.
    4. **Source Code Analysis (SAST) (SonarQube)**:
        - Perform static application security testing (SAST) with tools like SonarQube to identify potential vulnerabilities and code quality issues.
    5. **Image Creation (Dockerfiles)**:
        - Create a Docker image of the application by following the Dockerfile instructions to ensure portability and consistency.
    6. **Image Scanning (Trivy)**:
        - Scan the Docker image for known security vulnerabilities using tools like Trivy to ensure it's secure before deployment.
    7. **Publishing Artifacts (Docker Hub, ECR)**:
        - Push the built and scanned Docker image to container registries like Docker Hub or AWS ECR (Elastic Container Registry) for storage and retrieval.
    8. **Deployment (EKS)**:
        - Deploy the application to Kubernetes (EKS in this case), scaling and managing the application as needed.
    9. **DAST (OWASP)**:
        - Perform dynamic application security testing (DAST) to test the running application for vulnerabilities by simulating attacks.
    10. **Post-Deployment Checks**:
        - Verify that the application is running successfully in the production environment, monitor logs, and run smoke tests to ensure everything is functioning correctly.

### 7. How do you handle the continuous delivery (CD) aspect in your projects?
- By automating the deployment process using Jenkins pipelines and Kubernetes, ensuring that the code is pushed to production after thorough testing.

### 8. What methods do you use to check for code vulnerabilities?
- **SonarQube**: Used for static code analysis to ensure code quality by identifying issues such as bugs, code smells, and potential security vulnerabilities.
- **Checkmarx**: Employed for static application security testing (SAST), which helps identify and mitigate vulnerabilities in the codebase, such as SQL injection, cross-site scripting (XSS), and other security flaws.
- **OWASP Dependency-Check**: This tool is used to check for known vulnerabilities in the project’s dependencies. It scans the project's libraries against known vulnerability databases to identify outdated or vulnerable packages.

### 9. What AWS services are you proficient in?
- EC2, S3, IAM, RDS, Lambda, CloudWatch, VPC, EKS, Route 53.

### 10. How would you access data in an S3 bucket from Account A when your application is running on an EC2 instance in Account B?
- By setting the appropriate bucket policy or using IAM roles to grant cross-account access. Then we have to use AWS CLI to access the bucket.

### 11. How do you provide access to an S3 bucket, and what permissions need to be set on the bucket side?
- We will set the bucket policy with:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::bucket-name/*",
          "Condition": {
            "StringEquals": {
              "aws:PrincipalArn": "arn:aws:iam::Account-B-ID:role/EC2RoleName"
            }
          }
        }
      ]
    }
    ```

### 12. How do you pass arguments to a VPC while using the `terraform import` command?
- By passing the VPC ID using the terraform import command in the format:
    ```bash
    terraform import aws_vpc.example_vpc <vpc_id>.
    ```

### 13. What are the prerequisites before importing a VPC in Terraform?
- Ensure that the VPC exists, and that the corresponding Terraform resource type (`aws_vpc`) is defined in the configuration.

### 14. If an S3 bucket was created through Terraform but someone manually added a policy to it, how do you handle this situation using IaC?
- If the S3 bucket was already created by Terraform, then we can fetch the policy and include it in the Terraform code and apply it.
- If the bucket was created manually, we can import the bucket completely with the policy.
- Or if we don't want the manual policy, we will run `terraform apply`, and it will remove the manual policy and apply the policy in the Terraform code.

### 15. For an EC2 instance in a private subnet, how can it verify and download required packages from the internet without using a NAT gateway or bastion host? Are there any other AWS services that can facilitate this?
- You can use AWS PrivateLink or VPC endpoints for services like S3 or DynamoDB, or configure an S3 bucket as a private repository.
- The two types of endpoints in AWS are:
  - Interface Endpoint – Uses AWS PrivateLink to connect services via ENIs (Elastic Network Interfaces) in your VPC.
  - Gateway Endpoint – Creates a route in your VPC's route table to access AWS services (S3 and DynamoDB) without using the internet.

### 16. What is the typical latency for a load balancer, and if you encounter high latency, what monitoring steps would you take?
- Latency is typically under 100ms for load balancers. To monitor, check CloudWatch metrics, analyze request patterns, and review backend server performance.

### 17. If your application is hosted in S3 and users are in different geographic locations, how can you reduce latency?
- To reduce latency for users in different geographic locations, we can leverage Amazon CloudFront. By distributing the content to edge locations worldwide, CloudFront caches and serves the content from the closest server to the user. This minimizes the distance between the user and the content, thereby reducing latency and improving load times.
- Yes, when you deploy Amazon CloudFront as a CDN (Content Delivery Network), all edge locations are automatically available by default, unless you configure it differently.

### 18. Which services can be integrated with a CDN (Content Delivery Network)?
- S3, EC2, Elastic Load Balancers, and MediaStore can be integrated with a CDN like AWS CloudFront.

### 19. How do you dynamically retrieve VPC details from AWS to create an EC2 instance using IaC?
- Use the `aws_vpc` data source in Terraform to dynamically retrieve VPC details and then use them in the EC2 instance creation resource.

### 20. How do you manage unmanaged AWS resources in Terraform?
- Use the `terraform import` command to import the unmanaged resources into Terraform state.
- Steps to Manage Unmanaged AWS Resources in Terraform are:
  - Identify the existing AWS resource and note its ID.
  - Write the corresponding Terraform resource block (without applying it).
  - Import the resource: terraform import <resource_type>.<resource_name> <resource_id>
  - Verify the imported resource: terraform show
  - Update the Terraform configuration using the output from terraform show.
  - Check for changes: terraform plan
  - Apply the final configuration: terraform apply
- Note: terraform.tfstate.lock.info  - State lock file

### 21. Write BASH Script to back up files and delete older than 30-day backup.
```bash
#!/bin/bash

# Define backup location and source file
BACKUP_DIR="/tmp/backup"
SOURCE_FILE="/etc/ssh/sshd_config"
DATE=$(date +'%Y-%m-%d_%H-%M-%S') # Date format for backup filename

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup of the source file
cp "$SOURCE_FILE" "$BACKUP_DIR/sshd_config_backup_$DATE"

# Remove backups older than 30 days
find "$BACKUP_DIR" -name "sshd_config_backup_*" -type f -mtime +30 -exec rm -f {} \;

# Optional: Print success message
echo "Backup completed successfully, and old backups removed."
```

## 𝐉𝐞𝐧𝐤𝐢𝐧𝐬

### Jenkins High Availability Architecture in AWS

- 1. **Multiple Jenkins Masters (EC2 Instances)**
  - Two or more **Jenkins masters** (EC2 instances) are deployed in different **Availability Zones** to ensure high availability.
  - Both masters share the same **Jenkins home directory**, which is mounted via **Amazon EFS** (Elastic File System) for a shared, durable file system.

- 2. **AWS Load Balancer (ALB - Application Load Balancer)**
  - **ALB** distributes incoming Jenkins web traffic across the Jenkins masters to ensure high availability.
  - **Health checks** are set up to ensure only healthy Jenkins masters receive traffic.

- 3. **Amazon EFS for Shared Storage**
  - **Amazon EFS** is used to store the Jenkins data (`/var/jenkins_home`), ensuring that all Jenkins instances (both masters and agents) have access to the same data.
  - **EFS** ensures that Jenkins configuration, job histories, and artifacts are always available to any active master node.

- 4. **Jenkins Agents (EC2 Instances)**
  - **Jenkins agents** are deployed across **EC2 instances** (or even **ECS tasks**) to perform builds.
  - These agents can be distributed in multiple **availability zones** for fault tolerance.
  - **Dynamic provisioning** of agents can be achieved using EC2 instances, or by utilizing AWS ECS for scalability.

- 5. **RDS (Optional)**
  - If needed, you can use **Amazon RDS** (MySQL/PostgreSQL) for storing Jenkins metadata such as job logs and build history.
  - **RDS** offers high availability using **Multi-AZ deployments**.

- 6. **Monitoring (CloudWatch/Prometheus)**
  - **AWS CloudWatch** can be used for monitoring the performance of EC2 instances and Jenkins health.
  - **Prometheus** and **Grafana** can be integrated to collect and visualize Jenkins metrics for better performance tracking.

- 7. **Backup**
  - Backup the Jenkins data using **Amazon S3** for periodic backups of the Jenkins home directory.
  - Alternatively, **EBS snapshots** can be used to capture consistent backups of the EC2 instances running Jenkins.

### How can you configure a Jenkins pipeline to run all stages by default, but allow running only a specific stage when needed?
- You can use a parameter to control which stage to run, and by default, the pipeline will run all the stages. If you only want to run a specific stage, you can set a parameter that determines which stage to run.
```groovy
pipeline {
    agent any
    parameters {
        choice(
            name: 'STAGE_TO_RUN', 
            choices: ['ALL', 'STAGE_1', 'STAGE_2', 'STAGE_3'], 
            description: 'Select the stage to run'
        )
    }
    stages {
        stage('Stage 1') {
            when {
                expression { params.STAGE_TO_RUN == 'ALL' || params.STAGE_TO_RUN == 'STAGE_1' }
            }
            steps {
                echo 'Running Stage 1'
                // Add your Stage 1 steps here
            }
        }

        stage('Stage 2') {
            when {
                expression { params.STAGE_TO_RUN == 'ALL' || params.STAGE_TO_RUN == 'STAGE_2' }
            }
            steps {
                echo 'Running Stage 2'
                // Add your Stage 2 steps here
            }
        }

        stage('Stage 3') {
            when {
                expression { params.STAGE_TO_RUN == 'ALL' || params.STAGE_TO_RUN == 'STAGE_3' }
            }
            steps {
                echo 'Running Stage 3'
                // Add your Stage 3 steps here
            }
        }

        // Add more stages as needed...
    }
}
```

### Create a pipeline if test case A fails then try test case B if both fail come out from the pipeline.
```groovy
pipeline {
    agent any

    stages {
        stage('Conditional Testing') {
            steps {
                script {
                    def resultA = sh(script: './run-test-a.sh', returnStatus: true)
                    if (resultA != 0) {
                        echo 'Test Case A failed. Trying Test Case B...'

                        def resultB = sh(script: './run-test-b.sh', returnStatus: true)
                        if (resultB != 0) {
                            echo 'Test Case B also failed. No further tests run.'
                        } else {
                            echo 'Test Case B passed.'
                        }
                    } else {
                        echo 'Test Case A passed.'
                    }
                }
            }
        }
    }
}
```

### How do you integrate unit testing, integration testing, and end-to-end testing into a Jenkins pipeline?
- By using separate stages for each testing type in the Jenkins pipeline. Unit tests run first, followed by integration tests, and then end-to-end tests.

### How do you troubleshoot common Jenkins issues, such as build failures or performance problems?
- Troubleshooting Jenkins issues involves analyzing logs, checking system performance, and ensuring configurations are correct.

#### Common Issues & Solutions:

**Build Failures:**
- Check console output in Jenkins UI (Build > Console Output).
- Verify dependencies, configurations, and environment variables.
- Rerun failed steps manually to pinpoint errors.

**Performance Issues:**
- Monitor system resources (top, htop, or Windows Task Manager).
- Increase JVM heap size (-Xmx and -Xms settings in jenkins.xml).
- Archive old builds and limit logs to reduce disk space usage.

**Stuck or Hanging Builds:**
- Check if an external dependency (like a database or API) is unresponsive.
- Manually kill stuck processes using `kill -9 <PID>`.

**Pipeline Execution Errors:**
- Validate syntax using `jenkins-linter`.
- Check plugin compatibility and update if necessary.

**Log Analysis:**
- Jenkins logs are in `/var/log/jenkins/jenkins.log` (Linux) or `C:\Program Files (x86)\Jenkins\jenkins.out.log` (Windows).
- Use `tail -f /var/log/jenkins/jenkins.log` to view real-time logs.

**Plugin Management:**
- Regularly update Jenkins and plugins via Manage Jenkins > Plugin Manager.
- Disable unused plugins to reduce overhead.

**Monitoring & Alerts:**
- Use Prometheus & Grafana for Jenkins monitoring.
- Configure email or Slack notifications for failed builds.

### How do you configure a Jenkins job to trigger automatically on code changes in a Git repository?
1. **Install the Required Plugin:**
    - Go to Manage Jenkins > Plugin Manager > Available.
    - Search for "GitHub Branch Source Plugin."
    - Install the plugin and restart Jenkins.

2. **Generate the Webhook URL in Jenkins:**
    - Go to Jenkins Dashboard.
    - Open Your Multibranch Pipeline Job.
    - Click "Configure".
    - Scroll down to "Scan Multibranch Pipeline Triggers."
    - Enable "GitHub Hook Trigger for GITScm Polling".
    - Pass one token and then click on ? symbol to copy the URL.
    - Save the Configuration.

3. **Add the Webhook to GitHub:**
    - Go to GitHub Repo > Settings > Webhooks.
    - Click "Add Webhook."
    - Paste the Jenkins webhook URL (`http://<jenkins-server>:8080/github-webhook/`).
    - Set Content Type to `application/json`.
    - Select "Just the push event."
    - Click "Add Webhook."

## 𝐋𝐢𝐧𝐮𝐱

### How do you monitor the CPU and memory of the Linux systems?
- By using tools like `top`, `htop`, `vmstat`, `sar`, or integrating with monitoring solutions like Prometheus and Grafana.

### How to find the 30 days old files and delete those files?
- `find /path/to/directory -type f -mtime +30 -exec rm {} \;`

### How do you manage file systems using fsck, mount, and umount?
- `fsck` is used to check and repair file systems, `mount` to attach a file system to the system, and `umount` to detach a mounted file system.

### How do you secure a Linux system using iptables or firewalld?
- By configuring firewall rules to restrict inbound and outbound traffic based on ports, IP addresses, and protocols using `iptables` or `firewalld`.


## 𝐀𝐧𝐬𝐢𝐛𝐥𝐞
### What is dynamic inventory in ansible and how do you manage it?

In Ansible, an inventory is a list of managed nodes. A dynamic inventory allows Ansible to fetch this list dynamically from external sources such as cloud providers (AWS, Azure, GCP), databases, or APIs, instead of using a static file.

This is particularly useful in cloud environments where servers are provisioned or terminated dynamically. Instead of manually updating an inventory file, Ansible can query live instances and retrieve host information on demand.

### Example: Configuring Dynamic Inventory for AWS EC2 using Inventory Plugin

**Step 1: Install Required Dependencies**

Before setting up the inventory, install the boto3 and botocore Python libraries, which allow Ansible to interact with AWS.

```bash
pip install boto3 botocore
```

**Step 2: Create an AWS EC2 Inventory File (`aws_ec2.yml`)**

```yaml
plugin: amazon.aws.aws_ec2  # Specifies the AWS EC2 inventory plugin
regions:
  - ap-southeast-1          # Define the AWS region(s) to query instances from
keyed_groups:
  - key: tags.Name          # Group EC2 instances based on their "Name" tag
    prefix: instance_       # Prefix groups with "instance_" (e.g., instance_webserver)
filters:
  instance-state-name: running  # Only include running instances
compose:
  ansible_host: public_ip_address  # Use the public IP for SSH connections
```

**Step 3: Test the Inventory Configuration**

Run the following command to retrieve a list of AWS EC2 instances dynamically:

```bash
ansible-inventory -i aws_ec2.yml --list
```

This will output a real-time inventory of all running instances in `ap-southeast-1`, grouped by their tags.

**Step 4: Use Dynamic Inventory in a Playbook**

Once the dynamic inventory is working, you can use it in an Ansible playbook.

```bash
ansible-playbook -i aws_ec2.yml playbook.yml
```

This ensures that Ansible runs on the latest set of instances without manually updating inventory files.



### Can you design a playbook with notifiers and handlers for 10 tools installations?

```yaml
---
- name: Install and Restart Nginx
  hosts: all
  become: yes
  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present
      notify: restart nginx

  handlers:
    - name: restart nginx
      service:
        name: nginx
        state: restarted
```

## 𝐊𝐮𝐛𝐞𝐫𝐧𝐞𝐭𝐞𝐬

### Design the kubernetes manifest file to create the CronJob with concurrency as forbid and to run for every 1 minute with nginx container having tag as latest
- No ANS

### What will be the command to add the annotation and the labels for the existing pod?

```bash
kubectl label pod my-pod app=nginx
kubectl annotate pod my-pod description="This is a test pod"
```

### Design the kubernetes cluster with Ingress.
Here is an example of how to set up an Ingress in a Kubernetes cluster:

Create a deployment for the application:

```yaml
# Create Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: my-app-image
          ports:
            - containerPort: 80
---
# Create a Service to expose the app:
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
---
# Create an Ingress resource:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: my-app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app-service
                port:
                  number: 80
```

### A sudden surge in traffic causes a web application to become unresponsive what will be the steps you will take to mitigate
- Horizontal Scaling: Use Kubernetes Horizontal Pod Autoscaler to scale the number of pods based on traffic.

```bash
kubectl autoscale deployment my-app --cpu-percent=50 --min=1 --max=10
```
- Check resource limits: Ensure that resource requests and limits are set appropriately for the pods.
- Optimize Ingress Controller: Make sure the Ingress controller is well-configured to handle traffic efficiently.
- Use a Load Balancer: Ensure there is a proper load balancer to distribute traffic evenly across the pods.
- Caching: Implement caching at multiple levels (e.g., Redis for session or content caching).
- Review Logs and Metrics: Use monitoring tools like Prometheus and Grafana to diagnose the root cause of the issue.

### What are load balancer options in kubernetes?

Ingress:
An Ingress is a Kubernetes resource that defines rules for routing HTTP or HTTPS traffic to backend services. It defines which URLs should go to which service and may also configure things like SSL termination, path-based routing, and more.

Ingress Controller:
The Ingress Controller is a pod or set of pods that watch for changes to Ingress resources and enforce the rules defined there. The controller listens for Ingress resources in the cluster and configures a load balancer or reverse proxy to handle the traffic.

Types of Load Balancing in Kubernetes:

- **Internal Load Balancing (within the Cluster)**
    - Services: Kubernetes services handle internal load balancing for traffic between pods within the cluster. The most common service types for load balancing include ClusterIP, NodePort, and LoadBalancer.

- **External Load Balancing (from outside the Cluster)**
    - Ingress: The Ingress Controller can also function as an external load balancer by routing HTTP/S traffic from external clients to different services based on rules.
    - LoadBalancer Service: A service type that can provision an external load balancer to route traffic from outside the cluster to pods in the cluster.

### Design the deployment of the pod with replica set as 3 and having apache httpd image running as a container.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd:latest
        ports:
        - containerPort: 80
```

## 𝗖𝗜/𝗖𝗗

### How do you integrate automated testing into a CI/CD pipeline for ETL jobs?
- **Unit Testing**: Write unit tests for individual ETL components, ensuring they process data correctly.
- **Integration Testing**: Test the ETL pipeline with actual data to ensure that data flows correctly from source to target.
- **Automate in Pipeline**: Set up automated testing in Jenkins, GitLab CI, or any CI/CD tool after the ETL job is triggered, and run tests on every code push.
- **Data Validation**: Use data validation frameworks to check data integrity after transformations.

### How do you manage environment-specific configurations in a CI/CD pipeline?
- **Environment Variables**: Use environment variables to configure settings specific to each environment (e.g., dev, qa, prod).
- **Config Files**: Store environment-specific configurations in separate config files (e.g., config-dev.yaml, config-prod.yaml).
- **Parameterize Pipelines**: Use CI/CD tool features like Jenkins pipeline parameters or GitLab CI environment variables to inject the correct configuration based on the environment.

## 𝐃𝐨𝐜𝐤𝐞𝐫

### How do you ensure the security of Docker images and containers?
- **Use Trusted Base Images**: Always start with official or trusted images (e.g., nginx:latest, node:14-alpine).
- **Create Docker Registry Token for Images While Pulling the Images**
- **Using Environment Variables for Sensitive Information**
- **Exposing Only Required Services to the External World**
- **Scan for Vulnerabilities**: Use tools like Trivy, Clair, or Anchore to scan images for vulnerabilities.
- **Minimize Image Size**: Use minimal base images to reduce the attack surface.
- **Least Privilege**: Run containers with the least privileges by using USER in Dockerfile and avoiding running as root.
- **Secure Network Communication**: Ensure secure communication by using Docker Compose or Kubernetes network policies to control traffic between containers.

### How does Docker handle network communication between containers?
- **Docker Networks**: Docker creates networks to allow containers to communicate. By default, containers on the same network can communicate with each other by using container names as DNS names.
  Example: `docker network create my-network`
  To connect a container to a network: `docker run --network my-network my-container`

- **Bridge Network**: Default network mode, where containers can communicate using their IP addresses or container names. By default all containers within the same bridge network can communicate with each other. And to communicate between different bridge networks, we need to use `docker network connect` command.

- **Host Network**: The container shares the host’s network stack.

- **Overlay Network**: For multi-host communication in Docker Swarm or Kubernetes.

## 𝗣𝘆𝘁𝗵𝗼𝗻
- What are the key differences between Python 2 and Python 3?
- How do you integrate Python with popular DevOps tools like Jenkins and Ansible?
- How do you use Python to interact with cloud platforms like AWS, GCP, and Azure?
- How do you troubleshoot Python scripts in a DevOps environment?
- What are the benefits of using Python for configuration management over other tools?


# Praveen Kumar

## 1. How to gracefully shutdown a container giving it time to close all connections?

- `kubectl delete pod <pod-name>`
- Kubernetes waits for a grace period defined by `terminationGracePeriodSeconds` (default: 30 seconds).
- If the pod does not shut down within the `terminationGracePeriodSeconds`, Kubernetes sends SIGKILL (force kill). This immediately stops the pod without allowing further cleanup.
- To delete forcefully: `kubectl delete pod <pod-name> --grace-period=0 --force`

## 2. How to view errors in a pod even after pod has restarted?

- Use `kubectl logs --previous <pod-name>` to view logs from a crashed container.
- If logs are sent to a persistent log store (e.g., ELK, CloudWatch), retrieve them from there.

## 3. How to integrate ELK stack with Kubernetes cluster?

- Deploy Filebeat or Fluentd as a DaemonSet to collect logs.
- Send logs to Elasticsearch and visualize them in Kibana.
- Use `helm install elasticsearch`, `helm install kibana`, and configure Fluentd/Filebeat accordingly.

## 4. What kind of Grafana dashboards have you setup?

- Dashboards for Kubernetes metrics (CPU, memory, pod health, node status) using Prometheus as a data source.

## 5. How do you configure alerts in Grafana?

### Steps to Send Grafana Alerts to Slack

1. **Get a Slack Webhook URL**
    - Go to your Slack workspace.
    - Create an incoming webhook:
        - Visit: [Slack Incoming Webhooks](https://api.slack.com/messaging/webhooks).
        - Choose a channel (e.g., `#alerts`).
        - Click **Add Incoming Webhook** and copy the Webhook URL.

2. **Add Slack as a Notification Channel in Grafana**
    - Open Grafana and go to **Alerting → Notification Channels**.
    - Click **New Notification Channel**.
    - Set the following fields:
        - **Name**: `Slack-Alerts`
        - **Type**: Select `Slack`
        - **Slack Webhook URL**: Paste the webhook URL from Step 1.
        - **Mention Users/Groups (Optional)**: Add `@user` or `@channel` for notifications.
        - **Message**: Customize the alert message (Optional).
        - **Include Image**: If enabled, it sends a snapshot of the graph.
    - Click **Save**.

3. **Create an Alert Rule in Grafana**
    - Open your Grafana Dashboard.
    - Click on the panel you want to set an alert for.
    - Click **Edit Panel → Go to the Alert tab**.
    - Click **Create Alert Rule**.
    - Set the Condition (e.g., CPU usage > 80% for 5 min).
    - Choose the evaluation interval (e.g., every 30s).
    - Under **Notifications**, select the `Slack-Alerts` channel.
    - Click **Save**.

4. **Test the Slack Alert**
    - Click **Test Rule** in Grafana.
    - If configured correctly, you will receive a message in Slack when the condition is met.

**Note:** Grafana is primarily a visualization tool, but Grafana Alerting is a built-in feature that allows it to send alerts directly. It does not just display alerts but can also trigger notifications when certain conditions are met.

## 6. Write a Dockerfile for multistage build.

```dockerfile
# 1st Stage: Build
FROM node:18 as builder
WORKDIR /app
COPY server.js package.json ./
RUN npm install

# 2nd Stage: Production
FROM node:18-slim
WORKDIR /app/
COPY --from=builder /app/package.json /app/server.js /app/node_modules /app/
CMD ["node", "server.js"]
```
## 7. Why are multi-stage Dockerfiles used?

- Reduce image size by excluding build dependencies.
- Improve security by using minimal base images.
- Optimize performance by separating build and runtime stages.

## 8. What is the difference between CMD and ENTRYPOINT?

- **CMD**: Default command but can be overridden at runtime.
- **ENTRYPOINT**: Defines the main executable and cannot be overridden easily.

## 9. Can you explain the architecture of Kubernetes?

- **Master Node Components**: API Server, Controller Manager, Scheduler, etcd.
- **Worker Nodes**: Kubelet, Kube Proxy, Container Runtime.
- Uses a Control Plane to manage the cluster.

## 10. What are the different types of services in Kubernetes?

- **ClusterIP**: Internal communication within the cluster.
- **NodePort**: Exposes service on a node’s port.
- **LoadBalancer**: Uses a cloud provider's load balancer.

## 11. What is the difference between LoadBalancer service and Ingress?

- **LoadBalancer**: Exposes a service externally with a cloud-based LB.
- **Ingress**: Provides routing rules for multiple services via a single entry point.

## 12. What are labels used for in deployment?

- Used for organizing, selecting, and filtering resources (e.g., `kubectl get pods -l app=nginx`).

## 13. How to rollback a deployment to a previous version?

To roll back a Kubernetes deployment to a previous version, you can use the following command:
```bash
kubectl rollout undo deployment <deployment-name>
```

If you want to roll back to a specific revision, you can use the `--to-revision` flag:
```bash
kubectl rollout undo deployment <deployment-name> --to-revision=<revision-number>
```

### How to do rollout for new version of image.
```bash
kubectl set image deployment/my-app my-app-container=my-app:v2
kubectl rollout status deployment/my-app

```

### How to check roll out history
```bash
kubectl rollout history deployment/my-app
kubectl rollout history deployment/my-app --revision=3
```

## 14. What are the different types of networks in Docker?

- **Bridge** (default)
- **Host**
- **Overlay**
- **Macvlan**
- **None**

## 15. How to secure Docker containers?

- Use non-root users
- Enable seccomp/apparmor
- Restrict capabilities
- Scan for vulnerabilities
- Create Docker registry token for images while pulling the images
- Pass secrets with Docker secrets
- Use environment variables for sensitive information
- Expose only required services to external world
- Use IAM roles for specific access

## 16. What is the difference between a ConfigMap and Secret in Kubernetes?

In Kubernetes, ConfigMap and Secret are used to store configuration data, but the main difference lies in how they handle the data, especially when it comes to sensitive information.

### ConfigMap
- **Purpose**: Stores non-sensitive, often plain-text configuration data such as application settings, environment variables, or configuration files.
- **Data**: ConfigMap data is stored as key-value pairs, and the data is typically not encoded or encrypted.

### Secret
- **Purpose**: Stores sensitive data such as passwords, API keys, TLS certificates, etc. Secrets are base64-encoded by default to provide a layer of obfuscation, but they are not encrypted by default (though you can configure Kubernetes to encrypt them at rest).
- **Data**: Sensitive data should be stored in a Secret to ensure better management and control, although base64 encoding is just an encoding mechanism, not encryption.

## 17. Difference between Terraform taint, refresh, and import?

- **taint**: Forces resource recreation.
- **refresh**: Updates Terraform state file.
- **import**: Brings existing infrastructure into Terraform.

## 18. What is the difference between grep, sed, and awk command?

- **grep**: Search text.
- **sed**: Stream editor for modifying text.
- **awk**: Advanced text processing.

## 19. How to check which ports are open in a VM?

- **Linux**: `netstat -tulnp` or `ss -tulnp`
- **Windows**: `netstat -ano`

## 20. How to extend a LVM?

```bash
yum install cloud-utils-growpart
growpart /dev/xvdh 1
pvresize /dev/xvdh1
lvextend -L +10G /dev/mapper/vg-lv
resize2fs /dev/mapper/vg-lv or xfs_growfs /dev/mapper/vg-lv
```

## 21. How to extend root volume of an EC2 instance without downtime?

Modify EBS volume size → Resize file system with `growpart` & `resize2fs`.

## 22. Write a shell script to find files older than 30 days and delete them.

```bash
find /path/to/dir -type f -mtime +30 -exec rm -f {} \;
```

or

```bash
find /path/to/dir -type f -mtime +30 -delete
```

## 23. What are handlers in Ansible? What do they do?

In Ansible, a handler is a special type of task that is triggered only when notified by other tasks. Handlers are typically used for actions that should only be performed when there are changes in the system, such as restarting a service or reloading a configuration file, rather than running the task unconditionally.

## 24. What is the folder structure of Ansible directory?

```
ansible_project/
│
├── inventory/                  # Hosts file or inventory, containing the list of target machines
│   ├── production              # Example of an inventory file for a production environment
│   └── staging                 # Example of an inventory file for a staging environment
│
├── roles/                      # Directory containing roles (modular, reusable units)
│   └── nginx/                  # Example of a role for configuring Nginx
│       ├── tasks/              # Tasks define the main actions to be performed
│       │   └── main.yml        # Main task file for the role (e.g., installing/configuring nginx)
│       │
│       ├── handlers/           # Handlers to manage specific services or actions (triggered by tasks)
│       │   └── main.yml        # Handler file for the role (e.g., restarting nginx)
│       │
│       ├── templates/          # Jinja2 templates to be used in the tasks (configuration files, etc.)
│       │   └── nginx.conf.j2   # Example of a template for nginx.conf
│       │
│       ├── vars/               # Variables specific to the role
│       │   └── main.yml        # Define variables for Nginx configuration
│       │
│       ├── defaults/           # Default variables for the role (can be overridden in playbooks)
│       │   └── main.yml        # Default values for variables
│       │
│       └── meta/               # Metadata for the role (role dependencies, author, etc.)
│           └── main.yml        # Role metadata (e.g., dependencies, author info)
│
├── group_vars/                 # Variables that are defined for specific groups of hosts
│   └── all/                    # Variables applicable to all hosts in the group
│       └── main.yml            # Variables for all hosts
│
├── host_vars/                  # Variables for specific hosts
│   └── server1/                # Variables for a specific host
│       └── main.yml            # Variables for specific host
```

## 25. Which module is used in Ansible for API calls?

The `uri` module in Ansible is used to make HTTP requests to a specified API endpoint or URL. It allows you to interact with web services and APIs by sending GET, POST, PUT, DELETE, or other HTTP methods, making it a powerful tool for interacting with RESTful APIs.

## 26. Can you write a playbook to install Nginx and copy a configuration file into it?

```yaml
- hosts: web
  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present
    - name: Copy config
      copy:
        src: nginx.conf
        dest: /etc/nginx/nginx.conf
```

## 27. I have many plays in a playbook but I want only few plays in it to run. How can I achieve it?

Use `--tags` or `--start-at-task`.

- To run the playbook starting from the "Copy nginx configuration" task, use the following command:

```bash
ansible-playbook playbook.yml --start-at-task="Copy nginx configuration"
```

- To run only the tasks tagged with install (in this case, only the "Install nginx" task):

```bash
ansible-playbook playbook.yml --tags install
```

## 28. I have a playbook whose logs I want no one to see while running. How to achieve it?

In Ansible, `no_log: true` is used to suppress task output and hide sensitive information (such as passwords or API keys) from being printed to the console or logs. It prevents any output (including errors) for tasks where you want to ensure confidentiality.

## 29. What is the difference between Deployment and StatefulSet?

In Kubernetes, Deployment and StatefulSet are both controllers used to manage the lifecycle of pods, but they serve different purposes:

### Deployment
Manages stateless applications. It ensures that a specified number of identical pods are running at any given time, making it ideal for applications that don't require persistent storage or stable identities (e.g., web servers).

**Key Features**:
- Pods are interchangeable (stateless)
- No persistent storage or stable network identity
- Supports rolling updates and rollback

### StatefulSet
Manages stateful applications. It ensures that each pod has a stable, unique identity and can retain persistent storage. It's used for applications that require stable network identities, persistent storage, or ordered deployment (e.g., databases).

**Key Features**:
- Pods are not interchangeable (stateful)
- Stable network identity and persistent storage (e.g., Persistent Volumes)
- Ensures ordered deployment, scaling, and updates

## 30. I have 3 replicas of a deployment, but I want only 1 pod to schedule on each node only. How to achieve it?

To ensure that only one pod of your deployment is scheduled on each node, you can use a Pod Anti-Affinity rule. This rule ensures that the scheduler places pods in such a way that they don't end up on the same node, effectively spreading the pods across different nodes.

## 31. What is a provisioner in Terraform?

In Terraform, a provisioner is a mechanism used to execute scripts or commands on resources after they have been created or updated. Provisioners are typically used to perform tasks that require interacting with the newly created infrastructure, such as installing software, configuring settings, or running initialization scripts.

## 32. How does Terraform detect drift in configuration?

Terraform detects drift in configuration by using the `terraform plan` or `terraform apply` command. Drift occurs when the actual infrastructure state deviates from the expected state defined in the Terraform configuration.

### How Terraform Detects Drift:
**State Comparison**
- Terraform maintains a state file (`terraform.tfstate`) that records the infrastructure's last known state.
- When you run `terraform plan`, Terraform queries the actual infrastructure and compares it with the state file.

**Detecting Differences**
- If Terraform finds discrepancies (e.g., manually changed configurations in the cloud provider console), it marks those changes as drift.
- It displays the differences in the `terraform plan` output.

**Resolving Drift**
- Running `terraform apply` can reconcile the drift by:
    - Reverting changes: If the infrastructure differs from the desired state, Terraform will adjust it to match the configuration.
    - Updating state: If the drifted changes are intentional and should be retained, the Terraform configuration or state must be updated.

## 33. What happens if I make manual change in configuration of infrastructure provisioned by Terraform and run apply the Terraform script again?

When you manually change a resource outside of Terraform's configuration and then run `terraform apply` again, Terraform compares the current state of your infrastructure (queried from the provider) with the state file and your configuration files. If it detects any differences, it considers these as drift.

Here's what happens:

- **Drift Detection**: Terraform identifies that the resource's actual settings differ from what's declared in your configuration.
- **Plan Generation**: Running `terraform plan` shows a proposed change to revert the manual modifications, aligning the infrastructure back to the configuration's state.
- **Reconciliation**: When you apply the plan, Terraform makes the necessary changes to bring the resource back into the desired state.

This behavior ensures that the infrastructure remains consistent with the defined configuration. If you intend to keep the manual changes, you must update the Terraform configuration accordingly and then apply.

## 34. Why would you prefer a Deployment over a ReplicaSet?

A Deployment is preferred over a ReplicaSet in Kubernetes because it provides additional functionality and ease of management for application updates and scaling. While a ReplicaSet ensures a specified number of pod replicas are running, a Deployment builds on top of it by offering features like rolling updates, rollbacks, and declarative updates.

## 35. What are Mutating and Validating webhooks in Kubernetes?

In Kubernetes, Mutating Webhooks and Validating Webhooks are types of Admission Webhooks that help enforce and modify resource configurations before they are persisted in the cluster. They are part of Admission Controllers, which intercept requests to the Kubernetes API server.

### 1. Mutating Webhooks
**Purpose**: Modify incoming Kubernetes API requests before they are stored.

- Used to inject, modify, or default values in a resource definition.
- Common use cases:
    - Automatically adding labels, annotations, or environment variables.
    - Injecting sidecar containers (e.g., Istio, Linkerd).
    - Setting default values for fields that are missing.

**Example**:
If a Pod is created without specifying a security policy, a mutating webhook can automatically add security context settings before the request reaches the API server.

### 2. Validating Webhooks
**Purpose**: Validate requests and reject non-compliant ones.

- These webhooks do not modify requests but only check if they meet certain criteria.
- Common use cases:
    - Ensuring all Pods have resource limits (cpu and memory).
    - Blocking deployment of privileged containers.
    - Enforcing specific naming conventions.

**Example**:
A validating webhook can reject a request if a Pod is missing a required label (app=production), ensuring compliance with policies.

## 36. Is it necessary to build application every time a pipeline is triggered?

No, it is not always necessary to build the application every time a pipeline is triggered. Whether you should rebuild depends on factors like the type of changes, caching mechanisms, and deployment strategy.

### When You Should Rebuild Every Time:
**Code Changes**:
- If there are changes in the application source code (e.g., new commits, bug fixes, features).
- Ensures that the latest code is compiled and packaged.

**Dependency Updates**:
- If there are updates in package dependencies (package.json, requirements.txt, pom.xml, etc.), rebuilding ensures compatibility.

**Security Fixes**:
- Some frameworks and libraries release critical patches that require a full rebuild.

**New Environment Variables or Configuration Changes**:
- Some application builds depend on environment variables that affect compilation.

### When You Can Skip Rebuilding:
**No Changes in Application Code**:
- If only infrastructure or deployment configurations (e.g., Kubernetes YAML, Helm charts, Terraform files) have changed.

**Using Build Caching**:
- If you use Docker images with layer caching, you can avoid rebuilding unchanged layers.
- Example: `docker build --cache-from` reuses previously built layers.

**Artifact Reuse**:
- If you store built artifacts (e.g., .jar, .war, .tar.gz) in Artifactory, Nexus, or S3, you can reuse them instead of rebuilding.

**Separate Build and Deploy Pipelines**:
- A build pipeline compiles the application and stores artifacts.
- A deployment pipeline pulls the latest stable artifact and deploys it without rebuilding.

## 37. How does a service in Kubernetes know which deployment it has to connect to?

In Kubernetes, a Service knows which Deployment (or underlying Pods) to connect to using labels and selectors.

## 38. I have a deployment running and I want to upgrade it. What are the measures I would take to keep the deployment always available?

To upgrade a Deployment while ensuring it remains highly available, you should follow safe deployment practices like Rolling Updates, Readiness Probes, and Blue-Green or Canary Deployments.

```bash
kubectl set image deployment/nginx-deployment nginx-container=nginx:1.25
```

## 39. What are the security measures to be taken while creating infrastructure with Terraform?

1. **Secure Terraform State**
    - Use remote state storage (e.g., AWS S3 with encryption).
    - Enable state locking (e.g., DynamoDB for AWS).
    - Restrict access to the state file with IAM policies.

2. **Least Privilege IAM Roles & Policies**
    - Assign least privilege to Terraform execution roles.
    - Avoid using * in IAM policies.
    - Separate roles for Terraform execution and application.

3. **Secure Secrets & Sensitive Data**
    - Use environment variables or secret managers (AWS Secrets Manager, Azure Key Vault).
    - Mark sensitive outputs with `sensitive = true` in Terraform.

4. **Use Verified Modules & Version Pinning**
    - Use trusted modules from the Terraform Registry.
    - Pin module versions to avoid unintended changes.

5. **Enable Logging & Auditing**
    - Enable CloudTrail (AWS) or Activity Logs (Azure).
    - Use `terraform plan` and avoid `-auto-approve` for changes.

6. **Scan for Security Vulnerabilities**
    - Use security scanners like tfsec or Checkov to detect misconfigurations.

7. **Restrict Terraform Execution Environment**
    - Run Terraform in a secure CI/CD pipeline.
    - Use service accounts for access rather than personal credentials.

8. **Network Security & Encryption**
    - Restrict Security Groups (e.g., avoid 0.0.0.0/0).
    - Enable encryption for storage and data.

9. **Implement RBAC (Role-Based Access Control)**
    - Use RBAC to restrict who can modify infrastructure.
    - Ensure MFA for Terraform users.

10. **Regularly Rotate Access Credentials**
    - Rotate IAM keys and credentials periodically.
    - Use MFA for additional security.

## 40. What are modules and how are they useful in provisioning infrastructure?

In Terraform, a module is a collection of resources that are grouped together for reuse. It helps organize infrastructure code and allows you to easily replicate configurations across different environments or projects.

Modules are useful because they promote reusability, enabling you to define infrastructure once and use it multiple times. They also help simplify code by reducing duplication, ensuring consistency across deployments, and making maintenance easier—any updates made to a module automatically reflect in all instances where it's used.

For example, you can create a module for provisioning a VPC and then call it in different parts of your configuration to set up multiple VPCs without rewriting the same code. Modules help save time, avoid repetition, and make sharing configurations easier.

## 41. How do you configure health checks in deployment?

To configure health checks in a Kubernetes deployment, you can use readiness and liveness probes. These probes help ensure that the application is running correctly and ready to handle traffic.

### Steps to Configure Health Checks:
**Readiness Probe**:
- It checks if the application is ready to serve requests.
- If the readiness probe fails, the pod is removed from the service load balancer until it is ready.

**Liveness Probe**:
- It checks if the application is still running.
- If the liveness probe fails, the pod is restarted.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 2
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 20
          timeoutSeconds: 2
          failureThreshold: 3
```

## 42. What are readiness and liveness probes?

**Readiness Probe**:
- It checks if the application is ready to serve requests.
- If the readiness probe fails, the pod is removed from the service load balancer until it is ready.

**Liveness Probe**:
- It checks if the application is still running.
- If the liveness probe fails, the pod is restarted.

## 43. What is the difference between volume and bind mount?

### Volume:
- **Location**: Managed by Docker, stored in Docker's volume directory.
- **Persistence**: Persists data independently of the container lifecycle.
- **Management**: Managed by Docker (using docker volume commands).
- **Use Case**: Storing persistent data (e.g., databases, logs).

### Bind Mount:
- **Location**: Tied directly to the host filesystem path.
- **Persistence**: Tied to the host file/directory lifecycle.
- **Management**: Managed by the host OS filesystem.
- **Use Case**: Sharing specific files between host and container (e.g., config files).


# Jenkins Interview Questions

## Basic Jenkins Questions

### 2. What is Jenkins, and why is it used in DevOps?
Jenkins is an open-source CI/CD automation server used to build, test, and deploy applications efficiently.

**Why is Jenkins used?**
- Automates CI/CD pipelines.
- Supports Git, Docker, Kubernetes, Ansible, Terraform, etc.
- Provides distributed builds using master-agent architecture.
- Offers plugin-based extensibility (e.g., SonarQube, JIRA, Nexus).

### 3. How does Jenkins work? Explain its architecture.
**Jenkins Architecture:**

**Jenkins Master:**
- Manages jobs and schedules builds.
- Monitors build execution.
- Provides a web UI.

**Jenkins Agent (Slave):**
- Executes jobs on different machines.
- Can be a Docker container, Kubernetes pod, or a VM.

**Workflow:**
- Developer pushes code to Git → Triggers Jenkins Job.
- Jenkins fetches the code and starts a Pipeline.
- Runs Unit Tests, Code Quality Checks, Security Scans.
- Deploys the application to Staging/Production.

### 5. What are Freestyle Jobs and Pipeline Jobs?
**Freestyle Job** is a basic Jenkins job configured via UI.
- Suitable for simple builds (e.g., compiling code, running scripts).
- It doesn't support Jenkinsfile.
- Supports build triggers, post-build actions, parameterized builds.
- Does not support complex workflows (e.g., conditional steps, parallel builds).

**Pipeline Job** is a script-driven CI/CD pipeline defined in a Jenkinsfile (Groovy script).
- Supports multi-stage, parallel builds, error handling.
- Can be stored in Git for version control.
- Enables complex workflows (e.g., integration with Docker, Kubernetes, AWS, Ansible).

### 6. What are the default Jenkins environment variables?
Jenkins environment variables are predefined system variables available during a job execution.
- They store build, system, and user-related information.
- Can be used in Freestyle Jobs and Pipeline Jobs.
- Useful for parameterized builds, debugging, and automation.

| Variable | Description | Example |
|----------|-------------|---------|
| BUILD_NUMBER | Current build number | #25 |
| BUILD_ID | Unique ID for the build | 2024-03-03_12-30-00 |
| BUILD_URL | URL of the build | http://jenkins/job/my-job/25/ |
| JOB_NAME | Name of the job | my-job |
| WORKSPACE | Path to the workspace directory | /var/lib/jenkins/workspace/my-job |
| NODE_NAME | Name of the agent/node running the build | master / agent-1 |
| GIT_COMMIT | Latest Git commit hash | 9d4f3b7a1c2 |
| GIT_BRANCH | Git branch being built | main |
| JENKINS_URL | Jenkins server URL | http://jenkins:8080/ |
| TAG_NAME | Tag name if triggered by a tag | v1.0.0 |

### 7. How do you secure Jenkins?
- Disable anonymous access in Manage Jenkins > Security.
- Use Role-Based Access Control (RBAC) with the Matrix Authorization Plugin.
- Enable CSRF Protection and secure with HTTPS.
- Store credentials in Jenkins Secrets instead of hardcoding.

### 8. What is the purpose of the Jenkinsfile?
A Jenkinsfile is a text file that defines a Jenkins Pipeline using Groovy syntax.
- It allows CI/CD automation using code instead of UI-based configuration.
- Stored in version control (Git, GitHub, Bitbucket, etc.), enabling Pipeline as Code.
- Supports both Declarative and Scripted Pipelines.

### 9. What is the difference between Declarative and Scripted pipelines?

| Feature | Declarative Pipeline | Scripted Pipeline |
|---------|---------------------|-------------------|
| Syntax | `pipeline {}` block | Groovy scripting |
| Readability | Easy | Complex but flexible |
| Usage | Simple CI/CD workflows | Advanced logic |
| Example | `pipeline { agent any stages {} }` | `node { stage {} }` |

## Jenkins Pipeline Questions

### 10. How do you define a Jenkins Declarative Pipeline? Give an example.

### 11. What is the difference between node and agent in a Jenkins pipeline?
In Jenkins pipelines, both node and agent are used to define where the pipeline runs, but they belong to different types of pipelines:

| Feature | agent (Declarative Pipeline) | node (Scripted Pipeline) |
|---------|------------------------------|--------------------------|
| Pipeline Type | Used in Declarative Pipelines | Used in Scripted Pipelines |
| Purpose | Defines the Jenkins agent (node) where the pipeline runs | Assigns a Jenkins node dynamically |
| Syntax Placement | Inside `pipeline {}` block | Inside `node {}` block |
| Flexibility | Less flexible but easier to use | More flexible, allows dynamic allocation of nodes |
| Usage | Used with any, none, label, or docker | Used within a Groovy block |

### 12. What is the use of post in a Jenkinsfile?
In Jenkins Declarative Pipelines, the post section is used to define actions that should run after the pipeline execution. These actions help with cleanup, notifications, logging, and failure handling.

| Condition | Description | When It Runs |
|-----------|-------------|--------------|
| always | Runs regardless of pipeline success/failure | Every time, even if aborted |
| success | Runs only if the pipeline succeeds | When all stages pass |
| failure | Runs only if the pipeline fails | When any stage fails |
| unstable | Runs if the pipeline is unstable | When tests fail but build passes |
| changed | Runs if the pipeline result changed from last run | Example: Success → Failure |

### 13. What are stages and steps in Jenkins?
- **Stages**: Logical groups of tasks (e.g., Build, Test, Deploy).
- **Steps**: Commands executed inside a stage.

### 14. What is a Shared Library in Jenkins, and how do you use it?
A Shared Library is reusable Groovy code stored in a Git repo.

Example `vars/deploy.groovy`:

```groovy
def call() {
  sh 'kubectl apply -f deployment.yaml'
}
```

Use in Jenkinsfile:

```groovy
@Library('my-shared-library')_
deploy()
```

### 15. How can you run a Jenkins pipeline only when a specific branch is pushed?
To run a Jenkins pipeline only when a specific branch is pushed, you can use the when directive with an expression or branch condition in a Declarative Pipeline.

**Using the when Directive with branch Condition**
The when block allows you to specify conditions under which the pipeline or specific stages should run. You can check the value of env.BRANCH_NAME to determine which branch triggered the pipeline.

Example: Run Pipeline for a Specific Branch (e.g., main)
```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      when {
        branch 'main'  // Only run this stage if 'main' branch is pushed
      }
      steps {
        echo "Building the application..."
      }
    }
  }
}
```

**Explanation:**
- The pipeline will only run the Build stage when the main branch is pushed.

### 16. How do you pass parameters in a Jenkins pipeline?
**Defining Parameters**
Use the parameters block inside the pipeline block to define parameters.
```groovy
pipeline {
  agent any
  parameters {
    string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to build')
    booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run tests')
  }
  stages {
    stage('Build') {
      steps {
        echo "Branch: ${params.BRANCH_NAME}, Run Tests: ${params.RUN_TESTS}"
      }
    }
  }
}
```

**Parameter Types**
Common types:
- string, booleanParam, choice, password, text

**Accessing Parameters**
Access parameter values using `${params.PARAM_NAME}`:
```groovy
echo "Branch: ${params.BRANCH_NAME}"
```

**Triggering with Parameters**
Parameters can be provided when triggering the pipeline manually from Jenkins UI or through API calls.

## Jenkins Integrations & Plugins

### 17. What are some commonly used Jenkins plugins in a DevOps pipeline?
- **Multibranch scan webhook trigger**: Trigger Jenkins jobs automatically when changes are pushed to a branch.
- **Blue Ocean**: Modern UI for Jenkins pipelines.
- **Git**: Integrates Jenkins with Git repositories.
- **Docker**: Provides Docker integration for Jenkins pipelines.
- **SSH Agent Key**: Manages SSH keys for Jenkins.
- **Credentials Binding Plugin**: Securely inject credentials into Jenkins jobs.
- **Ansible**: Integrates Jenkins with Ansible for configuration management.
- **Webhook Notification Plugin**: Sends notifications to external services.
- **Stage View**: Visualizes pipeline stages in Jenkins UI.

### 18. How do you integrate Jenkins with GitHub/GitLab/Bitbucket?

### 19. How do you trigger a Jenkins job from GitHub Webhooks?

### 20. How does Jenkins integrate with Docker?
Jenkins integrates with Docker using the Docker plugin:

1. Install the Docker Plugin in Jenkins.
2. Configure Docker in Jenkins:
    - Go to Manage Jenkins → Configure System → Docker section.
    - Set up a Docker server or Docker agent.
3. Using Docker in Jenkins Pipelines:
    - You can use the docker or dockerfile steps in Jenkins pipelines to run jobs inside Docker containers, build Docker images, or deploy Docker containers.

### 21. How can Jenkins deploy applications to Kubernetes?
Jenkins can deploy applications to Kubernetes using the Kubernetes Plugin:

1. Install the Kubernetes Plugin in Jenkins.
2. Configure Kubernetes in Jenkins:
    - Go to Manage Jenkins → Configure System → Kubernetes section.
    - Provide the Kubernetes API URL and credentials.
3. Pipeline:
    - Use the kubernetes block to run jobs inside Kubernetes pods.

Example:
```groovy
pipeline {
  agent { kubernetes { label 'my-pod' } }
  stages {
    stage('Deploy') {
      steps {
        script {
          // Kubernetes deployment commands
        }
      }
    }
  }
}
```

### 22. What is the Blue Ocean plugin in Jenkins?
The Blue Ocean plugin is a modern, user-friendly interface for Jenkins:

- It provides a visual representation of Jenkins pipelines with a focus on simplicity and easy-to-understand UI.
- It helps visualize the status of the pipeline, stages, and steps in real-time.
- It offers features like pipeline creation, PR integration, and visualizations for build performance.

### 23. How do you use Jenkins with Terraform for infrastructure automation?
To use Jenkins with Terraform for infrastructure automation:

1. Install the Terraform Plugin in Jenkins.
2. Configure a Jenkins Job:
    - Add Terraform commands in a Pipeline or Freestyle job.

Example Pipeline:
```groovy
pipeline {
  agent any
  stages {
    stage('Terraform Init') {
      steps {
        script {
          sh 'terraform init'
        }
      }
    }
    stage('Terraform Plan') {
      steps {
        script {
          sh 'terraform plan'
        }
      }
    }
    stage('Terraform Apply') {
      steps {
        script {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}
```

## Advanced Jenkins Questions

### 24. How do you configure a Multi-Branch Pipeline in Jenkins?
A Multi-Branch Pipeline allows Jenkins to automatically create pipelines for each branch in a repository.

1. Create a Multi-Branch Pipeline job in Jenkins.
2. Under Source, choose Git and provide the repository URL.
3. Jenkins will automatically detect branches and create individual pipelines for each one.
4. Set the Jenkinsfile in the root of each branch.

### 25. What is the difference between input and parameters in a pipeline?
- **Input**: The input step pauses the pipeline and waits for human intervention to proceed.
    - Example: `input message: 'Approve the deployment?'`
- **Parameters**: Parameters are values passed when triggering a build, either from the Jenkins UI or programmatically.
    - Example: `parameters { string(name: 'APP_VERSION', defaultValue: '1.0') }`

### 26. How do you implement parallel execution in Jenkins?
Use the parallel block in a Jenkins pipeline to execute multiple stages or steps simultaneously. Example:

```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        parallel(
          "Stage 1": {
            // Commands for Stage 1
          },
          "Stage 2": {
            // Commands for Stage 2
          }
        )
      }
    }
  }
}
```

### 27. How can you store Jenkins secrets securely?
Jenkins provides credentials storage:

- **Jenkins Credentials Plugin**: Allows you to store secrets like API keys, passwords, and tokens securely.
- Store secrets under Manage Jenkins → Manage Credentials.
- Use these credentials in pipelines via credentials() or environment variables.

### 28. What is an upstream and downstream job in Jenkins?
- **Upstream Job**: A job that triggers another job is called an upstream job.
- **Downstream Job**: A job that is triggered by another job is called a downstream job.
- Example: A build job triggers a test job (upstream → downstream).

### 29. How do you handle failures in a Jenkins pipeline?
Handle failures using the post section or try/catch blocks.

Post Section: Define actions based on build status (success, failure, unstable). Example:
```groovy
post {
  success {
    echo 'Build succeeded!'
  }
  failure {
    echo 'Build failed!'
  }
}
```

### 30. How do you dynamically allocate nodes in a Jenkins pipeline?
Jenkins can dynamically allocate nodes using the cloud agents feature (e.g., Kubernetes, EC2):

1. Configure Cloud Providers under Manage Jenkins → Configure System.
2. Required Plugins: Kubernetes or Amazon EC2 Plugin.
3. In the pipeline, use the agent block with labels or specify cloud-specific agents. Example:

```groovy
pipeline {
  agent { label 'k8s-agent' }
  stages {
    stage('Build') {
      steps {
        // Build commands here
      }
    }
  }
}
```

## Jenkins Troubleshooting & Best Practices

### 31. How do you troubleshoot a failing Jenkins pipeline?
- **Check Console Output**: Review the build logs for error messages and stack traces.
- **Check Workspace**: Ensure that workspace files are not corrupted.
- **Check Dependencies**: Ensure that any external services (e.g., GitHub, Docker) are available.
- **Jenkins Logs**: Review Jenkins logs under /var/log/jenkins/jenkins.log.

### 32. How can you monitor Jenkins performance?
- **Jenkins Monitoring Plugins**: Use plugins like Monitoring Plugin or Metrics Plugin to track performance.
- **JVM Memory Usage**: Tracks memory consumption by the Jenkins Java Virtual Machine (JVM), showing how much memory is being used and how much is available.
- **System Load**: Use tools like Prometheus or Grafana to monitor Jenkins health and performance.

### 33. What is Pipeline as Code, and why is it useful?
Pipeline as Code refers to defining Jenkins pipelines using a code file (usually Jenkinsfile).

**Benefits:**
- Version control for pipelines.
- Reusable and maintainable pipeline definitions.
- Easy to manage changes to the CI/CD process.

### 34. How do you back up and restore Jenkins?
- **Backup**: Copy /var/lib/jenkins folder.
- **Restore**: Replace the backup in /var/lib/jenkins and restart Jenkins.

### 35. How do you manage large-scale Jenkins environments?
- Use Jenkins Master/Slave architecture for distributing the load.
- Divide workloads with multi-branch pipelines, folders, and views.
- Use cloud-based agents for dynamic scaling (e.g., AWS, Kubernetes).
- Use Jenkins Configuration as Code (JCasC) for centralized configuration.

### 36. What are some best practices for writing Jenkins pipelines?
- Use Pipeline as Code (Jenkinsfile).
- Keep pipelines modular and reusable.
- Use parameters for flexibility.
- Always clean up workspaces and manage artifacts.
- Use stages for clarity and organization.
- Incorporate failure handling and proper logging.

### 37. How to Handle Errors in Jenkins Pipeline ?

## 1. Use Try-Catch Blocks with Proper Logging

Try-catch blocks are essential for graceful error handling in Jenkins pipelines. They allow you to catch exceptions, log meaningful information, and decide whether to fail the build or continue with warnings.

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    try {
                        sh 'mvn clean install'
                    } catch (Exception e) {
                        // Log detailed error information
                        echo "Build failed: ${e.message}"
                        // Send notifications to relevant teams
                        mail to: 'team@example.com', subject: 'Build Failed', body: "${e.message}"
                        // Mark build as failed
                        error "Build step failed: ${e.message}"
                    }
                }
            }
        }
    }
}
```

## 2. Implement Post-Build Actions for Consistent Cleanup

The `post` section ensures that cleanup, notifications, and reporting happen regardless of the build outcome. This is critical for maintaining system integrity and providing proper feedback.

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'run-tests'
            }
        }
    }
    post {
        always {
            // Always clean up resources
            cleanWs()
            // Archive test results regardless of outcome
            junit 'test-results/*.xml'
        }
        failure {
            // Notify team on failures via multiple channels
            echo 'Build failed!'

            // Send Slack notification
            slackSend channel: '#alerts',
                    color: 'danger',
                    message: "Build failed: ${env.BUILD_URL}"

            // Send email notification
            mail to: 'team@example.com',
                    subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                    body: "Something is wrong with ${env.BUILD_URL}"
        }
        unstable {
            // Steps that run only if the pipeline is unstable
            echo 'Build is unstable'
        }
        changed {
            // Steps that run only if the pipeline's status changed
            echo 'Pipeline status changed'
        }
    }
}
```

These two practices form the foundation of robust error handling in Jenkins pipelines and are widely adopted across the industry.

# **Ensuring Graceful EC2 Termination in Auto Scaling**

## **Problem Statement**
How can we ensure that an EC2 instance marked for termination by Auto Scaling does not drop active connections and completes in-flight requests before shutting down?

## **Solution Overview**
We will use two key configurations:
1. **Deregistration Delay (ALB)** → Ensures ongoing connections complete before removing the instance.
2. **Auto Scaling Lifecycle Hook** → Delays termination to allow graceful shutdown.

---

## **Steps to Implement**

### **1️⃣ Set Up Deregistration Delay for ALB**
Before terminating, an instance must be **removed from the load balancer** to avoid serving new requests.

1. Go to **EC2** → **Load Balancers**
2. Select your **Application Load Balancer (ALB)**
3. Click on the **Target Group** linked to your ASG
4. Open the **Attributes** tab
5. Find **Deregistration Delay** and set it to `300` seconds (default is 300, adjust as needed)
6. Click **Save**

**🔹 Effect:**  
When an instance is marked for termination, ALB will **stop sending new traffic** while allowing existing connections to complete.

---

### **2️⃣ Create an Auto Scaling Lifecycle Hook**
A lifecycle hook pauses instance termination, allowing time for **graceful shutdown.**

1. Go to **EC2** → **Auto Scaling Groups**
2. Select your **Auto Scaling Group (ASG)**
3. Open the **Lifecycle Hooks** tab → Click **Create Lifecycle Hook**
4. Configure:
    - **Name:** `TerminationHook`
    - **Transition:** `Instance Terminating`
    - **Timeout:** `300` seconds (adjust based on workload)
    - **Action on Timeout:** `Continue`
    - (Optional) **SNS/SQS Notification** for automation
5. Click **Create**

**🔹 Effect:**  
When an instance is scheduled for termination, ASG **waits** instead of immediately terminating the instance.

---

### **3️⃣ Automate Graceful Shutdown Using Lambda**
To **ensure active connections are closed gracefully**, a Lambda function can:
- Remove the instance from the Target Group
- Wait for active connections to complete
- Stop services before termination

#### **Steps to Set Up Lambda Trigger with EventBridge**
1. **Create a Lambda Function**
    - Go to **AWS Lambda** → Click **Create Function**
    - Select **Author from scratch**
    - Runtime: `Python 3.x`
    - Paste the following code:

   ```python
   import boto3
   import time

   asg_client = boto3.client('autoscaling')
   elb_client = boto3.client('elbv2')

   def lambda_handler(event, context):
       instance_id = event['detail']['EC2InstanceId']
       target_group_arn = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/my-target-group/1234567890abcdef"

       # Deregister instance from ALB target group
       elb_client.deregister_targets(
           TargetGroupArn=target_group_arn,
           Targets=[{'Id': instance_id}]
       )

       # Wait for deregistration delay
       time.sleep(300)

       # Complete lifecycle action
       asg_client.complete_lifecycle_action(
           LifecycleHookName="TerminationHook",
           AutoScalingGroupName="MyASG",
           LifecycleActionResult="CONTINUE",
           InstanceId=instance_id
       )

       return {"status": "Instance gracefully terminated"}
   ```

2. **Create an EventBridge Rule to Trigger Lambda**
    - Go to **Amazon EventBridge** → **Rules** → Click **Create Rule**
    - Select **Event Source:** `EC2 Instance-terminating Lifecycle Action`
    - Target: **Lambda function** (Select the Lambda created above)
    - Click **Create**

**🔹 Effect:**
- When an instance is **marked for termination**, the hook **pauses termination**
- The Lambda **removes the instance from ALB**, waits for active connections to finish, and stops services
- After **graceful shutdown**, termination completes

---

## **Final Outcome**
✅ **No active connections lost** before shutdown  
✅ **Instance is properly deregistered from ALB** before termination  
✅ **Smooth auto-scaling without user impact**


# Ensuring High Availability (HA) in Amazon EKS

## 1️⃣ Multi-AZ Cluster Deployment
Ensure your **EKS cluster is deployed across multiple Availability Zones (AZs)** to prevent a single AZ failure from affecting workloads.

### Steps:
1. When creating an **EKS cluster**, select **at least 2-3 Availability Zones**.
2. Use a **managed node group** or a self-managed **Auto Scaling Group (ASG)** that distributes worker nodes across AZs.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
  namespace: default
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app
                operator: In
                values:
                  - my-app
          topologyKey: "kubernetes.io/hostname"
```

## 2️⃣ Autoscaling for Pods and Nodes

### Horizontal Pod Autoscaler (HPA)
Automatically scales the number of pods based on CPU or memory usage.

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

### Cluster Autoscaler
Ensures there are enough worker nodes for increased pod demand.

#### Steps:
1. Install the **Cluster Autoscaler**:
   ```bash
   helm repo add autoscaler https://kubernetes.github.io/autoscaler
   helm install cluster-autoscaler autoscaler/cluster-autoscaler --set autoDiscovery.clusterName=my-cluster
   ```
2. Ensure your **Auto Scaling Group (ASG)** has sufficient capacity.

## 3️⃣ Load Balancing & Traffic Routing
Use **AWS ALB Ingress Controller** or **Nginx Ingress Controller** to distribute traffic across pods.

### Example: ALB Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  ingressClassName: alb
  rules:
    - host: myapp.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app-service
                port:
                  number: 80
```

## 4️⃣ Pod Disruption Budgets (PDB)
Ensure at least **N** pods remain available during updates or node failures.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-app-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: my-app
```

## 5️⃣ Data Persistence with HA Storage
For persistent storage, use **Amazon EFS, Amazon RDS, or AWS FSx**.

### Example: StatefulSet with Persistent Volume
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-app
spec:
  serviceName: "my-app"
  replicas: 3
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
```

## 6️⃣ Multi-Region Disaster Recovery (Optional)
For extreme HA:
1. Use **AWS Global Accelerator** for cross-region traffic routing.
2. Set up **multi-region EKS clusters** and replicate data using **RDS Multi-Region or S3 cross-region replication**.

## ✅ Final Outcome
By following these practices, your application will be:
- Distributed across **multiple Availability Zones**.
- Scalable via **HPA (pods) and Cluster Autoscaler (nodes)**.
- Resilient to failures using **PDB, ALB, and StatefulSets**.
- Backed by HA **storage solutions** like RDS, EFS, or FSx.

### Backup Strategies for kubernetes:
#### a. **Kubernetes Cluster Backup (ETCD Backup for Self-Managed Clusters)**
1. If using self-managed **ETCD**, periodically back up its data:
   ```bash
   ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-backup.db
   ```
2. Restore the cluster using:
   ```bash
   ETCDCTL_API=3 etcdctl snapshot restore /backup/etcd-backup.db
   ```

#### b. **AWS EKS Cluster Backup using Velero**
Velero is a tool for backing up and restoring Kubernetes clusters.

**Steps to Install Velero:**
```bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
helm install velero vmware-tanzu/velero --namespace velero \
  --set configuration.provider=aws \
  --set configuration.backupStorageLocation.bucket=<YOUR-S3-BUCKET> \
  --set credentials.secretContents.cloud=<CREDENTIALS-FILE>
```

**Create a Backup:**
```bash
velero backup create my-cluster-backup --include-namespaces=default
```

**Restore a Backup:**
```bash
velero restore create --from-backup my-cluster-backup
```

#### c. **Persistent Volume Backup using AWS Backup**
1. Create an **AWS Backup Plan** targeting **EBS volumes**.
2. Schedule **daily snapshots** of EBS volumes attached to EKS nodes.
3. Retain backups for **disaster recovery and compliance**.



# What are your 3 important KRA'S?
1. ServiceNow incident management
2. Cost optimization reports and analysis
3. EKS cluster health



######################################################################
# What is difference between git pull and git fetch?
- git fetch downloads the latest changes from the remote but doesn’t update your working branch, whereas git pull does the same and automatically merges those changes into your current branch.
- git fetch is a safe way to review changes before merging, while git pull is a more aggressive approach that combines fetching and merging in one command.

# What is maven lifecycle?
## 🚀 Important Phases in the Maven Default Lifecycle (in order)

| Phase     | Description                                                  |
|-----------|--------------------------------------------------------------|
| `validate` | Checks if the project is correct and all info is available   |
| `compile`  | Compiles the source code                                     |
| `test`     | Runs unit tests                                              |
| `package`  | Packages the compiled code into a `.jar` or `.war`          |
| `verify`   | Runs any checks on results of integration tests              |
| `install`  | Installs the package to the local Maven repository           |
| `deploy`   | Copies the final package to a remote repository for sharing  |

- https://mvnrepository.com/  location to download the maven repository.

# What is Quality Gate and Quality Profile in SonarQube?
## SonarQube: Quality Profile vs Quality Gate

---

## 🔧 What is a **Quality Profile** in SonarQube?

- It is a **collection of rules** SonarQube uses to **analyze your code**.
- These rules are **code quality rules** like:
    - Don’t leave unused variables
    - Methods should not be too long
    - Avoid hardcoded passwords
    - SQL queries must be protected against injection
Note:  We cannot modify the default Quality Profile in SonarQube directly, but we can create a new Quality Profile and set it as the default for our project or language.

> ✅ Quality Profile tells SonarQube:  
> **“Check for these specific issues in the code.”**

### 🧠 Example:
For Java code, a Quality Profile might have rules like:
- Method name must be in camelCase
- No empty catch blocks
- Public classes should have Javadoc comments

---

## ✅ What is a **Quality Gate** in SonarQube?

- It is a **set of conditions** SonarQube uses to decide if the code **passes or fails** after analysis.
- It checks the **results** of rule violations, like:
    - Are there any **new bugs or vulnerabilities**?
    - Is **code coverage** at least 80%?
    - Is there too much **duplicated code**?

> ✅ Quality Gate tells SonarQube:  
> **“If any of these conditions fail, block the build.”**

### 🧠 Example:
A Quality Gate might say:
- New code must have **0 bugs**
- New code must have **no critical vulnerabilities**
- Code coverage on new code must be **≥ 80%**
- Duplicated lines must be **< 3%**

---

## 🧩 Summary

| Feature           | Quality Profile                                | Quality Gate                                      |
|------------------|-------------------------------------------------|---------------------------------------------------|
| **What it is**    | Set of **rules** to scan the code              | Set of **conditions** to accept or reject the code |
| **Focuses on**    | *How* the code is written                      | *Whether* the code is good enough to go forward   |
| **Example rule**  | “Avoid using empty catch blocks”              | “New code must have 0 bugs”                      |
| **Used for**      | Code **analysis**                              | Code **approval** (pass/fail)                    |

# Difference Between `git rebase` and `git merge`

- git merge combines branches and keeps history, while git rebase moves your changes on top for a cleaner history.
- **`git merge`** combines two versions of a project, keeping all the changes and creating a new "merge" point.
- **`git rebase`** takes your changes and places them on top of the other version, making the history look cleaner.

# How to resolve the git conflict.

# What is code smell in sonarqube
- In SonarQube, a code smell refers to a maintainability issue in your code — something that doesn't break functionality but indicates a deeper problem or bad practice that could lead to bugs or difficulties in the future. In simple A code smell is not a bug, but it’s a sign that the code "smells bad" — meaning it’s poorly written, overly complex, or not following best practices.

# What happens if the API Server goes down in Kubernetes?

---

## 🧠 What is the API Server?

The **API server** is the central management component in Kubernetes. It handles all **communication** with the cluster — whether you're deploying a pod, checking logs, scaling apps, etc.

---

## 📉 If the API Server goes down:

### ✅ What Still Works:
- **Running pods on worker nodes** will **continue to run**.
- **Node and pod communication** continues — no impact to the actual workloads.
- **Cluster networking** remains functional.
- **Kubelet** and **container runtime (e.g., containerd or Docker)** keep the pods alive.

### ❌ What Breaks or Gets Affected:
- **No new deployments, scaling, or updates** can be made — because those requests go through the API server.
- **kubectl commands** won't work (e.g., `kubectl get pods` will fail).
- **Health checks and monitoring tools** that query the API server may show errors.
- **Control plane features like auto-scaling, self-healing (restarting dead pods), and scheduling new pods** will not work.
- If a node fails, the cluster **won’t re-schedule** its pods until the API server is back.

---

## 🛠️ Summary:
> 🔒 **Running pods = Safe**  
> 🚫 **Cluster changes or management = Blocked** until the API server is restored

---

# What happens if the ETCD goes down in Kubernetes?

## What is etcd?

`etcd` is the key-value store used by Kubernetes to store all cluster state data — including nodes, pods, config maps, secrets, etc. It’s a critical component of the Kubernetes control plane.

## If etcd goes down:

### What Still Works:
- Running pods on worker nodes continue to run as long as:
    - The API server is still running and has data in memory.
    - No major control plane actions are needed.

### What Breaks or Gets Affected:
- The API server becomes non-functional or unstable since it relies on `etcd` for reading/writing cluster state.
- No new deployments, scaling, or config changes can happen.
- Cluster state cannot be saved or retrieved.
- Kubelet registration, node heartbeats, and controller-manager operations will fail.
- If the API server is restarted while `etcd` is down, the cluster will be unusable.

## When etcd Comes Back:
- The control plane resumes operations.
- Cluster state is accessible again.
- Pending changes (like deployments or scaling) may resume if reattempted.

## If etcd data is lost:
- You will lose the entire cluster state — no info about pods, deployments, or configs.
- Recovery requires restoring from a backup (highly recommended in production).

## Summary:
- Pods keep running.
- Cluster control is lost.
- Backup `etcd` regularly to avoid permanent loss.

## Best Practice:
- Always run `etcd` in a high-availability (HA) setup with multiple nodes.
- Take regular backups using tools like:
    - `etcdctl snapshot save`
    - Velero, etc.

# In EKS, if any Node is in `NotReady` state — What Should You Check?

When a node shows `NotReady`, it means the Kubernetes control plane is unable to communicate properly with the kubelet running on that node. Here's a systematic checklist to troubleshoot:

## 1. Check Node Status

Run:
```bash
kubectl get nodes
kubectl describe node <node-name>
```

Look at:
- Conditions section → Ready: False or Unknown
- Reason → Examples: NetworkUnavailable, KubeletNotReady, ContainerRuntimeUnhealthy

## 2. Check EC2 Instance Health

Go to AWS Console → EC2 → Check if the instance is:
- Running
- Passes both status checks
- Not terminated or stopped

Also check:
- System logs
- dmesg, journalctl, etc., if you can SSH into the instance

## 3. Check Network Connectivity

Ensure:

Node can access:
- EKS Control Plane (via VPC endpoint)
- api-server
- DNS resolution works (nslookup, dig, ping 8.8.8.8)

Security Groups allow:
- Outbound to 443 (API)
- Internal cluster communication on ports like 10250, 30000-32767

## 4. Check IAM Role and Permissions

Ensure the EC2 instance profile (Node IAM Role) has these permissions:
- AmazonEKSWorkerNodePolicy
- AmazonEC2ContainerRegistryReadOnly
- AmazonEKS_CNI_Policy

Missing permissions can break communication between the node and the control plane.

## 5. Check Kubelet and CNI Plugin

SSH into the node and check:
```bash
sudo systemctl status kubelet
sudo journalctl -u kubelet -xe
```

Also check the Amazon VPC CNI plugin logs:
```bash
kubectl -n kube-system logs <aws-node-pod>
```

Common issues:
- CNI not initializing correctly
- IP address exhaustion
- Kubelet not able to register with the API server

## 6. Check Disk Space & Resource Pressure

Sometimes, NotReady is due to:
- Disk pressure
- Memory pressure
- PID limits

Run:
```bash
df -h
free -m
top
```

Look for:
- `/` or `/var` full
- OutOfDisk or MemoryPressure conditions in describe node

## 7. Check for Auto Scaling Group (ASG) Issues

- Check if the instance is part of an EKS-managed node group or ASG
- If it's in a Terminating:Wait state, or failed lifecycle hook, it might be stuck
- Scaling policies might be replacing nodes

## 8. Drain/Replace the Node (if required)

If all else fails and node is unrecoverable:
```bash
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data
kubectl delete node <node-name>
```

EKS-managed node group will automatically replace the node.


# Troubleshooting: PVC in Failed State on EKS

## What should I do first if my PVC is in a Failed state?

Check the PVC status:
```bash
kubectl get pvc
```

Describe the PVC to understand the issue:
```bash
kubectl describe pvc <pvc-name>
```

## Why does my PVC show Failed in EKS?

### Reason 1: No Available Persistent Volume (PV)
If dynamic provisioning is disabled or misconfigured, no volume will be bound to the PVC.

Solution:

Make sure a valid StorageClass exists:
```bash
kubectl get storageclass
```

Check if your PVC is referencing the right StorageClass:
```yaml
storageClassName: gp2
```

### Reason 2: Provisioner Not Working or Misconfigured
The CSI driver might be malfunctioning or not installed correctly.

Solution:

Check for CSI driver pods:
```bash
kubectl get pods -n kube-system
```

Look for relevant logs:
```bash
kubectl logs <controller-pod> -n kube-system
```

Reinstall or reconfigure the CSI driver if necessary.

### Reason 3: Incorrect Parameters in StorageClass
The StorageClass might contain unsupported or wrong parameters (e.g., volume type, IOPS).

Solution:

Inspect the StorageClass:
```bash
kubectl describe storageclass <storageclass-name>
```

Correct or recreate the StorageClass with valid values.

### Reason 4: EBS Volume in Wrong Availability Zone
If the EBS volume is in a different AZ than the pod, the PVC cannot bind.

Solution:
- Ensure that pods and volumes are in the same Availability Zone
- Use a zonal-aware StorageClass or node affinity if required

### Reason 5: EFS Not Mounted Properly
When using EFS, issues with access, mounting, or configuration can cause failure.

Solution:
- Verify the EFS CSI driver is installed
- Ensure the EFS ID is correct and mount targets are available
- Check network and security group access

## What can I do if the PVC still doesn't work?

If everything seems correct but it's still failing:

Delete and Recreate the PVC (Data Loss Warning):
```bash
kubectl delete pvc <pvc-name>
```

Then reapply the configuration YAML.

Note: This deletes data unless the StorageClass uses `reclaimPolicy: Retain`.

## How can I view cluster-wide PVC and storage-related errors?

Use Events:
```bash
kubectl get events --sort-by='.lastTimestamp'
```

This will show the most recent events which might indicate the issue.


# What is the benifit of multi state docker file
- It will reduce the depolyment time.
- It will reduce the image size so disk utilization will be less.
- It will increase the security.
