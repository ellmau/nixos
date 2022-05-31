{ config, pkgs, lib, ... }:
with lib; {
  options.elss.sops.enable = mkEnableOption "Use sops config";

  config =
    let
      cfg = config.elss.sops;
    in
    mkIf cfg.enable {
      sops = {
        defaultSopsFile = ./secrets.yaml;

      };
    };
}
