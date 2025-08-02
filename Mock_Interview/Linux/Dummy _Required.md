**15. How do you find 30 days old a files in /tmp nad delete those files in Linux?**

* `find /tmp -type f -mtime +30 -exec rm -f {} \;`

**1. How do you find files in linux?**
* `find /path -name filename`
* `locate filename` (requires `updatedb`)

