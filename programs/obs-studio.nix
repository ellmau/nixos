{ config, pkgs, lib, ...}:
{
  environment.systemPackages = if config.variables.graphical then with pkgs; [
    obs-studio
  ] else [ ] ;
}
