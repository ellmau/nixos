#!/usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh

sleep 5
secret-tool lookup keepass unlock | keepassxc --pw-stdin ~/.keepasswd/passwd-store.kdbx
