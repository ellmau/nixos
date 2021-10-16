#! /usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh


cp configuration.nix /etc/nixos/.
cp -r programs /etc/nixos/.
mkdir -p /etc/nixos/machine
cp -r machine/stel-xps /etc/nixos/machine/.
cp -r machine/nucturne /etc/nixos/machine/.

cp -r ./home/config/* /home/ellmau/.config/.
chown -R ellmau:users /home/ellmau/.config/.
