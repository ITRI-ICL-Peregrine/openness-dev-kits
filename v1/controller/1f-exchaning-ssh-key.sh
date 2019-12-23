#!/bin/bash

#ssh-copy-id $( cat $WORKING_DIR/inventory.ini |grep 'ansible_ssh' |cut -d'=' -f3 )

data=$( cat $WORKING_DIR/inventory.ini |grep 'ansible_ssh' |cut -d'=' -f3 )
arr=(${data// / });

length=${#arr[@]}

for(( j=0; j<$length; j++ ))
do
    line=${arr[$j]}
    #echo $line
    ssh-copy-id $line
done
