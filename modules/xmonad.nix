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
      elss.users.dunst.enable = true;
      elss.graphical.xmonad.polybar.enable = true;
      services = {
        xserver = {
          startDbusSession = true;
          windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
          };
          displayManager.defaultSession = "none+xmonad";
          libinput = {
            enable = true;
            disableWhileTyping = true;
          };
        };
        upower.enable = true;
      };
    };
}
