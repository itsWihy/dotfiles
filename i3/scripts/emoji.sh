#!/usr/bin/env bash

cat ~/.config/i3/scripts/emoji.txt |rofi -dmenu -i -p "Which emoji? ⭐ " -theme /$HOME/.config/rofi/minimal.rasi -font "twemoji 16" | awk '{print $1}' | tr -d '\n' | xclip -selection cli
