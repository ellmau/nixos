{ config, pkgs, lib, ... }:
with lib;{
  config =
    let
      cfg = config.elss.server.nextcloud;
    in
      mkIf cfg.enable {
        elss.server.sql.enable = mkDefault true;
        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud24;
          hostName = "cloudstore.ellmauthaler.net";
          https = true;
          config = {
            dbtype = "mysql";
            dbuser = "cloudstore_user";
            dbpassFile = "/run/secrets/cloudstore_user";
            adminuser = "storemin";
            adminpassFile = "/run/secrets/storemin";
          };
        };

        sops.secrets = {
          storemin.sopsFile = ../../secrets/server.yaml;
          cloudstore_user.sopsFile = ../../secrets/server.yaml;
        };
      };
}
