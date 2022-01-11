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

    boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  boot.kernelModules = [
      "v4l2loopback"
  ];

  services.autorandr.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
}
