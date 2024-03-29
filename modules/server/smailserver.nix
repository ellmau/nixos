{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.smailserver;
  in
    mkIf cfg.enable {
      mailserver = {
        enable = true;
        fqdn = "mail.ellmauthaler.net";
        sendingFqdn = "ellmauthaler.net";
        domains = ["ellmauthaler.net"];

        loginAccounts = {
          "ellmau@ellmauthaler.net" = {
            aliases = ["stefan@ellmauthaler.net" "postmaster@ellmauthaler.net" "abuse@ellmauthaler.net"];
            hashedPasswordFile = config.sops.secrets.ellmauMail.path;
          };

          "printer@ellmauthaler.net" = {
            hashedPasswordFile = config.sops.secrets.printerMail.path;
          };

          "cloudstore@ellmauthaler.net" = {
            hashedPasswordFile = config.sops.secrets.cloudstoreMail.path;
          };
        };

        localDnsResolver = false;

        # use ACME
        certificateScheme = "acme-nginx";
      };

      sops.secrets = {
        ellmauMail = {
          owner = config.mailserver.vmailUserName;
          group = config.mailserver.vmailGroupName;
          sopsFile = ../../secrets/server.yaml;
        };
        printerMail = {
          owner = config.mailserver.vmailUserName;
          group = config.mailserver.vmailGroupName;
          sopsFile = ../../secrets/server.yaml;
        };
        cloudstoreMail = {
          owner = config.mailserver.vmailUserName;
          group = config.mailserver.vmailGroupName;
          sopsFile = ../../secrets/server.yaml;
        };
      };
    };
}
