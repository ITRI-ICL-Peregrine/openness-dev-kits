#!/bin/bash

./check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

virsh start Controller
virsh start EdgeNode

# ------------------------

./pin-core-vm.sh

# -----------------------

#virsh net-dhcp-leases default
