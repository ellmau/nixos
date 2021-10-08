{ config, pkgs, ...}:
{
  networking.hostName = "stel-xps"; # define the hostname

  services.autorandr.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
}
