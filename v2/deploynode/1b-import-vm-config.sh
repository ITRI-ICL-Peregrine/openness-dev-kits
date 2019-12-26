#!/bin/bash

./check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi


# --------------------------------------


# Import XML
echo; echo "# Import XML"; echo
virsh define $TOOLS/deploynode/Controller.xml
virsh define $TOOLS/deploynode/EdgeNode.xml

# ----------------------------------------------------

echo; echo "Change Hostname - Controller"; echo

IMAGE=Controller.qcow2

MOUT_DIR=/root/img/tmp
mkdir -p $MOUT_DIR
guestmount -a /root/img/$IMAGE  -m /dev/centos/root $MOUT_DIR

mount --bind /dev $MOUT_DIR/dev
mount --bind /proc $MOUT_DIR/proc
mount --bind /sys $MOUT_DIR/sys

#Change hostname
chroot $MOUT_DIR /bin/bash << "EOT"
echo "Controller" > /etc/hostname
echo "127.0.0.1 Controller" >> /etc/hosts
echo "::1 Controller" >> /etc/hosts
EOT


#Unmount
umount $MOUT_DIR/dev
umount $MOUT_DIR/proc
umount  $MOUT_DIR/sys
guestunmount $MOUT_DIR

# ----------------------------------------------------

echo; echo "Change Hostname - EdgeNode"; echo

IMAGE=EdgeNode.qcow2

MOUT_DIR=/root/img/tmp
mkdir -p $MOUT_DIR
guestmount -a /root/img/$IMAGE  -m /dev/centos/root $MOUT_DIR

mount --bind /dev $MOUT_DIR/dev
mount --bind /proc $MOUT_DIR/proc
mount --bind /sys $MOUT_DIR/sys

#Change hostname
chroot $MOUT_DIR /bin/bash << "EOT" 
echo "EdgeNode" > /etc/hostname
echo "127.0.0.1 EdgeNode" >> /etc/hosts
echo "::1 EdgeNode" >> /etc/hosts
EOT

#Unmount
umount $MOUT_DIR/dev
umount $MOUT_DIR/proc
umount  $MOUT_DIR/sys
guestunmount $MOUT_DIR

