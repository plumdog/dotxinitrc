#!/bin/bash 

if [ ! -f "/home/andrew/background.jpg" ]
then
    wget http://p1.pichost.me/i/21/1443974.png -O "/home/andrew/background.jpg"
fi

feh --bg-scale /home/andrew/background.jpg

setxkbmap -layout gb -variant dvorak -option ctrl:nocaps

