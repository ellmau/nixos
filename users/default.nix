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

  users = {
    mutableUsers = false;
    users = {
      ellmau = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio"];
        description = "Stefan Ellmauthaler";
        shell = pkgs.zsh;
        home = "/home/ellmau";
        hashedPassword = "$6$JZPnaZYG$KL2c3e1it3j2avioovE1WveN/mpmq/tPsSAvHY1XRhtqKaE7TaSQkqRy69farkIR0Xs0.yTjltvKvv28kZtLO1";
      };
    };
  };
}
