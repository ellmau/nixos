{ config, pkgs, inputs, nixos-hardware, ... }:
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
      smailserver.enable = false;
      acme.staging = false;
    };

    # enable wireguard
    wireguard.enable = true;


    # user setup
    users = {
      enable = true;
      admins = [ "ellmau" ];
      users = [ ];

      meta = {
        ellmau.git = {
          signDefault = false;
        };
      };
    };
  };
  fileSystems."/".options = [ "noatime" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    interfaces.ens3 = {
      ipv4.addresses = [{
        address = "89.58.45.113";
        prefixLength = 22;
      }];
      ipv6.addresses = [{
        address = "fe80::94e0:6eff:fecd:d6cb";
        prefixLength = 64;
      }];
    };
    defaultGateway = "89.58.44.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg-stelnet" ];
    };

  };
  system.stateVersion = "22.05";
}
