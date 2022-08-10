{ config, lib, pkgs, ... }:
with lib; {
  options.elss.programs.communication.enable = mkEnableOption "enable the basic graphical communication tools";

  config =
    let
      cfg = config.elss.programs.communication;
    in
    mkIf cfg.enable {
      # elss.graphical.enable = true;
      environment.systemPackages = with pkgs; [
        element-desktop
        jitsi-meet-electron
        signal-desktop
        skypeforlinux
        teams
        zoom-us
      ];
    };
}
