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
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };

      services = {
        xserver = {
          enable = true;
        };

        desktopManager.plasma6.enable = true;
        displayManager = {
          sddm.wayland.enable = true;
          defaultSession = "plasma";
        };
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
