#!/bin/bash


./check-hostname.sh

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

