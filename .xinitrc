#!/bin/bash 

DISPLAY=":0.0"
HOME="/home/andrew"
XAUTHORITY="$HOME/.Xauthority"
export DISPLAY XAUTHORITY HOME

if [ ! -f "/home/andrew/background.png" ]
then
    wget 'https://raw.githubusercontent.com/hemanth/haskell-rascal/master/imgs/swahili.png' -O "/home/andrew/background.png"
fi

feh --bg-fill /home/andrew/background.png

setxkbmap -layout gb -variant dvorak -option ctrl:nocaps
