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
            right = "xkeyboard dunst battery date volume";
          };
          tray = {
            position = "right";
            padding = 3;
          };

          # background = "FFFFFF";
          # foreground = "000000";

          module-margin = 2;

          monitor = ''
            ''${env:MONITOR:}
          '';
        };

        "bar/aux" = {
          font = fonts;
          modules = {
            left = "xmonad";
            center = "";
            right = "";
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

        "module/dunst" = {
          type = "custom/script";
          exec =
            "PATH=${pkgs.dbus}/bin/:$PATH ${pkgs.dunst}/bin/dunstctl is-paused | ${pkgs.gnugrep}/bin/grep -q true && echo   || echo  ";
          interval = 10;
          click-left =
            "PATH=${pkgs.dbus}/bin/:$PATH ${pkgs.dunst}/bin/dunstctl set-paused toggle";
        };

        "module/volume" = {
          type = "internal/pulseaudio";
          format.volume = "<ramp-volume> <label-volume>";
          label.muted.text = "🔇";
          label.muted.foreground = "#666";
          ramp.volume = [ "🔈" "🔉" "🔊" ];
          click.right = "${pkgs.pavucontrol}/bin/pavucontrol &";
          # format-volume-underline = Base2;
          # format-muted-underline = Base2;
        };

        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";
          interval = "5";
          format-prefix = ''""'';
          label-layout = "%layout%";
          label-indicator-padding = "2";
          label-indicator-margin = "1";
        };

        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "ADP1";
          full-at = "98";
          format-charging-prefix = ''"   "'';
          format-charging = "<label-charging>";
          format-discharging-prefix = ''"   "'';
          format-discharging = "<label-discharging>";
          format-full-prefix = ''"   "'';
          format-full-padding = "1";
          format-charging-padding = "1";
          format-discharging-padding = "1";
        };

        "module/date" = {
          type = "internal/date";
          interval = "5";

          date = ''" %Y-%m-%d"'';
          date-alt = ''" %Y-%m-%d"'';

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          label = "%{A} %date% %time%";
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
