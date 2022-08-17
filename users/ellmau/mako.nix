
{ config, pkgs, ...}:
{
  programs.mako = {
    enable = true;
    iconPath = "${pkgs.numix-icon-theme}";
    font = "Hasklug Nerd Font 10";
    defaultTimeout = 8000;
   # ignoreTimeout = true;
    
  };

  home.packages = [ pkgs.numix-icon-theme ];
}
