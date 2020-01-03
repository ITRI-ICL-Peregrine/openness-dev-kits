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
dbus-x11 libvirt net-tools libguestfs-tools firefox htop tcpdump

yum groupinstall 'Development Tools' -y

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

# ----------------------------------------------------

# Support exFAT
wget http://download1.rpmfusion.org/free/el/updates/7/x86_64/f/fuse-exfat-1.3.0-1.el7.x86_64.rpm
wget http://download1.rpmfusion.org/free/el/updates/7/x86_64/e/exfat-utils-1.3.0-1.el7.x86_64.rpm

mv *.rpm /tmp/

yum install -y /tmp/fuse-exfat-1.3.0-1.el7.x86_64.rpm
yum install -y /tmp/exfat-utils-1.3.0-1.el7.x86_64.rpm 

sudo rm /tmp/fuse-exfat-*.x86_64.rpm
sudo rm /tmp/exfat-utils-*.x86_64.rpm

# -----------------------------------------------------

# Create Folder

mkdir -p /home/openness/img
ln -s /home/openness/img /root/img
