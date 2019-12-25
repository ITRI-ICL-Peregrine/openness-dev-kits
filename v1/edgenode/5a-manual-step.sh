#!/bin/bash

ENV=EdgeNode

if [ "$( hostname )" != "edgenode" ]; then echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo; exit; fi

# --------------------------------------

CONSUMER_ID=$(docker ps |grep start.sh |cut -d' ' -f1)
echo $CONSUMER_ID

INTERFACE=$(docker exec -ti $CONSUMER_ID ip a |grep vEth |cut -d":" -f2) && \
echo $INTERFACE

docker exec -it $CONSUMER_ID ip link set dev $INTERFACE arp off && \ 
docker exec -it $CONSUMER_ID ip a a 192.168.200.20/24 dev $INTERFACE && \
docker exec -it $CONSUMER_ID  ip link set dev $INTERFACE up

docker exec -it $CONSUMER_ID  wget 192.168.200.123 -Y off
