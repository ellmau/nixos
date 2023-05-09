{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.graphical.xmonad;
  in
    mkIf cfg.enable {
      elss.graphical.xserver.enable = true;
      services = {
        xserver = {
          windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
          };
        };
      };
    };
}
