#!/bin/bash

set -e

# Install necessary packages
apt-get update
apt-get install -y xorriso genisoimage isolinux squashfs-tools

# Download the Ubuntu ISO
UBUNTU_ISO_URL="https://releases.ubuntu.com/20.04/ubuntu-20.04.4-desktop-amd64.iso"
ISO_NAME="ubuntu-base.iso"
wget -O $ISO_NAME $UBUNTU_ISO_URL

# Mount the ISO
MOUNT_DIR="/mnt/iso"
mkdir -p $MOUNT_DIR
mount -o loop $ISO_NAME $MOUNT_DIR

# Copy ISO contents
WORK_DIR="/tmp/iso"
mkdir -p $WORK_DIR
rsync -a $MOUNT_DIR/ $WORK_DIR

# Unmount the ISO
umount $MOUNT_DIR

# Execute the touch command
echo "Creating hi.txt file in home directory"
touch ~/hi.txt

# Customize the ISO
# Example: Add a preseed file for automated installation
PRESEED_FILE="$WORK_DIR/preseed.cfg"
cat <<EOL > $PRESEED_FILE
# Preseed configuration for automated install
d-i debian-installer/locale string en_US
d-i console-setup/ask_detect boolean false
d-i keyboard-configuration/layoutcode string us
d-i time/zone string UTC
d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain
d-i passwd/root-login boolean false
d-i passwd/user-fullname string Ubuntu User
d-i passwd/username string ubuntu
d-i passwd/user-password-crypted password <hashed_password>
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false
tasksel tasksel/first multiselect ubuntu-desktop
EOL

# Modify the boot parameters to include the preseed file
ISOLINUX_CFG="$WORK_DIR/isolinux/txt.cfg"
sed -i 's/append/append file=\/cdrom\/preseed.cfg/' $ISOLINUX_CFG

# Create the new ISO
NEW_ISO="custom-ubuntu.iso"
mkisofs -D -r -V "Custom Ubuntu" -cache-inodes -J -l \
  -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
  -boot-info-table -o $NEW_ISO $WORK_DIR

# Output the ISO location
echo "Custom ISO created: $NEW_ISO"
