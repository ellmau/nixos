{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.programs.communication.enable = mkEnableOption "enable the basic graphical communication tools";

  config = let
    cfg = config.elss.programs.communication;
  in
    mkIf cfg.enable {
      # elss.graphical.enable = true;
      environment.systemPackages = with pkgs; [
        element-desktop
        jitsi-meet-electron
        signal-desktop
        # skype is no longer existing
        #skypeforlinux
        #remove teams as MS has removed the linux packages from their servers
        #teams
        unstable.zoom-us
      ];
    };
}
