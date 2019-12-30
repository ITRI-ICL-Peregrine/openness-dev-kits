#!/bin/bash

/root/openness-dev-kits/v2/controller/check-hostname.sh

status=$( echo $? )
if [ "$status" == "1" ]; then
        exit;
fi

# --------------------------------------

CONTROLLER_PATH=/opt/edgecontroller

sed -i 's/[[:space:]]image:.*/&\n    restart: always/g' $CONTROLLER_PATH/docker-compose.yml

cd $CONTROLLER_PATH && \
make all-up


