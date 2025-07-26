**Linux Interview FAQs**

**1. What is the use case of `/opt` and `/var/lib`? Explain with one example.**

* `/opt`: Used for installing third-party applications.

    * Example: `/opt/splunk` for Splunk installation.
* `/var/lib`: Stores persistent and dynamic data for services and applications.

    * Example: MySQL stores data in `/var/lib/mysql`.

**2. What is the difference between a soft link and a hard link?**

* **Soft Link (Symbolic Link):**

    * Points to the file name.
    * Can cross file systems.
    * Shows different inode numbers.
    * If the original file is deleted, the link is broken.
* **Hard Link:**

    * Points to the file's inode.
    * Cannot cross file systems.
    * Shares the same inode number.
    * Remains accessible even if the original file is deleted.

**3. How do you check disk space usage?**

* Use the `df -h` command to view disk space in human-readable format.

**4. How do you check memory usage?**

* Use the `free -h` command.
* `top` or `htop` also provides real-time memory usage.

**5. What is the difference between `cron` and `at`?**

* `cron`: Schedules recurring tasks.
* `at`: Schedules one-time tasks.

**6. How do you list all running processes?**

* Use `ps aux` or `top`.

**7. How do you kill a process by name or PID?**

* By PID: `kill <PID>`
* By name: `pkill <process_name>`

**8. What is the purpose of `/etc/fstab`?**

* Contains static information about filesystems.
* Used to mount filesystems automatically at boot.

**9. What is the difference between a service and a daemon?**

* **Daemon**: A background process that runs without user interaction.
* **Service**: A daemon that is managed via `systemctl` or `service` commands.

**10. How do you check which ports are listening?**

* `ss -tuln` or `netstat -tuln`

**11. What is the difference between `yum` and `dnf`?**

* `yum`: Legacy package manager for RHEL-based systems.
* `dnf`: Newer package manager with better performance and dependency handling.

**12. How do you view the contents of a `.tar.gz` file without extracting it?**

* `tar -tzf file.tar.gz`

**13. How do you change the hostname of a Linux system?**

* Temporary: `hostname newname`
* Permanent (CentOS 7+): `hostnamectl set-hostname newname`

**14. What is the purpose of `/var/log/messages`?**

* Contains global system messages, including boot logs and errors.

**15. How do you find a file in Linux?**

* `find /path -name filename`
* `locate filename` (requires `updatedb`)

**16. What is SELinux?**

* Security-Enhanced Linux: A kernel security module providing access control policies.

**17. What is the difference between `iptables` and `firewalld`?**

* `iptables`: Traditional firewall tool.
* `firewalld`: Dynamic firewall manager with zones and better usability.

**18. How do you create a new user and set a password?**

* `useradd username`
* `passwd username`

**19. What is the difference between `/etc/passwd` and `/etc/shadow`?**

* `/etc/passwd`: Stores user account information.
* `/etc/shadow`: Stores hashed passwords and password aging information.

**20. Which file is responsible to carry the default values related to user password policy?**
`/etc/login.defs` – This file defines site-specific configuration for the shadow password suite. It includes default password aging and user ID control values such as:

```
PASS_MAX_DAYS   90     # Maximum number of days a password is valid. After 90 days, the user must change the password.
PASS_MIN_DAYS   7      # Minimum number of days between password changes. Users can't change the password within 7 days of the last change.
PASS_WARN_AGE   14     # Number of days before password expiry that the user will be warned.
UID_MIN         1000   # Minimum UID for regular (non-system) user accounts.
UID_MAX         60000  # Maximum UID for regular user accounts.
```

These defaults are used when creating new users and enforcing password policies.
