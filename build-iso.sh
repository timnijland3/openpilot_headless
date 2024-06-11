#!/bin/bash
set -e

# Variables
UBUNTU_VERSION="focal"
WORKDIR=$(mktemp -d)
ISO_IMAGE="custom-ubuntu.iso"
PRESEED_FILE="preseed.cfg"

# Install required packages
sudo apt-get update
sudo apt-get install -y debootstrap squashfs-tools genisoimage

# Bootstrap a minimal Ubuntu system
sudo debootstrap --arch=amd64 $UBUNTU_VERSION $WORKDIR/chroot http://archive.ubuntu.com/ubuntu/

# Chroot and configure the system
sudo mount --bind /dev $WORKDIR/chroot/dev
sudo mount --bind /proc $WORKDIR/chroot/proc
sudo mount --bind /sys $WORKDIR/chroot/sys

sudo chroot $WORKDIR/chroot /bin/bash <<EOF
apt-get update
apt-get install -y python3 python3-pip
pip3 install flask
EOF

sudo umount $WORKDIR/chroot/dev
sudo umount $WORKDIR/chroot/proc
sudo umount $WORKDIR/chroot/sys

# Create a SquashFS file system
sudo mksquashfs $WORKDIR/chroot $WORKDIR/filesystem.squashfs -comp xz

# Create the ISO image
sudo genisoimage -r -V "Custom Ubuntu" -cache-inodes -J -l \
    -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
    -boot-load-size 4 -boot-info-table \
    -o $ISO_IMAGE $WORKDIR

# Move the ISO to the current directory
mv $WORKDIR/$ISO_IMAGE .

# Clean up
sudo rm -rf $WORKDIR
