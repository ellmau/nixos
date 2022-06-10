{ config, pkgs, lib, ... }:
with lib;{
  config =
    let
      cfg = config.elss.server.smailserver;
    in
    mkIf cfg.enable {
      mailserver = {
        enable = true;
        fqdn = "mail.ellmauthaler.net";
        domains = [ "ellmauthaler.net" ];
      };
    };
}
