{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.server = {
    acme.staging = mkEnableOption "Whether to use the staging or the default server for acme";
    enable = mkEnableOption "Enable Mail, Web, and DB";
    firefox.enable = mkEnableOption "Enable firefox sync server";
    nginx.enable = mkEnableOption "Set up nginx";
    sql.enable = mkEnableOption "Set up sql (postresql)";
    nextcloud.enable = mkEnableOption "Set up nextcloud";
    smailserver.enable = mkEnableOption "Set up simple mail server";
    unbound.enable = mkEnableOption "Set unbound dns up";
    grocy.enable = mkEnableOption "Set up grocy";
    gitea.enable = mkEnableOption "Set up gitea";
    wordpress.enable = mkEnableOption "Set up wordpress";
    wordpress.domain = mkOption {
      type = types.str;
      description = "domain for which it shall be set up";
      default = "wp.ellmauthaler.net";
    };
  };

  imports = [
    ./acme.nix
    ./firefox.nix
    ./gitea.nix
    ./grocy.nix
    ./nextcloud.nix
    ./nginx.nix
    ./smailserver.nix
    ./sql.nix
    ./unbound.nix
    ./wordpress.nix
  ];

  config = let
    cfg = config.elss.server;
  in
    mkIf cfg.enable {
      elss.server = {
        nginx.enable = mkDefault true;
        sql.enable = mkDefault true;
        smailserver.enable = mkDefault true;
        nextcloud.enable = mkDefault true;
        unbound.enable = mkDefault true;
        grocy.enable = mkDefault true;
        gitea.enable = mkDefault true;
        wordpress.enable = mkDefault true;
      };
    };
}
