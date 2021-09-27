{ pkgs, ... }:
{
  imports =
    [
      ./polybar.nix
      ./dunst.nix
      ./zsh.nix
    ];
  home.packages = [
    pkgs.htop
    pkgs.pavucontrol
  ];
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true ;
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" ];
  };

  programs.home-manager = {
    enable = true;
  };

}
