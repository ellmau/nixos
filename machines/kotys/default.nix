{
  config,
  pkgs,
  inputs,
  nixos-hardware,
  ...
}: {
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
      enable = false;
    };

    # enable server services
    server = {
      enable = false;
      acme.staging = false;
    };

    # enable wireguard
    wireguard.enable = false;

    # enable podman
    container.podman.enable = true;

    # user setup
    users = {
      enable = true;
      admins = ["ellmau"];
      users = [];

      meta = {
        ellmau.git = {
          signDefault = false;
        };
      };
    };
  };
  fileSystems."/".options = ["noatime"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # qemu agent
  services.qemuGuest.enable = true;

  networking = {
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          address = "213.109.163.8";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a03:4000:35:11::";
          prefixLength = 64;
        }
      ];
    };
    enableIPv6 = false;
    defaultGateway = "213.109.160.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = ["8.8.8.8"];
    # port for a podman container
    firewall.allowedTCPPorts = [8888];
  };
  system.stateVersion = "23.11";
}
