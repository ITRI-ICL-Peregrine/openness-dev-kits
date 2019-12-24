#!/bin/bash

# Import XML
echo; echo "# Import XML"; echo
virsh define $TOOLS/deploynode/Controller.xml
virsh define $TOOLS/deploynode/EdgeNode.xml

# ----------------------------------------------------

echo; echo "Change Hostname - Controller"; echo

IMAGE=Controller.qcow2

cd $WORKING_DIR/img
MOUT_DIR=$WORKING_DIR/img/tmp
mkdir -p $MOUT_DIR
guestmount -a $IMAGE  -m /dev/centos/root $MOUT_DIR

mount --bind /dev $MOUT_DIR/dev
mount --bind /proc $MOUT_DIR/proc
mount --bind /sys $MOUT_DIR/sys

#Change hostname
chroot $MOUT_DIR echo "Controller" > /etc/hostname
chroot $MOUT_DIR echo "127.0.0.1 Controller" >> /etc/hosts
chroot $MOUT_DIR echo "::1 Controller" >> /etc/hosts

#Unmount
umount $MOUT_DIR/dev
umount $MOUT_DIR/proc
umount  $MOUT_DIR/sys
guestunmount $MOUT_DIR

# ----------------------------------------------------

echo; echo "Change Hostname - EdgeNode"; echo

IMAGE=EdgeNode.qcow2

cd $WORKING_DIR/img
MOUT_DIR=$WORKING_DIR/img/tmp
mkdir -p $MOUT_DIR
guestmount -a $IMAGE  -m /dev/centos/root $MOUT_DIR

mount --bind /dev $MOUT_DIR/dev
mount --bind /proc $MOUT_DIR/proc
mount --bind /sys $MOUT_DIR/sys

#Change hostname
chroot $MOUT_DIR echo "EdgeNode" > /etc/hostname
chroot $MOUT_DIR echo "127.0.0.1 EdgeNode" >> /etc/hosts
chroot $MOUT_DIR echo "::1 EdgeNode" >> /etc/hosts

#Unmount
umount $MOUT_DIR/dev
umount $MOUT_DIR/proc
umount  $MOUT_DIR/sys
guestunmount $MOUT_DIR

