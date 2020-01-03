#!/bin/bash

$TOOLS/deploynode/check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

# Prepare EdgeNode.xml

sudo cp $TOOLS/deploynode/EdgeNode.xml.org $TOOLS/deploynode/EdgeNode.xml

bus_id=$( ethtool -i $NIC1 |grep bus |cut -d" " -f2 )

first=$( echo $bus_id |cut -d":" -f1 )
second=$( echo $bus_id |cut -d":" -f2 )
third=$( echo $bus_id |cut -d":" -f3 |cut -d"." -f1 )
fourth=$( echo $bus_id |cut -d":" -f3 |cut -d"." -f2 )

sed -i "s/FIRST_ADDR/$first/g" $TOOLS/deploynode/EdgeNode.xml
sed -i "s/SECOND_ADDR/$second/g" $TOOLS/deploynode/EdgeNode.xml
sed -i "s/THIRD_ADDR/$third/g" $TOOLS/deploynode/EdgeNode.xml
sed -i "s/FOURTH_ADDR/$fourth/g" $TOOLS/deploynode/EdgeNode.xml


# --------------------------------------


# Import XML
echo; echo "# Import XML"; echo
virsh define $TOOLS/deploynode/Controller.xml
virsh define $TOOLS/deploynode/EdgeNode.xml

# ----------------------------------------------------

echo; echo "Check Image - Controller"; echo

IMAGE=Controller.qcow2

if test -f /root/img/Controller.qcow2; then echo "Controller.qcow2 exist";else echo "NO" && exit; fi

# ----------------------------------------------------

echo; echo "Check Image - EdgeNode"; echo

IMAGE=EdgeNode.qcow2

if test -f /root/img/EdgeNode.qcow2; then echo "EdgeNode.qcow2 exist";else echo "NO" && exit; fi

# ----------------------------------

echo "192.168.122.111 Controller" >> /etc/hosts
echo "192.168.122.222 EdgeNode" >> /etc/hosts
