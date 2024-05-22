{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.steam.enable = mkEnableOption "Enable steam";

  config = let
    cfg = config.elss.steam;
  in
    mkIf cfg.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        gamescopeSession.enable = true;
      };
    };
}
