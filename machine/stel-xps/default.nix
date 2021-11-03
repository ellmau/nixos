{ config, pkgs, ...}:
{
  imports = [ ./printer.nix ];
  
  networking.hostName = "stel-xps"; # define the hostname

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.autorandr.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
}
