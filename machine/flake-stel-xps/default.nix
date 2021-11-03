{ config, pkgs, ...}:
{

  imports = [ ./hardware-configuration.nix ];
  
  networking.hostName = "stel-xps"; # define the hostname

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.autorandr.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
}
