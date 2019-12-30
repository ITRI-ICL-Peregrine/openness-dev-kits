#!/bin/bash


$TOOLS/deploynode/check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
	exit;
fi

# --------------------------------------

yum --enablerepo=extras -y install epel-release 
yum update -y

yum -y install centos-release-qemu-ev
yum install -y qemu-kvm-ev qemu-img-ev virt-manager \
libvirt libvirt-python libvirt-client virt-install virt-viewer

yum install -y yum-utils \
device-mapper-persistant-data lvm2 ansible python-pip git wget \
zip unzip nano qemu-kvm qemu kvm \
dbus-x11 libvirt net-tools libguestfs-tools firefox


# ---------------- Install Docker ----------------------


yum-config-manager --add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce docker-cli containerd.io
pip install docker-py

# ----------------------------------------------------

echo "clear_emulator_capabilities = 0" >> /etc/libvirt/qemu.conf
echo 'user = "root"' >> /etc/libvirt/qemu.conf
echo 'group = "root"' >> /etc/libvirt/qemu.conf

echo "cgroup_device_acl = [" >> /etc/libvirt/qemu.conf
echo '   "/dev/null", "/dev/full", "/dev/zero",' >> /etc/libvirt/qemu.conf
echo '   "/dev/random", "/dev/urandom",' >> /etc/libvirt/qemu.conf
echo '   "/dev/ptmx", "/dev/kvm", "/dev/kqemu",' >> /etc/libvirt/qemu.conf
echo '   "/dev/rtc", "/dev/hpet", "/dev/net/tun","/dev/vfio/vfio",' >> /etc/libvirt/qemu.conf
echo "]" >> /etc/libvirt/qemu.conf

# systemctl restart libvirtd.service
service libvirtd restart
