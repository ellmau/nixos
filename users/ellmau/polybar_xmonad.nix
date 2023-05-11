{ config, pkgs, lib, nixosConfig, ... }:
with lib; {
  config = let cfg = nixosConfig.elss.graphical.xmonad.polybar;
  in mkIf cfg.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybarFull;
      settings = let
        fonts = [
          "Weather Icons:size=12;0"
          "Hasklug Nerd Font,Hasklig Medium:style=Medium,Regular"
          "all-the-icons:style=Regular"
          "Webdings:style=Regular"
          "Noto Emoji:scale=10"
          "Unifont:style=Regular"
          "Material Icons:size=12;0"
        ];
      in {
        "bar/main" = {
          font = fonts;
          modules = {
            left = "xmonad";
            center = "";
            # right = "xbacklight xkeyboard eth wlan battery date powermenu dunst volume ";
            right = "";
          };
          tray = {
            position = "right";
            padding = 2;
          };

          background = "FFFFFF";
          foreground = "000000";

          monitor = ''
            ''${env:MONITOR:}
          '';
        };

        "bar/aux" = {
          font = fonts;
          modules = {
            left = "xmonad";
            center = "";
            right =
              " xbacklight xkeyboard eth wlan battery date powermenu volume ";
          };
          monitor = ''
            ''${env:MONITOR:}
          '';
        };

        "module/xmonad" = {
          type = "custom/script";
          exec = "${pkgs.xmonad-log}/bin/xmonad-log";
          tail = true;
        };
      };
      script = ''
        for m in $(polybar --list-monitors | ${pkgs.gnugrep}/bin/grep '(primary)' | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload main &
        done;
        for m in $(polybar --list-monitors | ${pkgs.gnugrep}/bin/grep -v '(primary)' | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload aux &
        done;
      '';
    };

    systemd.user.services.polybar = {
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
