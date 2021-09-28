{ pkgs, ... }:
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
      components = [ "pkcs11" "secrets" ];
    };
  };

  programs.home-manager = {
    enable = true;
  };

}
