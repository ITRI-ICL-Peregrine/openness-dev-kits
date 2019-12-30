#!/bin/bash

#./check-hostname.sh
$TOOLS/deploynode/check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

cp /etc/default/grub /etc/default/grub.org

mv /etc/default/grub.d/50-curtin-settings.cfg \
/etc/default/grub.d/50-curtin-settings.cfg.org



cat > /etc/default/grub << 'EOL'
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap"

# Isolate CPU Core
controller_cores=1-4
edgenode_cores=5-12
cores=$controller_cores,$edgenode_cores
GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX isolcpus=$cores"

# Timer
GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nohz=on nohz_full=$cores rcu_nocbs=$cores"

# Other
GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nosoftlockup noirqbalance"

# Disable C-state
GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX intel_idle.max_cstate=0 processor.max_cstate=0"

# IOMMU
GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX intel_iommu=on iommu=pt"

GRUB_SAVEDEFAULT="false"
EOL

# --------------------------------------

# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg

# --------------------------------------

echo; echo ">>> Plz REBOOT SERVER <<<"; echo
