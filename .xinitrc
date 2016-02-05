#!/bin/bash 

DISPLAY=":0.0"
HOME="/home/andrew"
XAUTHORITY="$HOME/.Xauthority"
export DISPLAY XAUTHORITY HOME

if [ ! -f "/home/andrew/background.png" ]
then
    wget http://p1.pichost.me/i/21/1443974.png -O "/home/andrew/background.png"
fi

feh --bg-fill /home/andrew/background.png

setxkbmap -layout gb -variant dvorak -option ctrl:nocaps -display
