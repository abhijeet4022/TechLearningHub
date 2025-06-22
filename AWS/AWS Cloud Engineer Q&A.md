## AWS Linux Interview Questions

1. **Key Recovery**
   How do you recover access to an EC2 instance if the key pair is lost?

2. **S3 Cross-Account Access**
   How do you enable cross-account access to an S3 bucket?

3. **IAM Role and Policy Association**
   How do you attach IAM roles and policies to users and AWS services?

4. **IAM Policy Generation**
   What are the different ways to create IAM policies?

5. **VM Connection Methods**
   What are the different methods to connect to an EC2 instance?

6. **Disk/Partition Extension**
   How do you extend a disk or partition on a Linux EC2 instance?

7. **Backup Configuration**
   How do you configure backups for EC2 instances?

8. **EC2 Boot Failure Troubleshooting**
   An EC2 instance is not booting — how do you troubleshoot it?

9. **SSH Traffic (Port 22)**
   How does SSH (port 22) traffic reach your EC2 instance?

10. **IGW vs NGW**
    What is the difference between an Internet Gateway (IGW) and a NAT Gateway (NGW)?

11. **Internet Access for Private VM**
    How does a private EC2 instance access the internet?

12. **Private S3 Access**
    How do you connect an EC2 instance to an S3 bucket privately?

13. **EFS Use Case**
    What are the use cases for Amazon EFS?

14. **EFS Mount Troubleshooting**
    How do you troubleshoot if an EC2 instance cannot mount an EFS file system?

15. **SSH Failure Troubleshooting**
    You are unable to SSH into an EC2 instance — how do you fix it?

16. **Patching Servers**
    How do you patch EC2 instances in your environment?

17. **Server Count**
    How many servers are there in your environment?

18. **Linux vs Windows Servers**
    How many Linux and Windows servers are you managing?

19. **Environment Details**
    What environments are present in your infrastructure (e.g., Dev, QA, Prod)?

20. **Elastic IP Usage**
    What is the use of an Elastic IP in AWS?

21. **WAF Overview**
    What is AWS WAF and where would you use it?

22. **Load Balancer Setup**
    What is a Load Balancer, and how do you set it up in AWS?

23. **ALB vs NLB**
    What is the difference between an Application Load Balancer (ALB) and a Network Load Balancer (NLB)?

24. **ASG Configuration**
    What is an Auto Scaling Group (ASG) and how do you configure it?

25. **SSM Use Case**
    What are the use cases of AWS Systems Manager (SSM)?

26. **ACM Overview**
    What is AWS Certificate Manager (ACM)?

27. **SSL Certificate Purpose**
    What is an SSL certificate, and how is it used?

28. **SSL Certificate Renewal**
    How do you renew an SSL certificate in AWS?

29. **Patching Without Downtime**
    If two servers are running the same application, how do you patch them without downtime?

30. **EC2 Status Checks**
    What do the EC2 instance status checks (e.g., 1/2, 2/2) indicate?

31. **SG vs NACL**
    What is the difference between a Security Group and a Network ACL, and when would you use each?

32. **Route Table Use Case**
    What is a Route Table in AWS, and what is its purpose?

33. **S3 Use Cases**
    What are your use cases for Amazon S3?

34. **Web Hosting on S3**
    How do you host a static web application using S3?

35. **Gateway Endpoint**
    What is a Gateway Endpoint in AWS, and when would you use it?

35. **Interface Endpoint**
    What is a Interface Endpoint in AWS, and when would you use it?

36. **VPC Peering**
    What is VPC peering, and how does it work?

37. **Transit Gateway**
    What is a Transit Gateway, and how does it differ from VPC peering?

38. **AMI vs Snapshot**
    What is the difference between an AMI and a snapshot in AWS?

39. **EC2 Monitoring**
    How do you monitor a Linux EC2 instance (e.g., using CloudWatch or custom metrics)?

40. **EC2 Security**
    How do you secure an EC2 instance (e.g., patching, IAM roles, security groups, OS hardening)?

---

## Common AWS Troubleshooting Scenarios (Q\&A)

**Q: Your EC2 has a public IP and the port is open in the security group, but it's unreachable. Why?**
**A:** Check the subnet’s network ACL. If inbound or outbound rules are blocking traffic, the security group won’t help. NACLs silently drop traffic with no message.

**Q: You shared an AMI with another AWS account, but they still can’t launch an instance from it. What’s usually missed?**
**A:** Sharing the AMI isn’t enough. You also need to share the associated EBS snapshot. Without that, the AMI looks valid but fails at launch.

**Q: You restored an RDS snapshot for staging, but some queries behave differently than production.**
**A:** When you restore from a snapshot, RDS assigns the default parameter group by default. Custom parameter groups from production are not restored automatically. If not manually reassigned, staging may run with different settings, leading to changes in query behavior or performance.

**Q: You enabled IAM roles for service accounts in EKS, but your pod can’t access S3. The role looks fine. What’s the catch?**
**A:** The pod must be using a service account with the right annotation linking to the IAM role. If the pod defaults to the default service account or the annotation is missing, the role doesn’t apply.

**Q: ALB is marking your targets as unhealthy, but hitting the app directly works fine.**
**A:** ALB health checks are strict. If your app returns a 301 or a login page without a clean 200 OK, it’ll fail the check even if the app seems fine in the browser.

**Q: You pushed a new image to ECR and updated your ECS task definition, but it still runs the old version.**
**A:** You likely forgot to create a new revision of the task definition or update the service to use the new revision. ECS won’t automatically pick up the new image unless explicitly told to do so.
