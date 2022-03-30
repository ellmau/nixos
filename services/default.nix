{ config, pkgs, lib, ...}:
{
  imports = [
    ./nginx.nix
    ./smailserver.nix
    ./mariadb.nix
    ./nextcloud.nix
  ];
}
