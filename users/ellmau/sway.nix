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
      services = {
        blueman-applet.enable = true;
        swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "swaylock -KfeFi ~/.background-image";
            }
            {
              event = "lock";
              command = "swaylock -KfeFi ~/.background-image";
            }
          ];
          timeouts = [
            {
              timeout = 60;
              command = "swaylock -KfeFi ~/.background-image";
            }
          ];
        };
      };
      home.file.".background-image".source = ../../common/wallpaper/nix-wallpaper-nineish-dark-gray.png;

      gtk.enable = true;

      home.packages = [
        pkgs.gnome-icon-theme
        pkgs.swaylock
        pkgs.pulseaudioFull
      ];

      wayland.windowManager.sway = {
        enable = true;
        config = {
          down = "k";
          up = "l";
          left = "j";
          right = "semicolon";

          modifier = "Mod4";

          keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
            bctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          in
            lib.mkOptionDefault {
              "${modifier}+Shift+q" = "kill";
              "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
              "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
              "${modifier}+BackSpace" = ''mode "$mode_system"'';
              XF86MonBrightnessDown = "exec ${bctl} s 2%-";
              XF86MonBrightnessUp = "exec ${bctl} s 2%+";
              XF86AudioMute = "exec ${pkgs.pamixer}/bin/pamixer -t";
              XF86AudioLowerVolume = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
              XF86AudioRaiseVolume = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
            };
          keycodebindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in {};

          startup = [
            {
              command = "--no-startup-id nm-applet --indicator";
              always = true;
            }
            {
              command = "--no-startup-id blueman-applet";
              always = true;
            }
            {
              command = "--no-startup-id systemctl --user restart waybar.service";
              always = true;
            }
            {
              command = "--no-startup-id .config/i3/keepassxc.sh";
            }
            {
              command = ''--no-startup-id swaymsg output "*" bg .background-image fill'';
              always = true;
            }
          ];
          terminal = "alacritty";
          window = {
            titlebar = true;
          };

          floating = {
            criteria = [
              {class = "KeePassXC";}
              {class = "pavucontrol";}
              {app_id = "org.keepassxc.KeePassXC";}
              {app_id = "pavucontrol";}
            ];
          };

          bars = [];
        };
        extraConfig = ''
          input "type:keyboard" {
            xkb_layout us,de
            xkb_variant euro,nodeadkeys
            xkb_options grp:win_space_toggle
          }
          set $mode_system System (l) lock, (CTRL+e) logout, (CTRL+r) reboot, (CTRL+s) shutdown
          set $i3lockwall swaylock -KfeFi ~/.background-image
          mode "$mode_system" {
            bindsym l exec --no-startup-id $i3lockwall, mode "default"
            bindsym Ctrl+e exec --no-startup-id swaymsg exit, mode "default"
            #bindsym s exec --no-startup-id $i3lockwall && systemctl suspend, mode "default"
            #bindsym h exec --no-startup-id $i3lockwall && systemctl hibernate, mode "default"
            bindsym Ctrl+r exec --no-startup-id systemctl reboot, mode "default"
            bindsym Ctrl+s exec --no-startup-id systemctl poweroff -i, mode "default"

            # back to normal: Enter or Escape
            bindsym Return mode "default"
            bindsym Escape mode "default"
          }
        '';
      };
    };
}
