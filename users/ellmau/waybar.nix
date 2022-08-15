{ config, pkgs, llib, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "sway/tray" ];
      };
    };
  };
}
