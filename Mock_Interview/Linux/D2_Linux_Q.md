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



