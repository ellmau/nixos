# Nix-configuration

## Deploy on a new machine
* setup the filesystem as you see fit
* check out repository to `/mnt/etc/nixos`
* run `nixos-generate-config --root /mnt` in `/mnt/etc/nixos`
* create `machines/<machine-name>/default.nix` and configure the machine
* move `hardware-configuration.nix` to `machines/<machine-name>/hardware-configuration.nix`
* stage the machine-folder
* run
 * `nix-install --no-root-passwd --flake .#hostname --option experimental-features "nix-command flakes"`

## nix-sops
* generate on your (sshd-enabled) machine a pgp key:
  * `nix shell nixpkgs#ssh-to-pgp`
  * `sudo ssh-to-pgp -i /etc/ssh/ssh_host_rsa_key > /etc/nixos/secrets/keys/hosts/<hostname>.asc`
* add the fingerprint of the new key to the `/etc/nixos/.sops.yaml` file
* Rekey the secrets with either 
	* a master key
	* or after a git push on another machine with enough permissions to rekey
* the flakes dev-shell (`nix develop`) allows to use `sops <sops-file>` as well as `sops-rekey <sops-file>` to manage the keys on the system
