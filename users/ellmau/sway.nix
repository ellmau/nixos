{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.variables.graphical {
      programs = {
      waybar.enable = true;
      nm-applet.enable = true;
    };
    home-manager.users.ellmau = {
      wayland.windowManager.sway = {
        enable = true;
        config = {
          modifier = "Mod4";
          left = "j";
          down = "k";
          up = "l";
          right = "semicolon";
          menu = "${pkgs.wofi}/bin/wofi -S drun";
          window.titlebar = true;
          startup = [
            { command = "systemctl --user restart waybar.service"; always = true; }
            { command = "$XDG_CONFIG_HOME/sway/keepassxc.sh"; always = true; }
            { command = "gnome-keyring-daemon --start --components=pksc11,secrets,ssh"; always = true; }
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; }
          ];
          terminal = "${pkgs.alacritty}/bin/alacritty";
          bars = [];
          keybindings =
            let
              modifier = config.home-manager.users.ellmau.wayland.windowManager.sway.config.modifier;
            in lib.mkOptionDefault {
              # use pactl for volume control
                "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
                "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
                "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
                "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                "${modifier}+space" = "exec --no-startup-id $XDG_CONFIG_HOME/sway/keyboard_layout_toggle.sh";
                "${modifier}+BackSpace" = "mode '$mode_system'";
            };
        };
        extraConfig = ''
            exec swayidle -w \
                timeout 300 'swaylock -f -c 000000' \
                timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
                before-sleep 'swaylock -f -c 000000'


                # shutdown / restart / suspend...
                set $mode_system System (l) lock, (CTRL+e) logout, (CTRL+r) reboot, (CTRL+s) shutdown

                mode "$mode_system" {
                    bindsym l exec --no-startup-id swaylock, mode "default"
                    bindsym Ctrl+e exec --no-startup-id sway-msg exit, mode "default"
                    bindsym Ctrl+r exec --no-startup-id systemctl reboot, mode "default"
                    bindsym Ctrl+s exec --no-startup-id systemctl poweroff -i, mode "default"

                    # back to normal: Enter or Escape
                    bindsym Return mode "default"
                    bindsym Escape mode "default"
                }
        '';
      };

      # services = {
      #   swayidle = {
      #     enable = true;
      #     events = [
      #       {event = "before-sleep"; command = "swaylock"; }
      #       {event = "lock"; command = "swaylock"; }
      #     ];
      #   };
      # };

      xdg.configFile= {
        "swaylock" = {
          source = conf/swaylock;
          recursive = true;
        };
        "sway" = {
          source = conf/sway;
          recursive = true;
        };
      };
    };
  };
}
