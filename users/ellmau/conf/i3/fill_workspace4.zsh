#!/usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh

i3-msg 'workspace 4: comms; append_layout /home/ellmau/.config/i3/workspace4.json'
i3-msg 'exec thunderbird'
i3-msg 'exec signal-desktop'
i3-msg 'exec element-desktop'
