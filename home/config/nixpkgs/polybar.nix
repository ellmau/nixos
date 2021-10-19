{ pkgs, ...}:
{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    settings =
      let
        background_col = "#120030";
        foreground_col = "#9e66ff";
        foreground_altcol = "#66deff";
        primary_col = "#ffb52a";
        secondary_col = "#e60053";
        alert_col = "#bd2c40";
      in
        {
          "bar/main" = {
            font = [
              "Hasklig:style=Regular"
              "all-the-icons:style=Regular"
              "Webdings:style=Regular"
              "Noto Emoji:scale=10"
              "Unifont:style=Regular"
              "Material Icons:size=12;0"
              "Weather Icons:size=12;0"
              "Hasklug Nerd Font,Hasklig Medium:style=Medium,Regular"
            ];
            modules = {
              left = "i3";
              center = "";
              right = " xbacklight xkeyboard eth wlan battery date powermenu dunst volume ";
            };

            background = background_col;
            foreground = foreground_col;

            monitor = ''
          ''${env:MONITOR:}
        '';
            width = "100%";
            module-margin = 1;
            tray = {
              position = "right";
              padding = 2;
              background = foreground_col;
            };
          };
          "bar/aux" = {
            font = [
              "Hasklig:style=Regular"
              "all-the-icons:style=Regular"
              "Webdings:style=Regular"
              "Noto Emoji:scale=10"
              "Unifont:style=Regular"
              "Material Icons:size=12;0"
              "Weather Icons:size=12;0"
              "Hasklug Nerd Font,Hasklig Medium:style=Medium,Regular"
            ];
            modules = {
              left = "i3";
              center = "";
              right = " xbacklight xkeyboard eth wlan battery date powermenu volume ";
            };

            background = background_col;
            foreground = foreground_col;

            monitor = ''
          ''${env:MONITOR:}
        '';
            width = "100%";
            module-margin = 1;
          };
          
          "module/volume" = {
            type = "internal/pulseaudio";
            format.volume = "<ramp-volume> <label-volume>";
            label.muted.text = "🔇";
            label.muted.foreground = "#666";
            ramp.volume = ["🔈" "🔉" "🔊"];
            click.right = "${pkgs.pavucontrol}/bin/pavucontrol &";
          };
          "module/i3" = { 
            type = "internal/i3";
            format = "<label-state> <label-mode>";
            index-sort = "true";
            wrapping-scroll = "false";

            #; Only show workspaces on the same output as the bar
            pin-workspaces = "true";

            label-mode-padding = "2";
            label-mode-foreground = "#000";
            label-mode-background = primary_col;

            #; focused = Active workspace on focused monitor
            label-focused = "%name%";
            #;label-focused-background = ${colors.background-alt}
            #;label-focused-background = #9f78e1
            label-focused-background = foreground_col;
            label-focused-underline= primary_col;
            label-focused-foreground = "#cccccc";
            label-focused-padding = "2";

            #; unfocused = Inactive workspace on any monitor
            label-unfocused = "%name%";
            label-unfocused-padding = "2";

            #; visible = Active workspace on unfocused monitor
            label-visible = "%index%";
            label-visible-background = "#6c419a";
            label-visible-underline = primary_col;
            label-visible-padding = 2;

            #; urgent = Workspace with urgency hint set
            label-urgent = "%name%";
            label-urgent-background = alert_col;
            label-urgent-padding = "2";
            
            #; Separator in between workspaces
            #; label-separator = |
          };
          "module/xkeyboard" = {
            type = "internal/xkeyboard";
            blacklist-0 = "num lock";
            interval = "5";

            format-prefix = ''""'';
            format-prefix-foreground = foreground_altcol;
            format-prefix-underline = secondary_col;

            label-layout = "%layout%";
            label-layout-underline = secondary_col;

            label-indicator-padding = "2";
            label-indicator-margin = "1";
            label-indicator-background = secondary_col;
            label-indicator-underline = secondary_col;
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


            ramp-signal-foreground = foreground_altcol;
          };
          "module/eth" = {
            type = "internal/network";
            interface = "eno1";
            interval = "3.0";

            format-connected-underline = "#55aa55";
            format-connected = " <label-connected>";
            format-connected-prefix-foreground = foreground_altcol;
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

            label = "%date% %time%";
          };
          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            adapter = "ADP1";
            full-at = "98";

            format-charging-background= "#689d6a";
            format-charging-prefix = ''" "''; 
            format-charging = "<label-charging>";
            format-discharging-prefix = ''" "'';
            format-discharging = "<label-discharging>";
            format-discharging-background= "#689d6a";
            format-full-prefix = ''" "'';

            format-charging-underline = "#ffaa55";
            format-full-prefix-foreground = foreground_altcol;
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
            label-warn-foreground = secondary_col;

            ramp-0 = "l";
            ramp-1 = "m";
            ramp-2 = "h";
            ramp-foreground = foreground_altcol;
          };

          "module/powermenu" = {
            type = "custom/menu";

            expand-right = "true";

            format-spacing = "1";

            label-open = ''""'';
            label-open-foreground = secondary_col;
            label-close = " cancel";
            label-close-foreground = secondary_col;
            label-separator = "|";
            label-separator-foreground = foreground_altcol;

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

            bar-width = "10";
            bar-indicator = "|";
            bar-indicator-foreground = "#fff";
            bar-indicator-font = "2";
            bar-fill = "─";
            bar-fill-font = "2";
            bar-fill-foreground = "#9f78e1";
            bar-empty = "─";
            bar-empty-font = "2";
            bar-empty-foreground = foreground_altcol;
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
}
