{ config, lib, pkgs, ... }:

with lib; {
  options.elss.steam-run.enable = mkEnableOption "configure steam-run to support unpatched binaries";

  config =
    let
      cfg = config.elss.steam-run;
    in
    mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.unstable.steam.override { withJava = true; }).run
      ];
    };
}
