{ config, pkgs, lib, ... }:
with lib;{
  config =
    let
      cfg = config.elss.server.sql;
    in
    mkIf cfg.enable {
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };
    };
}
