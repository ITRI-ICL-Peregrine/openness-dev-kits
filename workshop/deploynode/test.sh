#!/bin/bash

bus_id=$( ethtool -i $NIC2 |grep bus |cut -d" " -f2 )

first=$( echo $bus_id |cut -d":" -f1 )
second=$( echo $bus_id |cut -d":" -f2 )
third=$( echo $bus_id |cut -d":" -f3 |cut -d"." -f1 )
fourth=$( echo $bus_id |cut -d":" -f3 |cut -d"." -f2 )

echo $first $second $third $fourth


