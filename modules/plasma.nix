{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.elss.graphical.plasma.enable = mkEnableOption "Use plasma";
  config = let
    cfg = config.elss.graphical.plasma;
  in
    mkIf cfg.enable {
      services.xserver = {
        enable = true;
        displayManager = {
          sddm.enable = true;
          #defaultSession = "plasmawayland";
        };
        desktopManager.plasma5.enable = true;
      };

      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sddm = {
        enableGnomeKeyring = true;
        gnupg.enable = true;
      };

      environment.systemPackages = with pkgs; [
        firefox
        thunderbird
      ];
    };
}
