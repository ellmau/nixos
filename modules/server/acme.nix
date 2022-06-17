{ config, lib, pkgs, ... }:
with lib;{
  options.elss.server.acme.staging = mkEnableOption "Whether to use the staging or the default server for acme";
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
