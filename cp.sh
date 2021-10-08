#!/usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh

cp /etc/nixos/configuration.nix .
cp -r /etc/nixos/machine .
cp -r /etc/nixos/programs .
cp -r $HOME/.config/i3 ./home/config/.
cp -r $HOME/.config/nixpkgs ./home/config/.
mkdir -p ./home/config/Nextcloud
cp -r $HOME/.config/Nextcloud/nextcloud.cfg ./home/config/Nextcloud/.
