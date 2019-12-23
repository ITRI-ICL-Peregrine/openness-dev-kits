#!/bin/bash

ENV=EdgeNode

if [ "$( hostname )" != "edgenode" ]; then echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo; exit; fi

# --------------------------------------

yum --enablerepo=extras -y install epel-release 
yum update -y

yum -y install centos-release-qemu-ev
yum install -y qemu-kvm-ev qemu-img-ev virt-manager \
libvirt libvirt-python libvirt-client virt-install virt-viewer

yum install -y yum-utils \
device-mapper-persistant-data lvm2 ansible python-pip git wget \
zip unzip nano qemu-kvm qemu kvm \
dbus-x11 libvirt net-tools


# ---------------- Install Docker ----------------------


yum-config-manager --add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce docker-cli containerd.io
pip install docker-py


# ----------------- Install MySQL ---------------------

rm -f /tmp/mysql*.rpm*

wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm -P /tmp/

rpm -Uvh /tmp/mysql57-community-release-el7-11.noarch.rpm

yum update -y
yum install mysql-server -y

systemctl start mysqld

# ------------- Install Docker Compose -------------------


curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
