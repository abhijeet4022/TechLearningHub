# Logrotate overview

## What is `logrotate`?

`logrotate` is a system utility that automatically rotates, compresses, and removes log files on a repetitive manner to help manage disk space and log history.

### How rotation Works:

* Uses configuration in:
  * `/etc/logrotate.conf` (main config file)
  * `/etc/logrotate.d/` (additional per-service configs)
* Keeps track of last rotation in:
  * `/var/lib/logrotate/logrotate.status`

> When logrotate runs, it checks the last rotation date from /var/lib/logrotate/logrotate.status. Based on the rotation interval set in the config (daily, weekly, etc.), it decides whether to rotate the log. If rotation happens, it updates the status file with the new date.

### How Rotation Schedule works:

* Based on directives like `daily`, `weekly`, or `monthly`
* Actual rotation only happens **if enough time has passed** since the last rotation (checked via `logrotate.status` files)

## How Logrotate Runs
> On most Linux systems, logrotate runs daily via /etc/cron.daily/logrotate or through a systemd timer like logrotate.timer.
> If it's not running via cron or systemd, log rotation won't happen automatically — you'll need to either: Manually run logrotate via a script/cron, Or enable the systemd timer using:

### 1. **Using Systemd**

systemctl status logrotate.timer
systemctl status logrotate.service

#### Setup Logrotate to run by systemd timer.
```bash
# Step 1: Create a systemd service file
cat <<EOF > /usr/lib/systemd/system/logrotate.service
[Unit]
Description=Rotate log files
Documentation=man:logrotate(8) man:logrotate.conf(5)
RequiresMountsFor=/var/log
ConditionACPower=true

[Service]
Type=oneshot
ExecStart=/usr/sbin/logrotate /etc/logrotate.conf

# performance options
Nice=19
IOSchedulingClass=best-effort
IOSchedulingPriority=7

# hardening options
#  details: https://www.freedesktop.org/software/systemd/man/systemd.exec.html
#  no ProtectHome for userdir logs
#  no PrivateNetwork for mail deliviery
#  no NoNewPrivileges for third party rotate scripts
#  no RestrictSUIDSGID for creating setgid directories
LockPersonality=true
MemoryDenyWriteExecute=true
PrivateDevices=true
PrivateTmp=true
ProtectClock=true
ProtectControlGroups=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectSystem=full
RestrictNamespaces=true
RestrictRealtime=true
EOF

systemctl enable/start logrotate.service

systemctl enable/start --now logrotate.timer
systemctl list-timers | grep logrotate
# This will schedule logrotate based on the timer defined by your OS.
```

### 2. **Using Cron Jobs**
cat /etc/cron.daily/logrotate

#### Setup

```bash
# Step 1: Create a logrotate script inside /etc/cron.daily
cat <<EOF > /etc/cron.daily/logrotate
#!/bin/bash
/usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status /etc/logrotate.conf
EOF

# Step 2: Provide execute permission
chmod +x /etc/cron.daily/logrotate

# Step 3: Confirm cron.daily is run via /etc/crontab
cat <<EOF >> /etc/crontab
# Run all jobs inside/etc/cron.daily at 12:00 AM daily
0 0 * * * root run-parts /etc/cron.daily
            or
# Run only logrotate script at 12:00 AM daily
0 0 * * * root /etc/cron.daily/logrotate
            or
# Run logrotate directly from /etc/crontab at 12:00 AM daily
0 0 * * * root /usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status /etc/logrotate.conf
EOF

# run-parts: run all the scripts inside directory alphabetically.
```

# Commands to Work with Logrotate

## Find all logrotate-related files
```bash
find / -type f -iname '*logrotate*' 2>/dev/null
```

## Compress a log file manually
```bash
gzip -c /var/log/messages > /tmp/messages.gz
```

## Force Logrotate to run immediately
```bash
logrotate -f /etc/logrotate.conf
```

## Dry Run Logrotate: To check when rotation would happen
```bash
logrotate -d /etc/logrotate.conf
```

---

## Logrotate maintains the rotation status in a file
```bash
[root@master ~]# cat /var/lib/logrotate/logrotate.status
logrotate state -- version 2
"/var/log/nginx/error.log" 2025-7-24-20:20:8
"/var/log/firewalld" 2025-7-24-20:33:25
"/var/log/boot.log" 2025-7-24-20:33:25
```

---

## Sample Logrotate Configuration
```bash
# Target log file to be rotated
/var/log/messages              # Target log file to be rotated
{
    weekly                     # Rotate weekly
    rotate 4                   # Keep 4 backups
    compress                   # Compress old logs using gzip
    delaycompress              # Delay compression until next cycle (safer with copytruncate)
    missingok                  # Don’t error if log file is missing
    notifempty                 # Don’t rotate if the log file is empty
    copytruncate               # Copy + truncate the original log (keeps syslogd happy) don't use for rsyslogd.
    create 0640 root root      # Create new log with correct permissions
    sharedscripts              # Run postrotate only once for all files (if multiple)
    postrotate
        [ -f /var/run/syslogd.pid ] && /bin/kill -HUP $(cat /var/run/syslogd.pid) 2> /dev/null || true
    endscript
}


```

## If you're using rsyslog instead of syslogd, the postrotate command should be:
```bash
    postrotate
        [ -f /var/run/rsyslogd.pid ] && /bin/kill -HUP $(cat /var/run/rsyslogd.pid) 2> /dev/null || true
    endscript
```
> Note: If we using `kill -HUP` then `copytruncate` is not needed.

## Explanation of the above configuration:
```
Before rotation:
/var/log/messages (200 MB, being written to by syslogd)

During rotation:
1. copy: messages → messages.1                          # copytruncate makes a copy first
2. truncate: messages → size 0                          # and then truncates the original (keeps syslogd writing)
3. compress skipped for messages.1                      # delaycompress delays compression until next rotation
4. create: new /var/log/messages created (0640 root:root) if needed. (create is skipped because file still exists due to copytruncate)
5. postrotate: send HUP signal to syslogd via PID file  # [ -f /var/run/syslogd.pid ] && kill -HUP

After rotation:
/var/log/messages        → 0 bytes, syslogd continues writing here
/var/log/messages.1      → contains previous uncompressed logs
/var/log/messages.2.gz   → older logs now compressed (from earlier rotation)

```

---

## logrotate /etc/logrotate.conf

* This runs logrotate normally, using the timestamp from the status file (usually `/var/lib/logrotate/logrotate.status`).
* It checks when each log was last rotated, and compares it to the rotation interval (daily, weekly, etc.).
* Only logs that are due for rotation will be processed.

## logrotate -f /etc/logrotate.conf (`-f = force`)

* Forces rotation of all logs listed in the config file, regardless of when they were last rotated.
* Ignores the timestamps in the status file and rotates logs unconditionally.
* Still updates the `logrotate.status` file with the current timestamp.

---

## Dummy Logrotate Configuration for Testing

```bash
# Create dummy log file
touch /tmp/testlog.log
echo "Log entry: $(date)" >> /tmp/testlog.log

# Create dummy logrotate config
cat <<EOF > /tmp/testlogrotate.conf
/tmp/testlog.log {
    daily
    rotate 3
    missingok
    notifempty
    compress
    su root root
}
EOF

# Apply the configuration (forcefully) using a separate status file
logrotate -f -s /tmp/testlogrotate.status /tmp/testlogrotate.conf

# Check the updated status
cat /tmp/testlogrotate.status
```

# Error check
```bash
grep -i logrotate /var/log/cron
journalctl -u cron.service
journalctl -u logrotate.service
logrotate -d -v /etc/logrotate.conf
```