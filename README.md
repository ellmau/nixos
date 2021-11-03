# Nix-configuration

## Deploy on a new machine
* setup the filesystem as you see fit
* check out repository to `/mnt/etc/nixos`
* cd into `/mnt/etc/nixos`
* run 'nixos-generate-config --root /mnt' (Note: it won't overwrite the configuration.nix in the folder)
* create `machine/<machine-name>/default.nix`
* add machine specific configuration to `default.nix`
* move `hardware-configuration.nix` to `machine/<machine-name>/hardware-configuration.nix`
* run `nixos-install --no-root-passwd --flake .#hostname`
