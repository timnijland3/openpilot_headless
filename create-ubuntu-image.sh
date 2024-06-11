#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit
fi

# Variables
WORK_DIR=~/live-ubuntu
IMAGE_DIR=$WORK_DIR/image
ISO_NAME=live-ubuntu.iso

# Install necessary tools
apt update
apt install -y genisoimage squashfs-tools syslinux-utils

# Create working directories
mkdir -p $IMAGE_DIR/{casper,isolinux,install}
mkdir -p $IMAGE_DIR/live

# Copy the kernel and initrd
cp /boot/vmlinuz-$(uname -r) $IMAGE_DIR/casper/vmlinuz
cp /boot/initrd.img-$(uname -r) $IMAGE_DIR/casper/initrd

# Create a SquashFS of the root filesystem
mksquashfs / $IMAGE_DIR/casper/filesystem.squashfs -e /proc -e /tmp -e /sys -e /mnt -e /media -e /lost+found

# Create isolinux configuration
cat <<EOF > $IMAGE_DIR/isolinux/isolinux.cfg
UI menu.c32
PROMPT 0
TIMEOUT 50
DEFAULT live

LABEL live
    menu label ^Start Ubuntu
    kernel /casper/vmlinuz
    append initrd=/casper/initrd boot=casper quiet splash ---
EOF

# Copy isolinux binaries
cp /usr/lib/ISOLINUX/isolinux.bin $IMAGE_DIR/isolinux/
cp /usr/lib/syslinux/modules/bios/* $IMAGE_DIR/isolinux/

# Create the ISO image
genisoimage -r -V "CustomUbuntu" -cache-inodes -J -l \
-b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
-boot-load-size 4 -boot-info-table -o $WORK_DIR/$ISO_NAME $IMAGE_DIR

# Make the ISO bootable
isohybrid $WORK_DIR/$ISO_NAME

# Inform the user
echo "ISO image created at $WORK_DIR/$ISO_NAME"

# Optional: Clean up
# rm -rf $WORK_DIR
