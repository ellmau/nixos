{ config, pkgs, lib, ...}:
{

  imports = [
    ./autorandr.nix
    ./dunst.nix
    ./git.nix
    ./gpg.nix
    ./i3.nix
    ./nextcloud.nix
    ./polybar.nix
    ./zsh.nix
  ];

  home-manager.users.ellmau = {
    home.packages = [
      pkgs.htop
      pkgs.pavucontrol

      pkgs.ripgrep

      pkgs.jabref
      pkgs.libreoffice-fresh

      pkgs.nixfmt
      pkgs.nixpkgs-fmt
      pkgs.nix-prefetch-github

      pkgs.neofetch
      
      pkgs.jitsi-meet-electron
      pkgs.skypeforlinux
      pkgs.zoom-us
      pkgs.element-desktop
      pkgs.signal-desktop
    ];

    services = {
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
      };
      blueman-applet.enable = config.variables.graphical;
      network-manager-applet.enable = config.variables.graphical ;
      gnome-keyring = {
        enable = true;
        components = [ "pkcs11" "secrets" "ssh" ];
      };
    };

    xdg = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    xsession = {
      numlock.enable = true;
      profileExtra = ''
        if [ $(hostname) = 'stel-xps' ]; then
          brightnessctl s 50%
        fi
      '';
    };

    home.file.".background-image".source = ../common/wallpaper/nix-wallpaper-nineish-dark-gray.png;
    
    programs.home-manager = {
      enable = true;
    };

  };
}