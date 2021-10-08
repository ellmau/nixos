# Nix-configuration

## Installing on a system:

* create a new folder in machine for the system configuration
* create a symlink in the machine folder to the actual machine, called current
  > e.g. $/etc/nixos/machine/> ln -s nucturne/ current

## Steps to fully finish home-setup:

* add home-manager channel to private channel-list (nix-channel add https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz home-manager)
* generate home-instance
* add unlock-secret to secret-store (secret-tool store --label='keepassxc' keepass unlock)
* add certs and keyfiles
