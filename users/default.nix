{ config, pkgs, lib,  ... }:
{
  #imports = [ <home-manager/nixos> ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.ellmau = (import ./ellmau/home.nix);
  };
}
