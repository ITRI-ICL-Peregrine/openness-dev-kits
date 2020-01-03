#!/bin/bash

$TOOLS/deploynode/check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

virsh start Controller
virsh start EdgeNode

# ------------------------

$TOOLS/deploynode/pin-core-vm.sh

# -----------------------

progress-bar() {
  local duration=${1}


    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "| %s%% Starting..." $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 1
      clean_line
  done
  clean_line
}

echo;echo "-------------------- Waiting for Starting Controller and EdgeNode ---------------------"
progress-bar 60
echo

