
{ config, pkgs, ...}:
{
  programs.mako = {
    enable = true;
    iconPath = "${pkgs.numix-icon-theme}";
    font = "Hasklug Nerd Font 10";
    defaultTimeout = 50003;
  };

  home.packages = [ pkgs.numix-icon-theme ];
}
