#!/bin/bash

./check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

ssh-keygen

#data=$( cat $WORKING_DIR/inventory.ini |grep 'ansible_ssh' |cut -d'=' -f3 )
data=$( virsh net-dhcp-leases default | grep ipv4 |awk -F "   " '{print $3}' |cut -d"/" -f1 )
arr=(${data// / });

length=${#arr[@]}

for(( j=0; j<$length; j++ ))
do
    line=${arr[$j]}
    #echo $line
    ssh-copy-id -f $line
done

# --------------------------------------


