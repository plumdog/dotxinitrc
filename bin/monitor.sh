#!/bin/bash

monitors=(
    "eDP1"
    # "DP1:scale=2x2"
    "DP1"
    "DP2"
    #"DP1:scale=1x1"
    #"DP1:scale=0.5x0.5"
)

previous_active=""

cmd=""

function parse_monitor_conf() {
    IFS=':' read -r -a _parts <<< "$1"


    for var_and_val in $( set -o posix ; set ); do
        var="$(echo $var_and_val | sed 's/=.*//')"
        if [[ $var = monitor* ]]; then
            echo "unset $var"
            unset "$var"
        fi
    done

    for _p in "${_parts[@]}"; do
        echo "part $_p"
    done
    
    monitor_name="${_parts[0]}"

    echo "${#_parts[@]}"

    if [[ ${#_parts[@]} -eq 1 ]]; then
        return
    fi

    _remaining="${_parts[@]:1}"
    for _opt in "${_remaining[@]}"; do
        _var="$(echo $_opt | sed 's/=.*//')"
        _val="$(echo $_opt | sed 's/[^=]*=//')"
        eval "monitor_$_var=$_val"
    done
}

for mconf in "${monitors[@]}"; do

    echo "mconf $mconf"

    parse_monitor_conf "$mconf"

    echo 'monitor_name' $monitor_name
    echo 'monitor_scale' $monitor_scale

    if [[ -z $monitor_scale ]]; then
        monitor_scale="1x1"
    fi

    monitor_spec="$(xrandr | grep '^'"$monitor_name")"
    echo $monitor_spec

    if [[ $monitor_name == "DP1" ]]; then
        monitor_scale="2x2"
    fi

    if [[ $monitor_name == "DP2" ]]; then
        monitor_scale="2x2"
    fi

    if xrandr | grep "^$monitor_name disconnected"; then
        # Inactive
        cmd="$cmd --output $monitor_name --off"
    else
        # Active

        extra=""
        if [[ -n $monitor_scale ]]; then
            extra=" --scale $monitor_scale"
        fi

        if [[ -n $previous_active ]]; then
            cmd="$cmd --output $monitor_name --right-of $previous_active --auto $extra"
        else
            cmd="$cmd --output $monitor_name --primary --auto $extra"
        fi
        previous_active="$monitor_name"
    fi
done

echo xrandr $cmd

eval xrandr $cmd
