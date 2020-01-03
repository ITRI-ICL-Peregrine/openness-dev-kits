#!/bin/bash


ENV=OpenNESS

hostname=$( hostname -f )

if [ "${hostname,,}" != "${ENV,,}" ]; then 
	echo; echo ">>> Plz Execute this Script on $ENV <<<"; echo;
	exit 1;
fi

