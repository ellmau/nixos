{ config, pkgs, ...}:
{
  imports = [ ./printer.nix ];

  variables = {
    hostName = "stel-xps";
    graphical = true;
  };
  #networking.hostName = "stel-xps"; # define the hostname

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.autorandr.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
}
