{ config, lib, pkgs, ... }:
with lib; {
  options.elss.server.enable = mkEnableOption "Enable Mail, Web, and DB";
  options.elss.server.nginx.enable = mkEnableOption "Set up nginx";
  options.elss.server.sql.enable = mkEnableOption "Set up sql (postresql)";
  options.elss.server.nextcloud.enable = mkEnableOption "Set up nextcloud";
  options.elss.server.smailserver.enable = mkEnableOption "Set up simple mail server";

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
