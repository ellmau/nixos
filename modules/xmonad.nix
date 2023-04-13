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
      services = {
        xserver = {
          enable = true;
          windowManager.xmonad.enable = true;
          layout = "us";
          xkbOptions = "eurosign:e";
        };
        gnome.gnome-keyring.enable = true;

        printing.enable = true;
      };
      security.pam.services.lightdm.enableGnomeKeyring = true;
    };
}
