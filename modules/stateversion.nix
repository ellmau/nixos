{ config, lib, pkgs, ...}:
with lib;{
  system.stateVersion = mkDefault "21.05";
}
