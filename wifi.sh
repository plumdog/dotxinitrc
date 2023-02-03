#!/bin/bash

ATTEMPTS=0
MAX_ATTEMPTS=100
IP_ATTEMPTS=0
IP_MAX_ATTEMPTS=10
WIFI_NAME="$1"

msg() {
    >&2 echo "$1"
}

main() {
    iwctl station wlan0 disconnect

    sleep 1

    until [[ $ATTEMPTS -eq $MAX_ATTEMPTS ]] || iwctl station wlan0 connect "$WIFI_NAME"; do
        msg 'Failed, trying again'
        iwctl station wlan0 scan
        sleep 3
        ATTEMPTS=$(($ATTEMPTS+1))
    done

    if [[ $ATTEMPTS -lt $MAX_ATTEMPTS ]]; then
        msg 'Connected'
        sleep 1
        ip="$(curl --silent https://icanhazip.com)"
        until [[ $IP_ATTEMPTS -eq $IP_MAX_ATTEMPTS ]] || [[ -n $ip ]]; do
            msg 'IP check failed, trying again'
            ip="$(curl --silent https://icanhazip.com)"
            sleep 1
            IP_ATTEMPTS=$(($IP_ATTEMPTS+1))
        done

        if [[ $IP_ATTEMPTS -lt $IP_MAX_ATTEMPTS ]]; then
            msg "IP: $ip"
        else
            msg "Unable to determine IP, tried $IP_MAX_ATTEMPTS times"
        fi
    else
        msg "Unable to connect, tried $MAX_ATTEMPTS times"
        false
    fi
}

main
