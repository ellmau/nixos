#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh


cp configuration.nix /etc/nixos/.
cp -r programs /etc/nixos/.
mkdir -p /etc/nixos/machine
for machine in `exa --all -l machine | grep "^d" | cut -d" " -f8`; do
    cp -r machine/$machine /etc/nixos/machine/.
done

cp -r ./home/config/* /home/ellmau/.config/.
