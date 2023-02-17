{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.firefox;
    port = 5000;
  in
    mkIf cfg.enable {
      elss.server.sql.enable = mkDefault true;
      services.firefox-syncserver = {
        enable = true;
        secrets = config.sops.secrets.firefox_sync.path;
        singleNode = {
          enable = true;
          hostname = "firefox.ellmauthaler.net";
          enableTLS = true;
          capacity = 1;
          enableNginx = true;
        };
        settings.port = port;
      };

      # user is not created by firefox syncserver
      users.users.firefox-syncserver = {
        group = "firefox-syncserver";
        isSystemUser = true;
      };

      users.groups.firefox-syncserver.members = ["firefox-syncserver" config.services.nginx.user];

      networking.firewall.allowedTCPPorts = [port];
      services.mysql.package = pkgs.mariadb;

      sops.secrets = {
        firefox_sync = {
          owner = "firefox-syncserver";
          group = "firefox-syncserver";
          sopsFile = ../../secrets/server.yaml;
        };
      };
    };
}
