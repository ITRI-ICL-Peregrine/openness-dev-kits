#!/bin/bash

ENV=OpenNESS

if [ "$( hostname )" != "openness" ]; then echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo; exit; fi

# --------------------------------------

virsh start Controller
virsh start EdgeNode

# ------------------------

$TOOLS/deploynode/pin-core-vm.sh

# -----------------------

virsh net-dhcp-leases default
