{ config, lib, pkgs, ... }:
with lib; {
  options.elss.server = {
    acme.staging = mkEnableOption "Whether to use the staging or the default server for acme";
    enable = mkEnableOption "Enable Mail, Web, and DB";
    nginx.enable = mkEnableOption "Set up nginx";
    sql.enable = mkEnableOption "Set up sql (postresql)";
    nextcloud.enable = mkEnableOption "Set up nextcloud";
    smailserver.enable = mkEnableOption "Set up simple mail server";
    unbound.enable = mkEnableOption "Set unbound dns up";
    
  };

  imports = [
    ./acme.nix
    ./nextcloud.nix
    ./nginx.nix
    ./smailserver.nix
    ./sql.nix
    ./unbound.nix
  ];

  config =
    let
      cfg = config.elss.server;
    in
    mkIf cfg.enable {
      elss.server = {
        nginx.enable = mkDefault true;
        sql.enable = mkDefault true;
        smailserver.enable = mkDefault false; # TODO fix simple mail server
        nextcloud.enable = mkDefault true;
        unbound.enable = mkDefault true;
      };
    };
}
