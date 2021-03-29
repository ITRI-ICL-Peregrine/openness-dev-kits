#!/bin/bash

./check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

core_default="0"

# Controller
core_pin_vm_01="1"
core_pin_vm_02="2"
core_pin_vm_03="3"
core_pin_vm_04="4"

# EdgeNode
core_pin_vm_05="5"
core_pin_vm_06="6"
core_pin_vm_07="7"
core_pin_vm_08="8"
core_pin_vm_09="9"
core_pin_vm_10="10"
core_pin_vm_11="11"
core_pin_vm_12="12"


VM1_NAME="Controller2"
VM2_NAME="EdgeNode2"


all_pids=`pgrep -w ovs\|qemu`
vm1_pids_arr=($(virsh qemu-monitor-command --hmp $VM1_NAME "info cpus " | grep CPU | tr -d '\r' | cut -d'=' -f2))
vm2_pids_arr=($(virsh qemu-monitor-command --hmp $VM2_NAME "info cpus " | grep CPU | tr -d '\r' | cut -d'=' -f2))


# QEMU Thread
taskset -cpa $core_default ${vm1_pids_arr[0]};
taskset -cpa $core_default ${vm2_pids_arr[0]};

# Controller VCPU core pinning
taskset -cp $core_pin_vm_01 ${vm1_pids_arr[0]};
taskset -cp $core_pin_vm_02 ${vm1_pids_arr[1]};
taskset -cp $core_pin_vm_03 ${vm1_pids_arr[2]};
taskset -cp $core_pin_vm_04 ${vm1_pids_arr[3]};


# EdgeNode VCPU core pinning
taskset -cp $core_pin_vm_05 ${vm2_pids_arr[0]};
taskset -cp $core_pin_vm_06 ${vm2_pids_arr[1]};
taskset -cp $core_pin_vm_07 ${vm2_pids_arr[2]};
taskset -cp $core_pin_vm_08 ${vm2_pids_arr[3]};
taskset -cp $core_pin_vm_09 ${vm2_pids_arr[4]};
taskset -cp $core_pin_vm_10 ${vm2_pids_arr[5]};
taskset -cp $core_pin_vm_11 ${vm2_pids_arr[6]};
taskset -cp $core_pin_vm_12 ${vm2_pids_arr[7]};



