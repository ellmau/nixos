{ config, pkgs, llib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "idle_inhibitor" "sway/language" "battery" "pulseaudio" "clock" "tray" ];

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
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
            format-icons = [ "" "" "" "" "" ];
          };
         
          pulseaudio = {
		        format = "{icon} {volume:2}%";
		        format-bluetooth = "{icon}  {volume}%";
		        format-muted = "MUTE";
		        format-icons = {
			        headphones = "";
			        default = [
				        ""
				        ""
			        ];
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
