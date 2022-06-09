{ config, pkgs, inputs, nixos-hardware, ...}:
{
  imports = [
    ../../common/users.nix
    ./hardware-configuration.nix
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
      enable = false;
      # set dpi if used in mobile applications
#      dpi = 180;
    };

    # enable deamon to generate nix-index-db
    nix-index-db-update.enable = false;

    # add TUD vpn
    openvpn.enable = false;

    # enable sops
    sops = {
      enable = true;
    };

    # enable server services
    server = {
      enable = true;
      nextcloud.enable = true;
    };
    
    
    # user setup
    users = {
      enable = true;
      admins = [ "ellmau" ];
      users = [ ];

      meta = {
        ellmau.git = {
          signDefault = true;
        };
      };
    };
  };
}
