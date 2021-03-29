#!/bin/bash

ENV=OpenNESS 

if [ "$( hostname )" != "openness" ]; then echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo; exit; fi

# --------------------------------------

data=$( virsh net-dhcp-leases default | grep ipv4 |awk -F "   " '{print $3}' |cut -d"/" -f1 )

arr=(${data// / }); 

length=${#arr[@]} 


for(( j=0; j<$length; j++ )) do

    node=${arr[$j]}
    ssh $node yum install -y git
    ssh $node rm -r /root/openness-dev-kits
    ssh $node git clone https://github.com/ITRI-ICL-Peregrine/openness-dev-kits /root/openness-dev-kits
    ssh $node /root/openness-dev-kits/v1/common/install-package-and-time-sync.sh
done
