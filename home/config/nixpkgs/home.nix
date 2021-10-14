{ pkgs, lib, ... }:
{
  imports =
    [
      ./polybar.nix
      ./dunst.nix
      ./zsh.nix
      ./nextcloud.nix
      ./autorandr.nix
      ./git.nix
      ./gpg.nix
    ];
  home.packages = [
    pkgs.htop
    pkgs.pavucontrol

    pkgs.jabref
    pkgs.libreoffice-fresh
    
    
    pkgs.jitsi-meet-electron
    pkgs.skypeforlinux
    pkgs.zoom-us
    pkgs.element-desktop
    pkgs.signal-desktop
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "zoom"
    "skypeforlinux"
  ];

  services = {
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
    blueman-applet.enable = true;
    network-manager-applet.enable = true ;
    gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
  };

  xdg = {
    enable = true;
  };

  xsession = {
    numlock.enable = true;
    profileExtra = ''
      if [ $(hostname) = 'stel-xps' ]; then
        brightnessctl s 50%
      fi
    '';
  };

  home.file.".background-image".source = ./common/wallpaper/nix-wallpaper-nineish-dark-gray.png;
  
  programs.home-manager = {
    enable = true;
  };

}
