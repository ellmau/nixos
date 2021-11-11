# Nix-configuration

## Deploy on a new machine
* setup the filesystem as you see fit
* check out repository to `/mnt/etc/nixos`
* run `nixos-generate-config --root /mnt` in `/mnt/etc/nixos`
* create `machine/<machine-name>/default.nix` and add machine specific configuration to it
* move `hardware-configuration.nix` to `machine/<machine-name>/hardware-configuration.nix`
* add your machine to `/mnt/etc/nixos/default.nix`
* stage the machine-folder to the git-repository
* run
  * `nix-shell -p nixFlakes'
  * 'sudo _NIXOS_REBUILD_REEXEC=1 nixos-install --no-root-passwd --flake .#hostname'
  * ~~`nixos-install --no-root-passwd --flake .#hostname`~~
