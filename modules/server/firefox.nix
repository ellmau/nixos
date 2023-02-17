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

      networking.firewall.allowedTCPPorts = [port];
      services.mysql.package = pkgs.mariadb;

      sops.secrets = {
        firefox_sync = {
          owner = "firefox-syncserver";
          sopsFile = ../../secrets/server.yaml;
        };
      };
    };
}
