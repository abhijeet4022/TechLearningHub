OS Disk: /dev/sda1

Shutdown the Instance from AWS Console.
Detach the OS disk from the instance.
Attach the OS disk to a temporary instance as a secondary volume.
SSH into the temporary instance.
Identify the attached volume (e.g., /dev/xvdf).
Create a mount point and mount the volume:

SSH into the rescue instance
Create a mount point:
sudo mkdir /mnt/rescue
sudo mkdir /mnt/rescue/boot
sudo mkdir /mnt/rescue/boot/efi

2.2 Mount root partition (nvme1n1p4)