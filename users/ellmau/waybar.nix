{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical.sway;
  in
    mkIf cfg.enable {
      xdg.configFile."waybar/style.css" = {source = conf/waybar/style.css;};
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            modules-left = ["sway/workspaces" "sway/mode"];
            modules-center = ["sway/window"];
            modules-right = [
              "idle_inhibitor"
              "sway/language"
              "network#wifi"
              "network#base"
              "battery"
              "pulseaudio"
              "clock"
              "tray"
            ];

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
            };

            battery = {
              states = {
                good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              format-icons = ["" "" "" "" ""];
            };
            "clock" = {format-alt = "{:%a, %d. %b  %H:%M}";};

            "network#wifi" = {
              interface = "wlp2s0";
              format = "{ifname}";
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              format-disconnected = "wifi:";
              tooltip-format = "{ifname} via {gwaddr} ";
              tooltip-format-wifi = "{essid} ({signalStrength}%) ";
              tooltip-format-ethernet = "{ifname} ";
              tooltip-format-disconnected = "Disconnected";
              max-length = 50;
            };

            "network#base" = {
              format = "{ifname}";
              format-wifi = "";
              format-ethernet = "{ipaddr}/{cidr} ";
              format-disconnected = "";
              tooltip-format = "{ifname} via {gwaddr} ";
              tooltip-format-wifi = "{essid} ({signalStrength}%) ";
              tooltip-format-ethernet = "{ifname} ";
              tooltip-format-disconnected = "Disconnected";
              max-length = 50;
            };

            pulseaudio = {
              format = "{icon} {volume:2}%";
              format-bluetooth = "{icon}  {volume}%";
              format-muted = "🔇";
              format-icons = {
                headphones = "";
                default = ["🔈" "🔉" "🔊"];
              };
              scroll-step = 5;
              on-click = "${pkgs.pamixer}/bin/pamixer -t";
              on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol &";
            };
          };
        };
      };
    };
}
