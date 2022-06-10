{ config, pkgs, lib, ... }:
with lib; {
  options.elss.sops.enable = mkEnableOption "Use sops config";

  config =
    let
      cfg = config.elss.sops;
    in
    mkIf cfg.enable {
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        secrets.example_key.format = "yaml";
        
      };
      sops.secrets = {
          storemin.sopsFile = ../secrets/server.yaml;
          cloudstore_user.sopsFile = ../secrets/server.yaml;
        };
    };
}
