{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.nginx;
  in
    mkIf cfg.enable {
      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
      networking.firewall.allowedTCPPorts = [80 443];
      services.nginx.virtualHosts."localhost" = {
        addSSL = false;
        enableACME = false;
        root = "/var/www/localhost";
        default = true;
      };
      services.nginx.virtualHosts."ellmauthaler.net" = {
        addSSL = true;
        enableACME = true;
        root = "/var/www/localhost";
      };
    };
}
