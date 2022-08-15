{ config, pkgs, ...}:
{
  programs.mako = {
    enable = true;
    iconpath = "${pkgs.numix-icon-theme}";
    font = "Hasklug Nerd Font 10";
  };

  home.packages = [ pkgs.numic-icon-theme ];
}
