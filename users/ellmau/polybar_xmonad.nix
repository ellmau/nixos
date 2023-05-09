{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical.xmonad;
  in
    mkIf cfg.polybar.enable {
      services.polybar = {
        enable = true;
        packages = pkgs.polybarFull;
        settings = let
          fonts = [
            "Hasklig:style=Regular"
            "all-the-icons:style=Regular"
            "Webdings:style=Regular"
            "Noto Emoji:scale=10"
            "Unifont:style=Regular"
            "Material Icons:size=12;0"
            "Weather Icons:size=12;0"
            "Hasklug Nerd Font,Hasklig Medium:style=Medium,Regular"
          ];
        in {
          "bar/main" = {
            font = fonts;
            modules = {
              left = "xmonad";
              center = "";
              right = "xbacklight xkeyboard eth wlan battery date powermenu dunst volume ";
            };
            tray = {
              position = "right";
              padding = 2;
            };

            monitor = ''
              ''${env:MONITOR:}
            '';
          };

          "bar/aux" = {
            font = fonts;
            modules = {
              left = "xmonad";
              center = "";
              right = " xbacklight xkeyboard eth wlan battery date powermenu volume ";
            };
            monitor = ''
              ''${env:MONITOR:}
            '';
          };

          "module/xmonad" = {
            type = "custom/script";
            exec = "${pkgs.xmonad-log} /bin/xmonad-log";
            tail = true;
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
          "module/wlan" = {
            type = "internal/network";
            interface = "wlp0s20f3";
            interval = "3.0";

            format-connected = " <ramp-signal> <label-connected>";
            format-connected-underline = "#9f78e1";
            label-connected = "%essid%";

            ramp-signal-0 = ''"0.0"'';
            ramp-signal-1 = ''"0.5"'';
            ramp-signal-2 = ''"1.0"'';
            ramp-signal-3 = ''"1.0"'';
            ramp-signal-4 = ''"1.0"'';

            format-disconnected = "";
            # ;format-disconnected = <label-disconnected>
            #;format-disconnected-underline = ${self.format-connected-underline}
            #;label-disconnected = %ifname% disconnected
            #;label-disconnected-foreground = ${colors.foreground-alt}
          };
          "module/eth" = {
            type = "internal/network";
            interface = "eno1";
            interval = "3.0";

            format-connected-underline = "#55aa55";
            format-connected = " <label-connected>";
            label-connected = "%local_ip%";

            format-disconnected = "";
            format-disconnected-background = "#5479b7";
            #;format-disconnected = <label-disconnected>
            #;format-disconnected-underline = ${self.format-connected-underline}
            #;label-disconnected = %ifname% disconnected
            #;label-disconnected-foreground = ${colors.foreground-alt}
          };
          "module/date" = {
            type = "internal/date";
            interval = "5";

            date = ''" %Y-%m-%d"'';
            date-alt = ''" %Y-%m-%d"'';

            time = "%H:%M";
            time-alt = "%H:%M:%S";

            #format-prefix = "";
            #format-prefix-foreground = foreground_altcol;
            format-underline = "#0a6cf5";

            label = "%{A} %date% %time%";
          };
          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            adapter = "ADP1";
            full-at = "98";

            format-charging-background = "#689d6a";
            format-charging-prefix = ''" "'';
            format-charging = "<label-charging>";
            format-discharging-prefix = ''" "'';
            format-discharging = "<label-discharging>";
            format-discharging-background = "#689d6a";
            format-full-prefix = ''" "'';

            format-charging-underline = "#ffaa55";
            format-full-underline = "#ffaa55";

            ormat-full-padding = "1";
            format-charging-padding = "1";
            format-discharging-padding = "1";
          };
          "module/temperature" = {
            type = "internal/temperature";
            thermal-zone = "0";
            warn-temperature = "60";

            format = "<ramp> <label>";
            format-underline = "#f50a4d";
            format-warn = "<ramp> <label-warn>";
            format-warn-underline = "#f50a4d";

            label = " %temperature-c%";
            label-warn = "%temperature-c%";

            ramp-0 = "l";
            ramp-1 = "m";
            ramp-2 = "h";
          };

          "module/powermenu" = {
            type = "custom/menu";

            expand-right = "true";

            format-spacing = "1";

            label-open = ''""'';
            label-close = " cancel";
            label-separator = "|";

            menu-0-0 = "reboot";
            menu-0-0-exec = "menu-open-1";
            menu-0-1 = "power off";
            menu-0-1-exec = "menu-open-2";

            menu-1-0 = "cancel";
            menu-1-0-exec = "menu-open-0";
            menu-1-1 = "reboot";
            menu-1-1-exec = "sudo reboot";

            menu-2-0 = "power off";
            menu-2-0-exec = "sudo poweroff";
            menu-2-1 = "cancel";
            menu-2-1-exec = "menu-open-0";
          };

          "module/xbacklight" = {
            type = "internal/xbacklight";

            format = "<label> <bar>";
            label = "BL";
          };

          "module/dunst" = {
            type = "custom/script";
            exec = "PATH=${pkgs.dbus}/bin/:$PATH ${pkgs.dunst}/bin/dunstctl is-paused | ${pkgs.gnugrep}/bin/grep -q true && echo   || echo  ";
            interval = 10;
            click-left = "PATH=${pkgs.dbus}/bin/:$PATH ${pkgs.dunst}/bin/dunstctl set-paused toggle";
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
    };
}
