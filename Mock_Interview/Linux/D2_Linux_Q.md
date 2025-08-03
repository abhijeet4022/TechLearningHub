
### 4. **Logrotate**

A log file is growing very large, and logrotate is not rotating it. What steps will you take to debug and fix this issue?

**Answer:**

* Check logrotate config: `/etc/logrotate.conf` or `/etc/logrotate.d/*`
* Run manually in debug mode:

```bash
logrotate -d /etc/logrotate.conf
```
* Check the logrotate service status or cron job is set properly or not to run the logrotate script.
* Ensure correct permissions, paths, and postrotate scripts.

---

### 5. **OS Patching**

When you are planning to patch production servers. What are the steps you take before and after patching?

**Answer:**
**Before:**

* Notify stakeholders
* Backup or snapshot
* Check disk, memory, uptime
* Check current kernel version
* Check running services
* Check application functionality

**After:**

* Reboot if needed
* Verify patch installation
* Validate service health
* Verify kernel version
* Verify application functionality
* Notify stakeholders

---

### 6. **Performance Monitoring**

One of your EC2 Linux servers is running slow. What Linux commands and tools do you use to troubleshoot performance issues?

**Answer:**

```bash
top/htop       # CPU, memory
vmstat         # Memory and CPU activity
iostat -x      # Disk I/O
free -h        # Memory usage
df -h / du -sh # Disk usage
sar            # Historical stats
Monitoring tools: Prometheus, Grafana
```

### 14. **Web Servers (Nginx/httpd)**

You deployed a web app using Nginx, but when accessing the site, you get a 502 Bad Gateway. How do you troubleshoot this?

**Answer:**

* Check the nginx server is up and running if the server is shutdown state or due to high load sometime server won't respond.
* Check the nginx service status: `systemctl status nginx`
* Verify Nginx configuration: `nginx -t`
* Look for errors in Nginx logs: `/var/log/nginx/error.log`
* Check if the upstream server (e.g., application server) is running and reachable.
* Ensure the upstream server is correctly defined in the Nginx config
* Ensure backend app is running and reachable
* Curl backend directly: `curl localhost:<port>`

---

### 16. How to check the current run level and user?**
* `who -r`
* `whoami`

**12. How do you view the contents of a `.tar.gz` file without extracting it?**

* `tar -tzf file.tar.gz`

**10. How do you check which ports are listening?**

* `ss -tuln` or `netstat -tuln`

**6. How do you list all running processes?**

* Use `ps aux` or `top` or `ps -u <user>`.
#####################################################
###############################################
```


Q. Suppose if have update one system and want to rollback to previous state how will you do that from OS ?


Q. How do you list the patches or packages updated recently?
rpm -qa --last

Q. How do you check if a reboot is required after patching?:   DOne  
Ans. Run the command: needs-restarting -r
```
#Ex.  After Kernel update we can see.
[root@master ~]# needs-restarting -r
Core libraries or services have been updated since boot-up:
* kernel

Reboot is required to fully utilize these updates.
More information: https://access.redhat.com/solutions/27943
```
Q. How will u verify the severity from redhat: https://access.redhat.com/security/security-updates/

Q. Suppose your two server is running bejone the LB and supporting the one application and during patching you have to make sure your application should not went down how will you do that.

Q. How you manage the patching for all environemnt mean all servers in a single shot or part wise ?
```
## Patch Severity Levels
- **Critical**
- **Important**
- **Moderate**
- **Low**
- `yum updateinfo list security all`

# Patch Schedule:
Microsoft releases patches on the 2nd Tuesday of every month, and we apply them on the 3rd Friday of every month. We follow `n-1` patches for production servers and the latest patches for non-production servers.
- 1st Friday Night: Production Servers - `n-1` patch (Windows)
- 2nd Friday: Production Servers - `n-1` patch (Linux)
- 3rd Friday: Non-Production Servers - Latest patch (Windows + Linux)

### For every patching batch, there is usually a fixed Maintenance Window (MW), or you may need to request one depending on the environment. Before initiating the patching process, it is critical to ensure that backups have been completed.
In most cases, where a fixed MW is followed, the backup window is scheduled before the patching MW. Therefore, when the patching MW starts, backups (such as AMIs or EBS snapshots) should already be completed.
Backups can be automated using AWS Backup, a Lambda function to automate the AMI Creation, or by managing the OS Disk snapshots lifecycle using DLM.
For unplanned or emergency patching scenarios involving only a few servers (e.g., 2–3), manual backups or snapshots may be performed just before patching.

For servers behind the load balancer, we patch one server at a time. Once the patches are applied and the first server is up and running properly, we proceed to the next server.

- ALB Target Group: Server1, Server2

* SSM Patch Deployment: Two patch groups
* Patch Group 1: 12 PM - Server1
* Patch Group 2: 2 PM - Server2

- If automatic update fail then will do manual patching by using the command:
* Linux - `yum update --security -y`
* Windows - `Setting - Check for updates - apply updates` once done reboot the server.

```

Q. How can you ensure the services that were running before patching are still running after applying security patches and rebooting in RHEL?
List active services and store the output:
	systemctl list-units --type=service --state=running > /root/running-services-before.txt
After reboot, list running services again:
	systemctl list-units --type=service --state=running > /root/running-services-after.txt
Compare both lists: diff /root/running-services-before.txt /root/running-services-after.txt
# This will show which services are missing, added, or unchanged.

Q. How will you check the securtiy patches and severity 

- List Available Security Updates with Details: yum updateinfo list security all
```
RHSA-2025:1234 Important/Sec. kernel-3.10.0-1160.88.1.el7.x86_64
RHSA-2025:2345 Moderate/Sec. openssl-1.0.2k-25.el7_9.x86_64
RHSA-2025:3456 Low/Sec. bash-4.2.46-34.el7.x86_64

```
- Show Detailed Info (e.g., severity, CVE, advisory): yum updateinfo info security
- Filter by Severity (e.g., only Critical or Important): yum updateinfo list security severity=Critical
- View detailed info about the advisory: yum updateinfo info RHSA-2025:1234

Q. Suppose you have received an  alert stating that cpu utilization of any particulr application server is high 85% how step will you take for this alert.

Q. How to Fix File System Full Issue? OS filesystem as well as Application filesystem ?
When a file system becomes full on a Linux server, follow the steps below to investigate and resolve the issue.

1. **Identify the Full File System**

    * Use: `df -hT`
    * Identify which file system is 100% or nearly full.

2. **Navigate to the Affected Mount Point**

    * `cd /path/to/full/mount`

3. **Identify Large Files or Directories**

    * `du -sh * | sort -h`
    * To include hidden files: `du -sh .[!.]* * | sort -h`

4. **Take Action to Free Up Space**

    * Inform respective user or team.
    * Delete or compress unnecessary files.
    * Move files to another location.

5. **If Cleanup is Not Sufficient**

    * Raise a request to extend file system.
    * Get required approvals from stakeholders (Server and Application Owner).
    * Create a Change Request (CR) following your organization’s change management process.
    * Schedule and perform the file system extension activity.

 
```


## It empties (clears) the contents of the file at /path/to/logfile.log without deleting the file itself.
truncate -s 0 /path/to/logfile.log
