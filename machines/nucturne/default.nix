{
  config,
  pkgs,
  inputs,
  nixos-hardware,
  ...
}: {
  imports = [../../common/users.nix ./hardware-configuration.nix ./software.nix];

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
      sway.enable = true;
      i3.enable = false;
      plasma.enable = false;
      # set dpi if used in mobile applications
      #      dpi = 180;
    };

    # enable deamon to generate nix-index-db
    nix-index-db-update.enable = true;

    # add TUD vpn
    openvpn.enable = true;

    # nm-networks
    networking.nmConnections = [];

    # enable sops
    sops = {enable = true;};

    # enable wireguard
    wireguard.enable = true;

    # user setup
    users = {
      enable = true;
      admins = ["ellmau"];
      users = [];

      meta = {ellmau.git = {signDefault = true;};};
    };
  };

  boot = {
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];

    kernelModules = ["v4l2loopback"];

    plymouth.enable = true;
  };

  system.stateVersion = "21.05";
}
