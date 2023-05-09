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
          enablePackages = hp: [
            hp.dbus
            hp.monad-logger
            hp.xmonad-contrib
          ];
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
    };
}
