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
  * `sudo ssh-to-pgp -i /etc/ssh/ssh_host_rsa_key > /etc/nixos/secrets/hosts/<hostname>.asc`
* add the fingerprint of the new key to the `/etc/nixos/.sops.yaml` file
* Rekey the secrets with either 
	* a master key
	* or after a git push on another machine with enough permissions to rekey
* the flakes dev-shell (`nix devshell`) allows to use the `sops <sops-file>` as well `sops-rekey <sops-file>` to manage the keys on the system
   
	

# redesign checklist
- [x] lorri or similar (nix-direnv)
- [x] whole home manager stuff
- [x] baseconfiguration handled
- [x] programs handled
- [X] locale/fonts
- [X] zsh
- [x] gnupg agent
- [x] integrate steam-run module
- [x] integrate texlive module

