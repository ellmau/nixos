{ config, pkgs, lib, ... }:
{
  imports = [
    ./aspell.nix
    ./emacs
    ./obs-studio.nix
  ];
}
