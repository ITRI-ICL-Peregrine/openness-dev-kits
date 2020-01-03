#!/bin/bash

$TOOLS/deploynode/check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi


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
