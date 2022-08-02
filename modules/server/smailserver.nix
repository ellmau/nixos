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
        sendingFqdn = "ellmauthaler.net";
        domains = [ "ellmauthaler.net" ];

        loginAccounts = {
          "ellmau@ellmauthaler.net" = {
            aliases = [ "stefan@ellmauthaler.net" "postmaster@ellmauthaler.net" "abuse@ellmauthaler.net" ];
            hashedPasswordFile = config.sops.secrets.ellmauMail.path;
          };
        };
        
        # use ACME
        certificateScheme = 3;
      };

      sops.secrets = {
        ellmauMail = {
          owner = mailserver.vmailUserName;
          group = mailserver.vmailGroupName;
          sopsFile = ../../secrets/server.yaml;
        };
      };
    };
}
