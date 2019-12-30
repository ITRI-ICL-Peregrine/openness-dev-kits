#!/bin/bash

$TOOLS/deploynode/check-hostname.sh

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

if test -f /root/img/Controller.qcow2; then echo "Controller.qcow2 is exist";else echo "NO" && exit; fi

MOUT_DIR=/root/img/tmp
mkdir -p $MOUT_DIR
guestmount -a /root/img/$IMAGE  -m /dev/centos/root $MOUT_DIR

mount --bind /dev $MOUT_DIR/dev
mount --bind /proc $MOUT_DIR/proc
mount --bind /sys $MOUT_DIR/sys

#Change hostname
chroot $MOUT_DIR /bin/bash << "EOT"
echo "controller" > /etc/hostname
echo "127.0.0.1 controller" >> /etc/hosts
echo "::1 controller" >> /etc/hosts
EOT

chroot $MOUT_DIR /bin/bash << "EOT"
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOL
BOOTPROTO=static
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.122.111
NETMASK=255.255.255.0
BROADCAST=192.168.122.255
NETWORK=192.168.122.0
GATEWAY=192.168.122.1
DNS1=192.168.122.1
DNS2=1.1.1.1
DNS3=8.8.8.8
TYPE=Ethernet
PEERDNS=no
EOL
EOT


#Unmount
umount $MOUT_DIR/dev
umount $MOUT_DIR/proc
umount  $MOUT_DIR/sys
guestunmount $MOUT_DIR

# ----------------------------------------------------

echo; echo "Change Hostname - EdgeNode"; echo

IMAGE=EdgeNode.qcow2

if test -f /root/img/EdgeNode.qcow2; then echo "EdgeNode.qcow2 is exist";else echo "NO" && exit; fi

MOUT_DIR=/root/img/tmp
mkdir -p $MOUT_DIR
guestmount -a /root/img/$IMAGE  -m /dev/centos/root $MOUT_DIR

mount --bind /dev $MOUT_DIR/dev
mount --bind /proc $MOUT_DIR/proc
mount --bind /sys $MOUT_DIR/sys

#Change hostname
chroot $MOUT_DIR /bin/bash << "EOT" 
echo "edgeNode" > /etc/hostname
echo "127.0.0.1 edgeNode" >> /etc/hosts
echo "::1 edgeNode" >> /etc/hosts
EOT

chroot $MOUT_DIR /bin/bash << "EOT"
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOL
BOOTPROTO=static
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.122.222
NETMASK=255.255.255.0
BROADCAST=192.168.122.255
NETWORK=192.168.122.0
GATEWAY=192.168.122.1
DNS1=192.168.122.1
DNS2=1.1.1.1
DNS3=8.8.8.8
TYPE=Ethernet
PEERDNS=no
EOL
EOT


#Unmount
umount $MOUT_DIR/dev
umount $MOUT_DIR/proc
umount  $MOUT_DIR/sys
guestunmount $MOUT_DIR


# ----------------------------------

echo "192.168.122.111 Controller" >> /etc/hosts
echo "192.168.122.222 EdgeNode" >> /etc/hosts
