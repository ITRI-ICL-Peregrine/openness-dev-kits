#!/bin/bash

ENV=controller

if [ "$( hostname )" != "$ENV" ]; then echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo; exit; fi

# ------------------------------------------------------

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
	echo "server $i.centos.pool.ntp.org iburst" >> /etc/chrony.conf
done

## Restart chrony service
systemctl restart chronyd

## Verify Time Synchronization

while : ;do
	if [ "$( chronyc tracking |grep Leap |cut -d":" -f2 )" != " Normal" ]; then 
		echo "Synchronizing...";
		sleep 3; 
	else
		break
	fi
done
chronyc tracking

# ------------------------------------------------------

# Prepare HTTPS CA
/root/openness-experience-kits/itri/v1/controller/create-https-ca.sh
