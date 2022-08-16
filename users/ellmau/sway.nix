{ config, pkgs, lib, ... }:
{
  services = {
    blueman-applet.enable = true;
  };
  home.file.".background-image".source = ../../common/wallpaper/nix-wallpaper-nineish-dark-gray.png;

  gtk.enable = true;

  home.packages = [
    pkgs.gnome-icon-theme
  ];
  
  wayland.windowManager.sway = {
    enable = true;
    config = {
      down = "k";
      up = "l";
      left = "j";
      right = "semicolon";

      modifier = "Mod4";

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
          "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
          "${modifier}+BackSpace" = ''mode "$mode_system"'';
        };
      keycodebindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        { };

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
      ];
      terminal = "alacritty";
      window = {
        titlebar = true;
      };

      bars = [ ];
    };
    extraConfig = ''
      set $mode_system System (l) lock, (CTRL+e) logout, (CTRL+r) reboot, (CTRL+s) shutdown
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
}
