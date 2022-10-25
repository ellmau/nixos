{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.gitea;
  in
    mkIf cfg.enable {
      services.nginx.virtualHosts."git.ellmauthaler.net" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3001";
        };
      };

      services.gitea = {
        enable = true;
        disableRegistration = true;
        appName = "gitea: ellmauthaler.net gitea service";
        database = {
          type = "postgres";
          host = "/run/posgresql";
        };
        domain = "git.ellmauthaler.net";
        rootUrl = "https://git.ellmauthaler.net";
        httpPort = 3001;
      };
    };
}
