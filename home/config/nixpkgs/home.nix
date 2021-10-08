{ pkgs, lib, ... }:
{
  imports =
    [
      ./polybar.nix
      ./dunst.nix
      ./zsh.nix
      ./nextcloud.nix
    ];
  home.packages = [
    pkgs.htop
    pkgs.pavucontrol
    
    pkgs.jitsi-meet-electron
    pkgs.skypeforlinux
    pkgs.zoom-us
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

  programs.home-manager = {
    enable = true;
  };

}
