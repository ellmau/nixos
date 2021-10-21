# Nix-configuration

## Installing on a system:

* setup the filesystem as you see fit
* run `nixos-generate-config --root /mnt`
* create a new folder in machine for the system configuration
* create a symlink in the machine folder to the actual machine, called current
  > e.g. $/etc/nixos/machine/> ln -s nucturne/ current
* add home-manager channel to the channel list (nix-channel add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manage)
* install the system (nixos-install --no-root-passwd)

## Steps to fully finish home-setup:

* add unlock-secret to secret-store (secret-tool store --label='keepassxc' keepass unlock)
* add certs and keyfiles

## Hardware specifics
	https://github.com/NixOS/nixos-hardware
