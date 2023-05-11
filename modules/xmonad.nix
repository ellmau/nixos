{ config, pkgs, lib, ... }:
with lib; {
  config = let cfg = config.elss.graphical.xmonad;
  in mkIf cfg.enable {
    elss.graphical.xserver = {
      enable = true;
      autorandr.enable = true;
    };
    elss.users.dunst.enable = true;
    elss.graphical.xmonad.polybar.enable = true;
    services = {
      xserver = {
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
        displayManager.defaultSession = "none+xmonad";
        libinput = {
          enable = true;
          touchpad = { disableWhileTyping = true; };
        };
      };
      upower.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [ firefox thunderbird ];
  };
}
