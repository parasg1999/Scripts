#!/bin/bash

SCRIPT_LOCATION=$(dirname $(readlink -f "$0"))
TYPE="battery"
if [ -z $1 ]
then
echo "Using default argument battery"
else
TYPE=$1
fi

if [[ $TYPE == "battery" || $TYPE == "power" ]]
then
echo 1 > $SCRIPT_LOCATION/battery
fi