{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.variables.graphical {
    home-manager.users.ellmau.programs.alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "none";
        };
        alt_send_esc = true;
      };
    };
  };
}
