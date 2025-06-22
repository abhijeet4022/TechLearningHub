Linux System Administration Q&A Documentation
=====================================================

TABLE OF CONTENTS
==================
1. File System & Storage
2. LVM & Storage Management  
3. User & Group Management
4. Networking
5. Security
6. Process Management
7. Job Scheduling
8. Package Management


=====================================================

FILE SYSTEM & STORAGE
======================

1. What is partition?
Partition is logical division of hard disk.

2. What is file system?
It is a method of storing the data in organized fashion on the disk.

3. What is mounting?
Attaching a directory to the file system in order to access the partition and its file system is known as mounting.

4. Why do we have multiple partitions?
By using multiple partitions we can restrict the file system corruption to one partition only. Depending on our usage we can format the partition with different block size (so we can reduce the wastage of the disk).

5. What is the command to check recent mounted file system?
By using mount command: cat /etc/mtab

6. What is the command to check all mounted file system and file system type?
df -hT

7. What are the commands available to check the disk and disk size?
fdisk -l, lsblk

8. How to make file system?
mkfs.ext4/xfs <file system> <device name>

9. How to see the disk usage information of mounted partition?
df -hT

10. How to see the size of file or directory?
du -sh *

11. How to sort the biggest file from the current location?
du . | sort -nr | head -n10

12. When trying to unmount the filesystem it is not umounting, how to troubleshoot this one?
If someone is accessing directory that we want to umount, it will not be umount. First we need to check:
#fuser -cu <device name> # Check users/processes
#fuser -ck <mount point> to kill the user to access the mount point.
Then we can umount the file system

13. What are the different types of file systems supported in Linux?
The Linux supported file systems are ext4, xfs, nfs, cifs, iso9660, vfat, cdfs, hdfs, etc.

## 14. How to Create Partition?

To create a partition using `fdisk`, follow these steps:
```bash
fdisk <device name>
```
### Step-by-step Instructions:

1. **Type `n`** to create a new partition.
2. **Choose `p` or `e`**:
    * `p` for primary partition
    * `e` for extended partition
3. **First cylinder** – Press `Enter` to accept the default.
4. **Last cylinder** – Enter size in `+<size>` format, e.g., `+1G`, `+500M`.
5. **Type `t`** to change the partition type ID:
    * `83` for Linux
    * `82` for Swap
    * `8e` for LVM
6. **Type `w`** to write the changes and save to disk.


15. How to mount file system temporarily and permanently?
For temporarily mount:
mount <device name> <mount point>

For permanent mount:
vim /etc/fstab
<device name> <mount point> <file system type> <mount option> <take a backup> <fsck value>
:wq!

16. The partitions are not mounting even though there are entries in /etc/fstab. How to solve this problem?
First check any wrong entries in the /etc/fstab file. If all are ok, then it should mount:
mount -a

=====================================================

LVM & STORAGE MANAGEMENT
=========================

17. What is swap?
Swap is used in system when the RAM is full and system needs more memory resource to load the process. When the RAM is full, inactive pages will transfer from RAM to swap.

18. What is the basic rule of swap size?
If the size of the RAM is less than or equal to 2GB, then the size of the swap = 2*RAM size
If the size of the RAM is more than 2GB, then the size of the swap = 2GB+RAM size

19. What is hex code of swap?
82

20. How to see the swap size and RAM size?
free -h

## 21. How to Create Swap
To create and enable a swap partition:
### Steps:
```bash
# 1. Ensure partition is created with hex code 82 (Linux swap)
# 2. Create the swap space
mkswap <device name or partition name>
# 3. Enable the swap
swapon <device name or partition name>
# 4. Add to /etc/fstab for persistent mount
# Format:
<device> swap swap defaults 0 0
# Example:
/dev/sdb1 swap swap defaults 0 0
# 5. Mount the swap
mont -a
# Check the swap status
swapon --show 
```

22. What is the file available to check the swap size?
/proc/swaps

23. What is inode number?
An inode number contains the record of file and directory.
i.e: location in the file system, their name, owner account and permission.

24. What is metadata?
Meta data is the data about data like index.

25. How to check the integrity and consistency of the file system?
By using fsck command

26. Why the file system should be unmount before running fsck command?
If we run fsck on mounted file system then it will corrupt the file system.
So we need to umount the file system before running the fsck command.

27. How to check file system is corrupted or not?
By using fsck command

28. How to create file with particular size?
dd if=/dev/zero of=filename bs=1MB count=500

29. How to create zero byte file?
touch

30. What is the command to check the health of harddisk?
smartctl -H <harddisk name>

31. What is the command to check the information of harddisk?
smartctl -I <harddisk name>

32. What is LVM? Why do we need LVM?
LVM means Logical Volume Management. The combination of 2 or more physical disks in order to make a big logical disk is called logical volume.

If normal Linux partition is full and an application requires some more disk space, then normal partition cannot be extended for that application requirement. So in this situation we have to use LVM because we can easily extend the LVM and reduce the LVM.

33. How to create LVM?
First we need disk with hex code 8e for LVM.
(a) After that, we will create physical volume by using: pvcreate <device name>
(b) After that we will create VG by using: vgcreate <vgname> <pv name>
(c) After that we will create LV by using: lvcreate -n <lvname> -L +size <vgname with path>
(d) And then make file system to LVM: mkfs.<file system type> <device name>
(e) And then mount to the file system: mount -a

34. How to extend LVM?
lvextend -L +5GB <size> -r <location of LV>

35. How to reduce LVM?
lvreduce -L -500M <size> -r <lv location>

36. Is downtime required to reduce the LVM?
Yes, we need downtime

37. Is downtime required to extend the LVM?
No, but it's better to take the downtime for safety purpose.

38. What is volume group?
Physical volume are storage that we used for lvm.

39. How to extend vg?
vgextend <vg name> <pv name>

40. How to reduce VG?
vgreduce <vgname> <pvname>

41. How to delete Vg?
vgremove <vgname>

42. How to remove lv?
lvremove <lv name>

43. How to extend PV?
We can not extend pv directly but we can add more disk into pv by using pvcreate command.

44. How to remove pv?
pvremove <device name or partition name>

45. How to see the details of physical volume?
pvs, pvdisplay, pvscan

46. How to see the details of volume group?
vgs, vgdisplay, vgscan

47. How to see the details of lv?
lvs, lvdisplay, lvscan

48. What is pv move?
To migrate/moved the lv data from failed physical volume to new physical volume.
1st: umount <lvm mount point>
2nd: Add a new pv size should be equal or greater then failed pv. by using pvcreate command.
pvcreate <disk or partition name>
3rd: Extend the vg with new pv by using # vgextend command
vgextend <vg name> <new pv>
4th: To run pvmove command to move the data from failed pv to new pv by using #pvmove command
pvmove <failed pv> <new pv>
5th Then mount the file system by using mount command.
mount -a
6th: then remove the failed pv from vg by using vgreduce command.
vgreduce <vg name> <failed pv>
After that check the data are safe or not.

49. What is the configuration file of lvm?
/etc/lvm/lvm.conf

50. How to scan lun?
echo "- - -" > /sys/class/scsi_host/host no. or lun no./scan
note: first "-" channel 2nd "-" scsi target id 3rd "-" lun

51. How to mount .iso image?
for temporarily:
mount -t iso9660 <device name> <mount point>
for permanent:
open /etc/fstab
<device name> <mount point> <file system> <mount options> <take a back up> <fsck value>

52. What is advantage of lvm?
If normal linux partition is full and an application require some more disk space, then normal partition cannot be extended for that application requirement so in the situation we have to use lvm. Because we can easily extend the lvm and reduce the lvm.

53. What is bash and shell?
Bash – bash (Bourne Again SHell) is a type of Unix shell and a command language interpreter. It is the default shell for many Linux distributions and is part of the GNU Project (GNU stands for "GNU's Not Unix").
Shell: shell is an interactive interface that allows user to execute commands and utilities in linux o/s. Ex. BASh, SH, ZSH

=====================================================

USER & GROUP MANAGEMENT
========================

54. What is user?
In Linux user is one who uses the system. There can be at least one or more than one user in Linux at time.

55. What is group?
The collection of users is called a group.

56. How many types of groups?
1st: Primary group - It will be created automatically whenever the user is created.
2nd: Secondary group - It will not be created automatically. The admin user should create manually.

57. How many groups can be assigned with user?
A user can be assigned to maximum 16 groups: 1 primary group and 15 secondary groups.

58. What is user management?
User management means managing the user, i.e – creating the user, removing the user, modifying the user.

59. What is group management?
Group management means managing the group. i.e – creating the group, removing the group, and modifying the group.

60. What are the fields available in /etc/passwd file?
<username>:X:<uid>:<gid>:<comment>:<user home directory>:<login shell>

61. What are fields available in /etc/shadow file?
<username>:<password>:<last changed>:<min. days>:<Max. days>:<warn. days>:<inactive days>:<expiry days>:reserved for future.

62. How to check whether user is already created or not?
id, /etc/passwd

63. What are the files that are related to user management?
/etc/passwd - stores user's information like username, uid, home directory and shell etc.
/etc/shadow - it stores users password in encrypted form and other information.
/etc/group - it stores groups information like group name, gid, and other information
/etc/gshadow - it stores groups password In encrypted form.
/etc/passwd- - it stores the /etc/passwd file backup copy.
/etc/shadow- - it stores the /etc/passwd file backup copy.
/etc/default/useradd - Whenever the user create users default setting taken from this file.
/etc/login.defs - users login default setting information taken this file.
/etc/skel - it stores all environmental file and these are copied from this directory to user's home directory.

64. How to change(add) the primary group?
usermod -g <primary group name> <username>

65. How to add the secondary group?
usermod -aG <secondary group name> <username>

66. How to change the login shell?
usermod -s <shell name> <username>

67. How to change or rename the username?
usermod -l <new username> <old username>

68. How to remove all secondary group?
usermod -G "" <username>

69. How to check user belongs to how many group?
groups <username>

70. How to check how many user in a group?
getent group

71. How to check current login shell?
echo $SHELL or cat /etc/passwd

72. How to check all available shell in linux?
chsh -l or cat /etc/shells

73. How to modify user home directory?
usermod -d <home directory name> <username>

74. How to modify uid?
usermod -u <uid> <username>

75. How to modify gid?
groupmod -g <gid> <username>

76. How to create duplicate root?
useradd -o -u 0 -g root <username>

77. How to create user?
By using useradd command: useradd <username>

78. How to delete user?
By using userdel command: userdel <username>

79. What is the command to give password to user?
passwd <username>

80. How to create group?
By using groupadd: groupadd <groupname>

81. How to delete group?
By using groupdel command: groupdel <groupname>

82. What are the uses of .bash_logout, .bash_profile, .bashrc files?
.bash_logout - This is a user's logout ending program file. It will execute first whenever the user is logout.
.bash_profile - this is user's login startup program file. It will execute first whenever the user is login. it consists the user's environmental variables.
.bashrc - This file is used to create the user's custom commands and to specify the umask values for that user's only.

83. How to add user to the group?
gpasswd -a <username> <groupname>

84. How to delete user from group?
gpasswd -d <username> <groupname>

85. How to switch user?
su - <username>
"-" login with home directory

86. How to change the password aging policies?
We can change the password policies in 2 ways.
(1). First open the /etc/login.defs file and modify the current values
vim /etc/login.defs
min -0 - means the user can change the password to any no. of time.
min-2 - means the user can change the password within 2 days. i.e he can change the password after 2 days.
max -5 - means the user should change the password before or after 5 days.otherwise the password will be expired after 5 days.
inactive – 2 - means after password expiry date the grace period another 2 days will be given to change the password.
warning -7 - means a warning will be given to the user about the password expiry 7 days before expiry date.

(2). second by executing the # chage command
i.e: # chage <option> <username>
There options are,
-d - last day <it expire everything>
-E - expiry date
-I - inactive days
-l - list all the policies
-m - min days
-M - max. days
-W - warning days

Note: Whenever we change the password aging policy using # chage command, the information will be modified in /etc/shadow file.

87. What is sudo user?
sudoers (nothing but sudo user) allows particular user to run various root user command without needing a root password.

88. How to give sudo permission to normal user?
we will edit or make entry in /etc/sudoers
i.e: visudo /etc/sudoers
go to 98 line, The make entry format is about of the page
:wq!<save it>
• username ALL=(ALL) ALL # ALL permission but will ask the password
• username ALL=(ALL) NOPASSWD:ALL //All permission and won't ask password
• username ALL=(ALL) NOPASSWD:ALL, !/usr/sbin/fdisk //one command is not allowed.
• username ALL=(ALL) NOPASSWD:/usr/sbin/fdisk, /usr/bin/passwd # .Allowed two commands

89. How to check who logged in and what they are doing?
w

90. What is the command to check who logged in or logged out?
last or /var/log/wtmp

91. What is command to check bad log in?
lastb

92. How to check the reboot history?
last reboot

93. How to check the shutdown history?
last -x

94. How to check kernel version?
uname -r

95. How to check uptime?
uptime, top

96. How to check the PCI slots present in system?
lspci

97. What is the command to change file permission?
chmod
read    write   execute
r       w       x
4       2       1
i.e: chmod ugo+rwx <filename & directory>

98. How to change ownership of file and directory?
chown
i.e: chown userowner:groupowner <file & directory>

99. What are the default permission of file and directory?
Default permission for directory= 777
"       "       "   file= 666

100. What is umask?
Umask define the default file permission for newly created directories and files.

101. What is the default umask value for root user and normal user?
For root user – 022
For normal user – 002

102. What is setuid?
If we plan to allow all the user to execute the root user commands then we go for setuid(suid).
It can be applied for user level and is applicable for files only.
e.g: chmod u+s <filename> (X will be replace with s)

103. What is setgid?
If we plan to allow all the users of one group to get the group ownership permission then we go for setgid (sgid).
It can be applied for group level and is applicable on directory only
chmod g+s <directory name>

104. What is sticky bit?
It protect the data from other users when all the users having full permission on one directory.
It can be applied on other level and applicable for directories only.
/tmp - default sticky bit directory
e.g: chmod o+t <directory name>

105. How to set uid?
chmod u+s <filename>

106. How to set gid?
chmod g+s <directory name>

107. How to set sticky bit?
chmod o+t <directory name>

108. What is the default sticky bit directory?
/tmp

109. Can we mount/unmount the o/s file system?
No

110. What is ACL?
Using ACL (ACCESS CONTROL LIST) we assign the permission to some particular users and groups to access file & directory.

111. How to set ACL?
setfacl -m u:username:permission <file or directory>

112. What is mask?
Mask is maximum level permission for ACL.

113. What is the quota?
By using quota we can restrict the user to use unlimited space and create unlimited file and directory.

114. How many type of quota available?
block or disk quota
inode quota

115. What is inode quota?
To restrict the user to create unlimited file and directory. we use inode quota.

116. What is block or disk quota?
To restrict the user to use unlimited disk space. we use block quota.

117. How to check the centos version?
cat /etc/redhat-release or cat /etc/centos-release

118. How to sort the file according date?
ls -lrt

119. What is the configuration file of umask?
/etc/bashrc

120. What is the range of userid of users?
super/admin user    system user     normal user
root                service         standard user
(0)                 (1 – 999)       (1000 – 60000)

121. How to set quota?
1st need to update mount option for usrquota and grpquota
vim /etc/fstab
/dev/sdb1 /mnt/prod ext4 defaults,usrquota 0 0
mount -o remount,usrquota <mount point>
quotacheck -cu <mount point>
quotaon <mount point>
edquota -u <username>

122. How to change umask value?
By using umask command
By edit the /etc/bashrc

123. How to sort the file size / data wise?
du -sh * | sort -nr

124. How to check open port?
• nmap <ip address of client>
• nmap -P 22 <ip address of client>
• nmap localhost //To check own machine

125. How to check listen port?
netstat -ntulp

126. What is the name represent for NIC?
eth0
eth1

127. How to check network cable is connected or not?
ethtool

128. What is dynamic ip?
In this way system will assign the ip address and hostname dynamically. This means the ip address will be change at every boot.

129. What is static ip?
In this way we assign the ip address and hostname manually. Once we configure the ip address it will not change.

130. What is Netmask?
A Subnet mask allow the users to identify which part of an ip address is reserved for the network and which part is available for host use.

131. What are network main configuration file?
cat /etc/sysconfig/network
(This file keep the information about the hostname assigned the system and if we want to change the hostname permanently, we need to change the hostname in this file)
cat /etc/sysconfig/network-scripts/ifcfg
(This directory keep the configuration of network device connected to the system. exp are ifcfg-eth0 ifcfg-eth1, ifcfg-eth2….etc)
cat /etc/hosts
(This file is responsible for resolving hostname into ip address locally, exp local DNS server is not available)
cat /etc/resolve.conf
(This file keep the address of the DNS server which the clients will be accessing resolve ip address to hostname and hostname to ip address.

132. In which file permanent hostname entry exit?
/etc/sysconfig/network

=====================================================

NETWORKING
==========

133. What is network?
Combination of two or more computers connected together to share their resources with each other is called network.

134. What is public ip and private ip?
Public IP - We have to pay but it can communicate with internet directly. Public IP is unique.
Private IP - Private IP is free and it cannot communicate with internet directly.

135. How to troubleshoot if server is not ping?
1. First need to check server is up or not
2. If server is power off then we have to power it on
3. Sometimes server is powered up but due to network connectivity issue server is not pinging. Then we need to bounce the port to back the server pingable
4. Server and client should be in the same domain if it's in different domain then we have to bring it into same domain.

136. How to trace the packet and routes?
i. tcpdump
ii. iproute
iii. tracepath

137. What is network teaming? what is the benefit of teaming?
Collection of multiple NIC cards and make them as single connection (virtual connection) NIC card is called teaming or bonding.
It is nothing but backup of NIC cards.
Benefit of network teaming:
I. load balancing
II. fault tolerance
III. failover

138. How many mode available in teaming?
1) mode 0 – round robin
2) Activebackup
1) round robin –
It provides load balancing and fault tolerance.
Data will be share by both NIC card in round robin.
If one NIC card failed then another NIC card will be communicate with server
So there is a load balancing and fault tolerance features.
2) Activebackup –
Activebackup means only one NIC card will be activated at a time and another one is in stand by state.
so, there is no load balancing.
But if one NIC card is failed then another NIC card will be activate automatically.

139. How many run level in linux?
1. init 0 - power off
2. init 1 - single user
3. init 2 - multiuser without network
4. init 3 – multiuser with network
5. init 5 – GUI (Graphical user interface)
6. init 6 – Restart

140. How to change the hostname?
hostname <fully qualified domain name> //for temporary set hostname
hostnamectl set-hostname <FQDN> //For permanent set hostname

141. What the DNS command are available?
1. nslookup
2. dig
3. host

142. How to up/down any network configuration?
nmcli con up <connection name>
nmcli con down <connection name>

143. How to see available network connection?
nmcli con show

144. How to see or check status of network devices?
nmcli dev status
nmcli dev show

145. How to connect or disconnect network device?
nmcli dev connect/disconnect <device name>

146. How to check gateway?
route -n

147. How to create any network connection?
1. nmcli connection add con-name <connection name> ifname <device name> type ethernet ipv4.addresses <ip address>/<netmask> ipv4.method manual autoconnect yes

2. nmcli connection add con-name <connection name> ifname <device name> type ethernet ipv4.method auto autoconnect yes

148. How to modify any network connection?
nmcli connection modify con-name <connection name/static_ip> ipv4.addresses <ip address>/<netmask><default gateway>

164. What is SSH?
SSH stands for Secure Shell. It establishes the remote control of Linux machine.

165. What is service for cron job?
crond

166. What is ssh authentication or passwordless access?
To take the remote control of client without password, we established the ssh key based authentication.

167. What is port number of SSH?
22

168. What is ssh configuration file?
/etc/ssh/sshd_config.

169. In which directory public and private key are stores?
/root/.ssh

170. Which key file will copy to client when we copy the key file?
public key file <id_rsa.pub> should be the private key when we established the connection.

171. In client machine which file keep the information of ssh client?
known_hosts

172. How to troubleshoot if client not able to ssh into machine?
1. To establish the ssh connection both server or client should be in the same network.
2. server should be up or running
3. firewall should be allowing the ssh port
4. username should be exist
5. need to check any entry restricting the user for ssh
6. ssh service should be up or running

=====================================================

SECURITY
========

149. What is SELinux?
SELinux stands for Security Enhanced Linux. SELinux is a security policy that protects our resources from unwanted access. By using SELinux we can control our resources that which can be accessed and that which cannot be accessed.

150. What is the log file?
It keep the history or record about services and system event.

151. How to check file context?
ls -Z

152. How to check SELinux status?
getenforce
sestatus

153. What are the SELinux modes available?
1. Enforcing - SELinux on
2. Permissive - SELinux off but warning notification will come
3. Disabled - SELinux off

154. What need to check if application is not running?
1. First: need to check server up or running
2. second: need to check application is available or not
3. Third: application configuration should be perfect to run the application.
4. Fourth: need to check all security policy are allowing or not like firewall, selinux, file context.

155. What is file context?
File context is a security context that apply on the resources to allow or deny access.

156. What is 3 way handshake protocol?
1. SYN - system 1 sends SYN signal to remote system.
2. SYN-ACK - Remote system receives the SYN signal and sends ack signal
3. ACK – system again receives ack signal from remote system and connection is established.

157. How to disabled the selinux?
By editing selinux configuration file
we will open /etc/selinux/config then edit the file selinux=Disabled

234. What is Firewall?
Firewall acts as a packet filtering. It allows the known packet and rejects the unknown packet.

=====================================================

PROCESS MANAGEMENT
==================

217. How many types of processes?
There are six process statuses:
1. Running process (indicated by 'r')
2. Sleeping process (indicated by 's')
3. Waiting Process (indicated by 'w')
4. Stopping process (indicated by 'T')
5. Orphan process (indicated by 'o')
6. Zombie process (indicated by 'Z')

218. How to list all current processes?
ps aux

219. How to kill the process?
kill - Terminate the process based on PID: kill -9 <pid>
pkill - Terminate the process based on process name: pkill -9 <process name>

220. How to change the priority of process?
Nice - By using nice we can change the priority of stop process.
Renice - Where as renice can change the priority of running process.

221. What are the important signals in process management?
1. -1 SIGHUP – to reload (read the configuration and load)
2. -9 SIGKILL – to kill the process forcefully
3. -15 SIGTERM – wait for completing the process and the terminate (terminate gracefully)
4. -18 SIGCONT – to continue or resume the process if it is stopped
5. -19 SIGSTOP – to terminate the process(if it not stopped the process we can not continue or resume that process by ctrl+c or ctrl+z)
6. -2 SIGINT – to interrupt from the keyboard
7. -3 SIGQUIT – to quit the process from keyboard
8. -20 SIGHTSTP – to stop the process (nothing but ctrl+z)

But the most commonly used signals are 1, 9, 15, and 20
The default signal is 15 (gracefully) when we are not specified any signals.

222. What is top command and what its show?
By using top command to check system load average, uptime, how many users are login, memory and swap information, CPU utilization, memory utilization.

223. How to solve the issue if CPU utilization 99% full?
1) First check which process and who executed that process is consuming more CPU utilization or memory utilization by executing # top command
2) Then inform to those users who executed that process through mail message or raising the ticket.
3) If those users are not available or not responding to our mail then we have to change
4) # renice command
5) Before changing the process priority level we have to get or take approval from our term lead or project manager.

224. How to see the system hardware information?
dmidecode
• -t memory //To see the memory information
• -t bios or –s bios-version // To check the bios information.
• -t system // To see the system information
• -t processor // To see the CPU information

225. What is sar utility?
Sar stands for system Activity Record.sar will give CPU usage, memory swap, I/o information for the back dated.

226. How to see the virtual memory status?
vmstat

227. What is command to see the I/o statistics?
iostat

=====================================================

JOB SCHEDULING
===============

158. What is job scheduling?
The process of creating the jobs and making them occur on the specified timing.

159. What is the importance of the job scheduling?
By using job scheduling a system admin can take their critical task on specified time. For example – backup.

160. What are the important files related to cron and at jobs?
a) /etc/crontab - it is the file which stores all the scheduled jobs.
b) /etc/cron.deny - it is the file used to restrict the users from using cron jobs
c) /etc/cron.allow - it is used to allow only users whose names are mentioned in this file to use cron jobs and this file does not exist by default.
d) /etc/at.deny - same as cron.deny for restricting the users to use at jobs
e) /etc/at.allow - same as cron.allow for allowing users to use at jobs

161. How to schedule the cron job?
crontab -e -u <username>
* * * * * <script file or command>

162. What are the five stars in cron?
* * * * *
1st '*' <minute> <0-59>
2nd '*' <hours> <0-23>
3rd '*' <day of month> <1-31>
4th '*' <month of year> <1-12 /jan to dec>
5th '*' <day of the week> <0-6 /sun to mon>

163. How to troubleshoot if cron job failed?
1st: we need to check entry is correct or not
2nd: on that particular time server was up or down.

229. What is crontab command?
Cron job is a job that schedule to execute at a regular frequency.

233. What is at command?
At job can be performed once time. It cannot repeat daily. And at once scheduled, then we can not edit the jobs or modify the time of the job.

=====================================================

PACKAGE MANAGEMENT
==================

180. What is the software?
Software is collection of program to performed some task.

181. What is package management?
Package management means installing the package, removing the package, and updating the package.

182. What is YUM and RPM?
YUM and RPM are package management tools.

183. How to install the package?
yum install <package name>

184. How to remove the package?
yum remove <package name>

185. How to update the package?
yum update <package name>

186. How to list all repositories?
yum repolist

187. How to check system update?
yum check-update

188. How to update the kernel?
yum update kernel

189. How to see install package?
I. rpm -qa <package name>
II. yum list installed <package name>

190. How to check the kernel version?
uname -r

191. What is repository?
Repository is a location from where we downloading our package, software.

192. What is repository configuration file?
/etc/yum.repos.d

193. How to enable and disable repository?
I. yum-config-manager --enable <repo name or repo id>
II. yum-config-manager --disable <repo name or repo id>

194. How to configure local repo?
1. mount the CD or file
mount /dev/sr0 /root/mnt/repo
2. cd /etc/yum.repos.d
move all file into another file
mv /etc/yum.repos.d/* /new dir/
3. then make the repos entry and extension should be .repo.
vim /etc/yum.repos.d/test.repo
[test.repo]
name =centos local repo
baseurl=file:///root/mnt/repo
enabled=1
gpgcheck=0
:wq!
4. yum clean all
5. Then test,
a. yum remove httpd
b. yum install httpd

195. What is local repo and central repo?
Central repo is the Redhat-central repo location or internet location to download the package, where as local repository is our local system location.

196. What is patch?
Patch is the security update or system update.

197. After installation of package or patch if the package or patch is remove then what will happened?
If kernel patch is removed, then the system will be hang, and for others there is no effect.
If package is removed then the application that belongs to that removed package will effect.

198. After applying the patch need to reboot the system or not?
If the patch is kernel patch on clustered patch then only the system reboot is required
If the patch is normal patch then reboot is not required.

199. If the package is not installing. how to troubleshoot?
i. Check the package pre-requisites to install the package
ii. If pre-requisites are not matched with our system, then the package will not be installed. i.e, o/s compatibility to install that package.
iii. If there is no sufficient space in the system, then package will not be installed
iv. If the package is not properly download then the package will not be installed

200. If the patch is not applied successfully what will you do?
I. Check whether the patch is installed properly or not by # rpm –qa <patch name> command
II. Check the /var/log/yum.log file to verify or see why the patch is not successfully installed.
III. If any possible to resolved those issues, resolve that patch with # rpm –e <patch name> command
IV. If any reboots required to effect, then reboot the system.
V. Again add that patch by # rpm –ivh <patch name>
VI. Then check the patch by # rpm –qa <patch name>

201. What is backup?
To take the copy of our data in other disk is known as backup.

202. What is restore?
Copy the data from backup disk to local disk is known as restore.

203. What is the benefit or purpose of backup?
The main purpose of backup to recover the data in event of data loss.

204. How to take backup using tar?
tar -cvf <tarname with .tar extension> <file name>

205. What is compressing and decompressing?
Compressing will reduce the size of the file
Decompressing will restore the previous size of the file.

206. What is scp and rsync?
By using scp and rsync we can upload and download files from local to remote and remote to local.
Rsync tool will first compare the file and directory upload and download only the changes. But scp will upload and reload the complete file.

207. How many type of backup available?
There are mainly three type of back up available:
I. Full backup (Entire file system backup)
II. Incremental backup (backup from the last full backup or incremental backup)
III. Cumulative or differential backup

208. What is the difference between incremental and differential backup?
An incremental backup only includes the data that has changed since the previous backup. A differential backup contains all of the data that has changed since the last full backup.

209. What is snapshot?
Snapshot will take exact copy of the system at the point the of time.

210. What is service and daemon and process?
Service - A linux service is an application that runs in the background waiting to be used or carrying out essential tasks.
Daemon - A daemon is long running background process that answers request for services.
Process - An instance of running program is called a process.

211. How to start, restart and stop the service?
systemctl start <service name>
systemctl restart <service name>
systemctl stop <service name>

212. How to enable and disable the service?
systemctl enable <service name>
systemctl disable <service name>

213. How to check the status of the service?
systemctl status <service name>

214. How to see the default target?
systemctl get-default <target name>

215. How to set the default target?
systemctl set-default <target name>

216. How to list the dependency?
yum deplist <package name>

228. How to rollback an update into the?
• yum history list all // To check the all transaction id
• yum history info <trans. ID> // To the information about the transaction id
• yum history undo <trans. ID> // To roll back into the previous step

230. What is ping?
Ping command send the ICMP (internet control message protocol) echo request and waiting for a respond from destination host.

231. What is multicasting?
Multicasting allows a single message to be sent to a group of recipients

232. What is gateway?
A gateway is the network point the provide & entrance into another network.

235. What is Nagios?
Nagios is a continuous monitoring tool that monitor the system network, infrastructure services etc by using SNMP (agent less) protocol and NRPE client agent.

By using Nagios we can reduce the downtime because it will sent alert if anything goes wrong.
• NRPE – Nagios remote plugin executer.
• SNMP – Simple Network Management protocol

=====================================================

NTT DATA QUESTIONS
===================

Q1. How to see the attach disk of VM
Answer: lsblk, fdisk -l, df -h

Q2. How to see the attached disk of LVM
Answer: pvs, vgs, lvs, pvdisplay, vgdisplay, lvdisplay

Q3. How to change the Kernel Parameter
Answer:
Temporary: sysctl -w <parameter>=<value>
Permanent: Configure the value under /etc/sysctl.conf file and then apply the changes by sysctl -p

Q4. How to increase the swap space
Answer: Create additional swap partition or swap file using mkswap and swapon commands

Q5. What is Linux Boot Process and Swap Space
Answer: Linux boot process involves BIOS/UEFI -> Bootloader -> Kernel -> Init system. Swap space is virtual memory used when RAM is full.

Q6. How to fix if Linux System is hanging
Answer: Check system resources, kill problematic processes, check logs, restart services, or reboot system

Q7. What is mirroring in RAID
Answer: RAID mirroring (RAID 1) creates exact copies of data on multiple disks for redundancy

Q8. How to check the open ports
Answer: netstat -ntulp, ss -ntulp, nmap localhost

Q9. How to switch between run levels
Answer: systemctl isolate <target>, init <runlevel>, telinit <runlevel>

=====================================================

ADDITIONAL QUESTIONS
====================

173. What happened when /usr is full?
user can not login to the system
If already login users not able to execute any command.

174. What happened when memory space is full?
when memory full we can not run any application.

175. In how many way we can create the swap space?
1. By creating a new swap partition on the disk.
2. By creating swap file.

176. Is it necessary to create the swap at the time of installation?
Yes, It will automatically create at time of installation.

177. What is swap out and swap in?
when process moving from RAM to swap space is known as swap out.
when process moving from swap to RAM is known as swap in.

178. How to flush the cache or RAM?
sync; echo 1 > /proc/sys/vm/drop_caches.

179. What is the file system of swap?
Swap

=====================================================

END OF DOCUMENT
================

Total Questions: 235+
Categories: 9 main categories
Last Updated: 2025

# Linux System Administration Q\&A Documentation - Part 2
===========================================================

## ADDITIONAL QUESTIONS & ANSWERS

### TABLE OF CONTENTS

1. System Management & Operations
2. ITIL & Service Management
3. Cloud & Virtualization
4. System Boot Process
5. Troubleshooting
6. File System Management

---

## SYSTEM MANAGEMENT & OPERATIONS

**1. What is Downtime?**
Downtime is the time when production is stopped for planned maintenance.

**2. What is decommission and recommission?**
Decommission means the process of removing/deleting old system/server from the production environment and
Recommission/Provisioning means the process of putting/creating the new system into the production environment.

---

## ITIL & SERVICE MANAGEMENT

**3. What is SLA?**
SLA stands for Service Level Agreement. It is a commitment between service provider and client. Like: service quality, availability, responsibilities.

**Priority Response and Recovery Availability:**

| Priority Code | Description | Target Response Time | Target Resolution |
| ------------- | ----------- | -------------------- | ----------------- |
| 1             | Critical    | 15-30 Min            | 4 hours           |
| 2             | High        | 1 hour               | 8 hours           |
| 3             | Medium      | 4 hours              | 3 Business days   |
| 4             | Low         | 24 hours             | 5 Business days   |

**4. What is ITIL process?**
ITIL is a set of rules that provide the selection, planning, delivery, maintenance and overall lifecycle of IT service within a business.

**5. What is Incident management?**
Incident management describes the necessary actions taken by an organization to analyze, identify and correct current problems, while taking actions that can prevent future incidents.

**6. What is incident?**
Incident is an unexpected event that affects business operations. It starts with INT. Example: suddenly disk failed.

* Server is down
* File system is full
* Application is not working

**7. What is change management?**
In ITIL, change is "the addition" or removal of anything that could have a direct or indirect effect on service. It starts with CNG. For example: BIOS update.

* Patching
* Disk Extension
* Application Installation

**8. What is service request?**
A formal user request for something new to be provided is known as service-request. It starts with SR. For example: I need a new laptop.

* Server Provisioning
* Server Decommissioning

---

## CLOUD & VIRTUALIZATION

**9. What is cloud?**
Cloud provides on-demand compute power, storage, database, applications and other IT resources via the internet.

**10. What are the top companies that provide cloud services?**

1. AWS (Amazon Web Services) - Amazon
2. Azure - Microsoft
3. GCP (Google Cloud Platform) - Google

**11. What is Virtualization?**
Virtualization allows us to host multiple virtual machines (VM) on a single physical machine by splitting the host machine hardware resources.

**12. What is Hypervisor?**
A hypervisor is software that creates and allows a host computer to support multiple guest VMs by virtually sharing its resources, such as memory and processing.

**13. What are applications available for virtualization?**

1. VMware Workstation (VMware)
2. Virtual Box (Oracle)

**14. What is KVM?**
KVM stands for Kernel-based Virtual Machine. It is a virtualization technology to run virtual machines in Linux operating system.

---

## SYSTEM BOOT PROCESS

**15. What is BIOS?**
BIOS stands for Basic Input Output System. It performs some integrity checks, searches, loads and executes the boot loader program.
Once the boot loader program is detected and loaded in the memory, BIOS gives the control to it. So in simple terms, BIOS loads and executes the MBR boot loader.

**16. How to check BIOS version?**
`dmidecode -s bios-version`

**17. What is kernel?**
Kernel is the heart of the operating system. It establishes relationship between hardware and software.

**18. How to check the kernel version?**

* `uname -r`
* `cat /proc/version`

**19. How to update kernel?**
`yum update kernel`

**20. Is downtime required to update the kernel?**
Yes, because after updating the kernel version we have to restart the system.

---

## TROUBLESHOOTING

**21. How to Troubleshoot if a User is Not Able to Login**
When a user is unable to log in, check the following step by step:

1. **Check if /var or /usr is full**

    * Use: `df -hT`
    * If /var is full, login can fail because logs, user sessions, and authentication tokens are written here.

2. **Check if the user’s password is expired**

    * Use: `chage -l <username>`
    * If expired, reset the password using: `passwd <username>`

3. **Check if the user account is locked**

    * Use: `passwd -S <username>`
    * If locked (shows 'L'), unlock using: `usermod -U <username>`

4. **Check for /etc/hosts.deny restrictions**

    * Look for entries like `sshd: <username>` or `sshd: ALL`

5. **Check if the user exists**

    * Use: `id <username>`
    * If 'no such user', the account may not exist.

6. **Check system logs**

    * Use: `journalctl -xe` or check `/var/log/secure` or `/var/log/auth.log`

7. **Also verify user is exist or not**

**22. How to Fix File System Full Issue?**
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

---

## FILE SYSTEM MANAGEMENT

**23. There is Free Space in Disk but User is Not Able to Create File in That File System, Why?**
If the inode number is full on that file system, then we cannot create new files or directories even if there is free space available.

**Explanation:**
Each file or directory on a Linux file system consumes an inode. Inodes store metadata about files (such as ownership, permissions, and location on disk). If all inodes are used up, the file system cannot accommodate any new files, regardless of the remaining disk space.

**How to Check Inode Usage of disk:**

* Use: `df -i`
* Look for 100% usage under the 'IUse%' column.

**Solution:**

* Remove unnecessary small files.
* Compress files.
* Reformat with more inode support if needed.

**24. How to Fix if User is Not Able to Do SSH to AWS Server**
Follow these steps to troubleshoot SSH login issues to an AWS EC2 instance:

1. Check Security Group Rules (port 22 open)
2. Check Network ACLs (inbound/outbound allow SSH)
3. Verify SSH Key Pair (`chmod 400 your-key.pem`)
4. Check SSH Command Format (`ssh -i your-key.pem ec2-user@<public-ip>`)
5. Verify Instance Reachability (`ping` or `telnet <IP> 22`)
6. Check if `/` or `/var` is full
7. Validate `/etc/ssh/sshd_config`
8. Use EC2 Instance Connect or Systems Manager
9. Ask user to try SSH, monitor with: `journalctl -u sshd -f`

**25. How to check inode number of files?**
`ls -i`

---

## SUMMARY

This document contains 25 additional questions covering:

* System Management & Operations (2 questions)
* ITIL & Service Management (6 questions)
* Cloud & Virtualization (6 questions)
* System Boot Process (6 questions)
* Troubleshooting (2 questions)
* File System Management (3 questions)

These questions complement the main Linux System Administration Q\&A documentation and provide comprehensive coverage of advanced system administration topics.

---

**END OF DOCUMENT**
Total Additional Questions: 25
Categories: 6 main categories
Last Updated: 2025

This document serves as Part 2 of the comprehensive Linux System Administration Q\&A series.
