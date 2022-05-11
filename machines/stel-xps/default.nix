{ config, pkgs, ...}:
{
  imports = [
    ../../common/users.nix
    ./printer.nix
    ./hardware-configuration.nix
    ./software.nix
  ];

  elss = {
    # base system
    base.enable = true;
    # setup locale and font settings
    locale.enable = true;
    # configure zsh
    zsh.enable = true;
    
    # user setup
    users = {
      enable = true;
      admins = [ "ellmau" ];
      users = [ ];
    };
  };

  variables = {
    hostName = "stel-xps";
    graphical = true;
    git = {
      key = "0x4998BEEE";
      gpgsm = true;
      signDefault = true;
    };
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
