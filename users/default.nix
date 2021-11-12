{ config, pkgs, lib,  ... }:
{
  #imports = [ <home-manager/nixos> ];
  imports = [
    ./ellmau
  ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
