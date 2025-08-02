# AWS and Linux Interview Questions with Answers (For 3+ Years Experience)

---

### Topics Covered:

* Linux (LVM, Cron, Boot Process, etc.)
* AWS (EC2, ELB, S3, CloudWatch, etc.)

---

## 🐧 Linux Questions & Answers

### 1. **LVM**

You're running out of space on `/var`, which is an LVM volume. Walk me through the steps to increase the size of `/var` by 5GB. Assume a new disk `/dev/xvdf` is attached.

**Answer:**

```bash
# 1. Create a new partition
fdisk /dev/xvdf
# Create primary partition and save

# 2. Create physical volume
pvcreate /dev/xvdf1

# 3. Extend volume group
vgextend <vg_name> /dev/xvdf1

# 4. Extend logical volume
lvextend -L +5G /dev/<vg_name>/<lv_name>

# 5. Resize filesystem
resize2fs /dev/<vg_name>/<lv_name>   # For ext4
xfs_growfs /var                       # For xfs
```

---

### 2. **Boot Process**

Can you explain what happens from the moment you power on a Linux system till you get the login prompt?

**Answer:**

1. **BIOS** – Initializes hardware and finds boot device.
2. **MBR/GPT** – Loads the bootloader (GRUB).
3. **GRUB** – Loads the kernel and initrd.
4. **Kernel** – Initializes drivers, mounts root FS.
5. **init/systemd** – Starts target services.
6. **Login Prompt** – System ready for user login.

**Details:**
## Step 1: BIOS / UEFI

### BIOS:

* Stands for **Basic Input/Output System**.
* The first program executed, stored in read-only memory on the motherboard.
* Performs **POST (Power-On Self-Test)** to verify hardware components and peripherals.
* Checks for bootable devices like hard disk, USB, CD, etc.
* Once a bootable device is detected, it hands over control to the **first sector** of the bootable device (i.e., **MBR**).

### UEFI (Unified Extensible Firmware Interface):

* Modern replacement for BIOS.
* Stored on the motherboard; provides more advanced features:

    * Supports disks **larger than 2 TB**.
    * Boots from **GPT-partitioned** disks.
    * Provides a **graphical interface** and **mouse support**.
    * Supports **Secure Boot**, **fast boot**, and **network boot (PXE)**.
    * Looks for **EFI executable files** in the **EFI System Partition** (usually `/boot/efi/EFI/`).

---

## Step 2: MBR / GPT

### MBR (Master Boot Record)
* Stands for **Master Boot Record**.
* Located in the **first 512 bytes** of any bootable device.
* Contains machine code instructions for booting and includes:

    * **Boot Loader** (446 bytes)
    * **Partition Table** (64 bytes)
    * **Boot Signature/Error Checking** (2 bytes)
* Loads the bootloader into memory and hands over control.

### GPT (GUID Partition Table)

* Stands for **GUID Partition Table**.
* Modern replacement for MBR, used with **UEFI** firmware.
* Key features:

    * Supports **disks larger than 2 TB**.
    * Allows up to **128 partitions**.

---

## Step 3: GRUB (GRand Unified Bootloader)

* Loads the following configuration files at boot time:

    * `/boot/grub2/grub.cfg` (BIOS)
    * `/boot/efi/EFI/redhat/grub.cfg` (UEFI)
* Displays GUI/text menu to select OS or Kernel.
* Once a kernel is selected, GRUB locates:

    * Kernel binary: `/boot/vmlinuz-<version>`
    * Initramfs image: `/boot/initramfs-<version>.img`
* Main job is to load the **kernel** and **initramfs** into memory.
* **Note:**

    * `initrd` was used before Linux 7.
    * From Linux 7 onward, `initramfs` is used.
* GRUB is primarily for **x86 architectures**.

    * Other architectures may use different bootloaders (e.g., **ELILO** for Intel Itanium).

---

## Step 4: Kernel

* The **kernel** is loaded into memory by GRUB2 in **read-only** mode.
* The **initramfs** provides a minimal root filesystem to:

    * Detect hardware
    * Load required drivers/modules
    * Mount the real root filesystem (e.g., LVM, RAID)
* After the real root filesystem is mounted, initramfs is removed from memory.
* The kernel then executes the first **user-space process**: `systemd`.

> **Note:** Kernel and initramfs files are stored in the `/boot` directory.

---

## Step 5: Systemd

* First service/process started by the kernel with **PID 1**.
* Manages system boot, services, targets, and shutdown.
* Starts all required units as defined in:

    * `/etc/systemd/system/default.target`
* Brings the system to the appropriate **runlevel/target (0–6)**.
* View available targets:

  ```bash
  ls -l /usr/lib/systemd/system/runlevel*
  ```

## Step 6: Run Levels

* **Init 0** – Shutdown
* **Init 1** – Single User Mode
* **Init 2** – Multi User without Network
* **Init 3** – Multi User with Network
* **Init 4** – Unused
* **Init 5** – GUI Mode
* **Init 6** – Restart


---

### 3. **Cron Job**

How do you ensure a cron job ran successfully? What logs do you check and how would you debug a failing cron?

**Answer:**

```bash
grep CRON /var/log/cron   # or journalctl -u crond
```

* Ensure the script is executable.
* Add logging: `myjob.sh > /tmp/myjob.log 2>&1`

---

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

When you are planning to patch production servers. What are the steps you take before, during, and after patching?

**Answer:**
**Before:**

* Notify stakeholders
* Backup or snapshot
* Check disk, memory, uptime

**During:**

* Use `dnf/yum update` or `apt upgrade`
* Log output for review
* Use SSM for patching in AWS.

**After:**

* Reboot if needed
* Validate service health
* Verify kernel version

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