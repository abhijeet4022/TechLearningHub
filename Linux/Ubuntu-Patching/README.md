* In Ubuntu, the Unattended Upgrades feature is typically enabled by default for security updates. This means that when you install Ubuntu, it usually comes pre-configured to automatically apply security updates without requiring user interaction.
  - Default Behavior:
  - The system will check for and apply updates automatically at regular intervals (usually daily).
  - The relevant configuration file is usually set to have the APT::Periodic::Unattended-Upgrade "1"; line present, enabling the automatic installation of security updates.
  - How to Check:
  - You can verify the current settings in the /etc/apt/apt.conf.d/20auto-upgrades file. If you see the line set to "1", it means that unattended upgrades are enabled.

  - If you want to change this behavior, you can modify the configuration as described earlier to disable unattended upgrades or customize what types of updates are applied automatically.

  - Note: For users who prefer to have more control over their system updates, it is common to disable this feature or limit it to only security updates while manually managing other package upgrades.
------------------------------------------------------------------------------------------
`https://azuremarketplace.microsoft.com/en-us/marketplace/apps/canonical.0001-com-ubuntu-server-jammy?tab=overview`

# This command shows the last boot/reboot time of the system:
`who -b`
`last reboot`

# To output a list of all installed Linux kernel images on your system
`apt list --installed | grep -i linux-image`
`apt list linux-image-*`

# To check available kernel update.
`apt list --upgradable | grep -i linux-image`

# To check security update.
`apt list --upgradable | grep -i security`

# To check when it's installed.
`grep "linux-image-6.8.0-1014-azure" /var/log/dpkg.log*`

# It indicates auto update is enabled
root@FPLSINPROXYCS01:~# cat /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";

# grub config
* Config file: `sudo cat /etc/default/grub`
* Make it 0 to load default kernel: `GRUB_DEFAULT=0`
* Update the Grub: `sudo update-grub`