{ config, pkgs, lib, ...}:
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."localhost" = {
    addSSL = false;
    enableACME = false;
    root = "/var/www/localhost";
  };
}
