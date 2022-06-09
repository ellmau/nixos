{ config, pkgs, inputs, nixos-hardware, ...}:
{
  imports = [
    ../../common/users.nix
    ./printer.nix
    ./hardware-configuration.nix
    ./software.nix
    nixos-hardware.dell-xps-13-7390
  ];

  elss = {
    # base system
    base.enable = true;
    # setup locale and font settings
    locale.enable = true;
    # setup sshd
    sshd.enable = true;
    # configure zsh
    zsh.enable = true;
    # enable X11 with lightdm and i3
    graphical = {
      enable = true;
      # set dpi if used in mobile applications
#      dpi = 180;
    };

    # enable deamon to generate nix-index-db
    nix-index-db-update.enable = false;

    # add TUD vpn
    openvpn.enable = true;

    # enable sops
    sops = {
      enable = true;
    };
    
    # user setup
    users = {
      enable = true;
      admins = [ "ellmau" ];
      users = [ ];

      meta = {
        ellmau.git = {
          key = "0x4998BEEE";
          gpgsm = true;
          signDefault = true;
        };
      };
    };
  };

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  boot.kernelModules = [
      "v4l2loopback"
  ];

  services.xserver.desktopManager.wallpaper.mode = "fill";
}