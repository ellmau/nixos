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
    mkIf cfg.enable {
      xsession = {
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hp: [
            hp.dbus
            hp.hostname
            hp.monad-logger
            hp.xmonad-contrib
          ];
          libFiles."ELSS.hs" = pkgs.writeText "ELSS.hs" ''
            module ELSS where
            keyboardtoggle = "${conf/keyboard/keyboard_layout_toggle.sh}"
          '';
          config = conf/xmonad/xmonad.hs;
        };
      };

      services = {
        betterlockscreen = {
          enable = true;
          inactiveInterval = 10;
        };
        picom = {
          enable = true;
          backend = "glx";
        };
      };

      gtk.enable = true;

      home.packages = with pkgs; [rofi polybarFull firefox pulseaudioFull];
    };
}
