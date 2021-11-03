{ config, pkgs, lib,  ... }:
{
  #imports = [ <home-manager/nixos> ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.ellmau = (import ./ellmau/home.nix);
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "zoom"
    "skypeforlinux"
  ];
}
