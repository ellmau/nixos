#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh


cp configuration.nix /etc/nixos/.
cp -r programs /etc/nixos/.
mkdir -p /etc/nixos/machine
for machine in `ls -al machine | grep "^d" | rev | cut -d" " -f1 | rev`; do
    cp -r machine/$machine /etc/nixos/machine/.
done

cp -r ./home/config/* /home/ellmau/.config/.
