#!/bin/bash

resetPref() {
    SCRIPT_LOCATION=$(dirname $(readlink -f "$0"))
    echo "0" > $SCRIPT_LOCATION/utils/battery
}

magicFunction() {
    BATTERY_LOCATION="/sys/class/power_supply/BAT0"

    STATUS=$(cat $BATTERY_LOCATION/status)
    CAPACITY=$(cat $BATTERY_LOCATION/capacity)

    CHARGING=0

    if [ $STATUS = "Charging" ]
    then
    CHARGING=1;
    resetPref
    fi

    MESSAGE_RECEIVED=$(cat $SCRIPT_LOCATION/utils/battery)

    if [[ $CHARGING -eq 0 && $CAPACITY -lt 5 ]]
    then
    notify-send "Battery critically low" "You have just $CAPACITY% battery remaining. Plug in ASAP!"
    espeak "Battery critically low!"
    elif [[ $CHARGING -eq 0 && $CAPACITY -lt 20 && MESSAGE_RECEIVED -eq 0 ]]
    then
    notify-send "Battery low" "You have $CAPACITY% battery remaining, might want to plug in!"
    espeak "Battery low!"
    fi
}

resetPref

while [ true ]
do
    magicFunction
    sleep 10
done