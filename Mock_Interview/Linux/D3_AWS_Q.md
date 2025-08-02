### Original Questions (as provided)

1. What is LVM and how to extend a mounted LVM partition?
2. What are the steps to create a new user with sudo privileges?
3. How do you troubleshoot if the root partition is full?
4. What happens step-by-step from the moment you power on a Linux server?
5. How do you schedule a script to run every Monday at 7 PM?
6. What is logrotate and how do you configure it for custom log files?
7. How do you perform OS patching on a production EC2 instance?
8. How do you create an EC2 instance using CLI with a specific key, security group, and AMI?
9. How does ELB work and how do you troubleshoot 504 gateway timeout in ELB?
10. What is the use of Auto Scaling Group and how does it handle scaling during high traffic?
11. If DNS resolution fails inside a Linux EC2 instance, what steps will you take?
12. What is Route 53 and how is it different from traditional DNS servers?
13. How do you configure Nginx as a reverse proxy to an application running on port 8080?
14. How do you monitor a Linux server using Prometheus and Grafana?
15. What are the key commands and tools you use for performance monitoring in Linux?
16. How do you create an IAM policy to allow only S3 read access to a user?
17. What is EFS and how do you mount it across multiple EC2 instances?
18. What are the storage classes in S3 and how do you move objects between them?
19. How do you create a CloudWatch alarm for high CPU usage?
20. What is the difference between EBS snapshot and AMI?
21. How do you recover an EC2 instance that went into a failed boot state?
22. How do you configure sticky sessions in an ELB?
23. How does cron job logging work and how do you troubleshoot if the cron job didn't run?
24. What is the use of the /etc/fstab file and how do you make persistent mounts?
25. How do you configure logrotate to rotate logs daily and keep last 7 days logs?
26. What is the difference between hard link and soft link?
27. What are runlevels in Linux and how do they affect the boot process?
28. How do you set file permissions and ownership for a directory recursively?
29. How do you increase the disk size of an EC2 instance and make the OS detect the change?
30. What is the difference between ALB and NLB in AWS?
31. What happens if you stop and start an EC2 instance with an ephemeral volume?
32. How do you configure a lifecycle policy for an S3 bucket?
33. What is the role of node\_exporter in Prometheus monitoring?
34. How do you troubleshoot if EFS is not mounting on an instance?
35. How do you manage user SSH keys for multiple EC2 instances securely?
36. How do you create a CloudWatch dashboard for a specific EC2 instance?
37. What is Instance Metadata Service and how is it used inside EC2?


## ☁️ AWS Questions & Answers

### 7. **EC2 & EBS**

A user reports they can’t SSH into an EC2 instance. What steps do you take to troubleshoot?

**Answer:**

* Check security group (port 22 allowed)
* Check network ACL
* Validate key pair used
* Use EC2 serial console or Systems Manager if locked out

---

### 8. **S3**

You need to allow access to a private S3 bucket only from a specific VPC. How would you implement that?

**Answer:**
Use S3 Bucket Policy with VPC condition and a VPC endpoint:

```json
{
  "Condition": {
    "StringEquals": {
      "aws:SourceVpc": "vpc-xxxxxx"
    }
  }
}
```

---

### 9. **ELB & ASG**

An EC2 in an ASG is marked as unhealthy and getting replaced. How do you investigate what’s going wrong?

**Answer:**

* Check ELB health check path and response (expect HTTP 200)
* Ensure backend service is up and responding
* Review logs: `/var/log/cloud-init.log`, `/var/log/messages`
* Validate user-data script and app readiness

---

### 10. **IAM**

Explain how IAM policies and roles differ. Also, how do you give an EC2 instance access to read an S3 bucket?

**Answer:**

* **IAM Role**: Assigned to resources; grants temporary permissions
* **IAM Policy**: Defines permissions; can be attached to users, groups, roles

To give EC2 S3 access:

* Create IAM Role with S3 read policy
* Attach the role to EC2 instance

---

### 11. **Route 53 & DNS**

How does Route 53 work with multiple availability zones? What routing policy would you use for low-latency global access?

**Answer:**

* Route 53 routes to healthy AZs via ELB
* Use **Latency-based routing** for best global performance

---

### 12. **Monitoring – CloudWatch, Prometheus, Grafana**

You want to monitor disk usage across all EC2 instances and send alerts if it goes above 80%. How would you do that using CloudWatch and/or Prometheus-Grafana?

**Answer:**
**Using CloudWatch:**

* Install CloudWatch Agent
* Push `disk_used_percent` metric
* Create alarm for `> 80%`

**Using Prometheus + Grafana:**

* Install node\_exporter
* Create Grafana alert panel
* Define PromQL rule: `node_filesystem_usage > 0.8`

---

### 13. **EFS vs EBS**

What is the difference between EBS and EFS? When would you prefer one over the other?

**Answer:**

| Feature     | EBS                        | EFS                     |
| ----------- | -------------------------- | ----------------------- |
| Mount Type  | One EC2 (AZ-specific)      | Multiple EC2 (multi-AZ) |
| Performance | Block storage, low latency | Scalable, shared FS     |
| Use Case    | DB, OS disk, local storage | Shared access, NFS-like |

---
