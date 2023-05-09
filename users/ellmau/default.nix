{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./autorandr.nix
    ./dunst.nix
    ./git.nix
    ./gpg.nix
    ./i3.nix
    ./kanshi.nix
    ./mako.nix
    ./nextcloud.nix
    ./polybar_i3.nix
    ./polybar_xmonad.nix
    ./zsh.nix

    ./sway.nix
    ./waybar.nix

    ./graphical.nix
  ];
  services = {
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };

  xdg = {
    enable = true;
  };

  home.packages = with pkgs; [
    # comma did not compile on 15.07.2022
    comma
    kanshi
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    home-manager = {
      enable = true;
    };

    ssh = {
      enable = true;

      forwardAgent = true;
      serverAliveInterval = 5;
      hashKnownHosts = true;
      controlMaster = "auto";
      controlPersist = "60s";
    };

    go.enable = true;
  };
}
