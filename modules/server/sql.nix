{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.sql;
  in
    mkIf cfg.enable {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_14;
        ensureDatabases = ["nextcloud"];
        ensureUsers = [
          {
            name = "nextcloud";
            ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
          }
        ];
        authentication = ''
          local gitea all ident map=gitea-users
        '';
        identMap = ''
          gitea-users gitea gitea
        '';
      };
    };
}
