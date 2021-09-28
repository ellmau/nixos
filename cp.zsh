#! /bin/sh

cp /etc/nixos/configuration.nix .
cp /etc/nixos/hardware-configuration.nix .
cp -r /etc/nixos/programs .
cp -r $HOME/.config/i3 ./home/config/.
cp -r $HOME/.config/nixpkgs ./home/config/.
cp -r $HOME/.config/Nextcloud ./home/config/.
