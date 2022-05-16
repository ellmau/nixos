#!/bin/sh

if [[ `setxkbmap -query | awk '$1 == "layout:"{print($2)}'` = "us" ]]; then
    setxkbmap -layout de
else
    setxkbmap -layout us
fi
