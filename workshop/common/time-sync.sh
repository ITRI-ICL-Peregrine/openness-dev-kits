#!/bin/bash

## Restart chrony service
systemctl restart chronyd

## Verify Time Synchronization

while : ;do
	if [ "$( chronyc tracking |grep Leap |cut -d":" -f2 )" != " Normal" ]; then 
		echo "Synchronizing...";
		sleep 3; 
	else
		break
	fi
done
chronyc tracking

# ------------------------------------------------------


