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
            dbpassFile = config.sops.secrets.cloudstore_user.path;
            adminuser = "storemin";
            adminpassFile = config.sops.secrets.storemin.path;
          };
        };

        sops.secrets = {
          storemin.sopsFile = ../../secrets/server.yaml;
          cloudstore_user.sopsFile = ../../secrets/server.yaml;
        };
      };
}
