{ config, lib, pkgs, ... }:
with lib;{
  config =
    let
      cfg = config.elss.server;
      staging = config.elss.server.acme.staging;
    in
    mkIf cfg.enable {
      security.acme = {
        defaults = {


          server = mkIf staging "https://acme-staging-v02.api.letsencrypt.org/directory";
          email = "stefan.ellmauthaler@gmail.com"; # Do not use ellmauthaler.net as the mail server will be covered by acme
        };
        acceptTerms = true;
      };
    };
}
