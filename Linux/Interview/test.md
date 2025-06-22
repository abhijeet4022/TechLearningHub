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
