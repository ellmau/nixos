{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.nextcloud;
  in
    mkIf cfg.enable {
      elss.server.sql.enable = mkDefault true;
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud31;
        hostName = "cloudstore.ellmauthaler.net";
        https = true;
        config = {
          dbtype = "pgsql";
          dbuser = "nextcloud";
          dbname = "nextcloud";
          adminuser = "storemin";
          adminpassFile = config.sops.secrets.storemin.path;
          dbhost = "/run/postgresql";
        };
        settings = {
          default_phone_region = "DE";
        };
      };

      services.nginx.virtualHosts."cloudstore.ellmauthaler.net" = {
        enableACME = true;
        forceSSL = true;
      };

      systemd.services."nextcloud-setup" = {
        requires = ["postgresql.service"];
        after = ["postrgresql.service"];
      };
      sops.secrets = {
        storemin = {
          owner = "nextcloud";
          group = "nextcloud";
          sopsFile = ../../secrets/server.yaml;
        };
      };
    };
}
