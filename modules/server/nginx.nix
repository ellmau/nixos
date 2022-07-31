{ config, lib, pkgs, ... }:
with lib;{
  config =
    let
      cfg = config.elss.server.nginx;
    in
    mkIf cfg.enable {
      services.nginx.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      services.nginx.virtualHosts."localhost" = {
        addSSL = false;
        enableACME = false;
        root = "/var/www/localhost";
      };
    };
}
