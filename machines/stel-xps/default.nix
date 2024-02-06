{
  config,
  pkgs,
  inputs,
  nixos-hardware,
  ...
}: {
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
      sway.enable = false;
      i3.enable = false;
      plasma.enable = false;
      xmonad.enable = true;
      # set dpi if used in mobile applications
      dpi = 192;
    };

    # enable deamon to generate nix-index-db
    nix-index-db-update.enable = true;

    # add TUD vpn
    openvpn.enable = true;

    # nm-networks
    networking.nmConnections = ["tartaros" "eduroam"];

    # enable sops
    sops = {enable = true;};

    # enable wireguard
    wireguard.enable = true;

    # vscodium
    vscodium.enable = true;

    # user setup
    users = {
      enable = true;
      admins = ["ellmau"];
      users = [];

      meta = {
        ellmau = {
          git = {
            key = "0x3031AB33";
            gpgsm = true;
            signDefault = true;
          };
          extraGroups = ["networkmanager"];
        };
      };
    };
  };

  # glpi-inventory
  glpi-inventory = {
    enable = true;
    tag = "10002205";
    onCalendar = "*-*-* 12:12:12";
    noCategories = [
      "accesslog"
      "environment"
      "process"
      "local_group"
      "local_user"
      "user"
      "printer"
      "usb"
      "storage"
      "drive"
      "network"
    ];
  };

  boot = {
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];

    kernelModules = ["v4l2loopback"];

    plymouth.enable = true;
  };
  services.xserver.desktopManager.wallpaper.mode = "fill";

  system.stateVersion = "21.05";
}
