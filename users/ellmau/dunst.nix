{ config, pkgs, lib, nixosConfig, ... }:
with lib; {
  config = let cfg = nixosConfig.elss.users.dunst;
  in mkIf cfg.enable {
    services.dunst = {
      iconTheme = {
        package = pkgs.numix-icon-theme;
        name = "Numix";
        size = "26";
      };
      settings = {
        global = {
          geometry = "800x5-30+50";
          transparency = 10;
          frame_color = "#839496";
          font = "Hasklug Nerd Font 11";
          timeout = 5;
          follow = "mouse";
          markup = "full";
          icon_position = "left";
          history_length = 32;
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
          word_wrap = true;
        };
        urgency_critical = {
          foreground = "#fdf6e3";
          background = "#dc322f";
        };
        urgency_normal = {
          foreground = "#fdf6e3";
          background = "#859900";
        };
        urgency_low = {
          foreground = "#fdf6e3";
          background = "#2aa198";
        };
      };
    };
  };
}
