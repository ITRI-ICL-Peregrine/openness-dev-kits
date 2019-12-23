#!/bin/bash

# Install Necessary Packages
yum --enablerepo=extras -y install epel-release 
yum update -y

yum install -y yum-utils \
device-mapper-persistant-data lvm2 ansible python-pip git wget \
zip unzip nano htop chrony

# ------------------------------------------------------

# Time must be configured on all hosts

# Remove previously set NTP servers
sed -i '/^server /d' /etc/chrony.conf

## Allow significant time difference
## More info: https://chrony.tuxfamily.org/doc/3.4/chrony.conf.html
echo 'maxdistance 999999' >> /etc/chrony.conf

## Add new NTP server(s)
for i in `seq 0 3`; do
	echo 'server $i.centos.pool.ntp.org iburst' >> /etc/chrony.conf
done

## Restart chrony service
systemctl restart chronyd

## Verify Time Synchronization
chronyc tracking

# ------------------------------------------------------


