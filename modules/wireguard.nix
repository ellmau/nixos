{ config, pkgs, lib, ... }:
with lib; {
  options.elss.wireguard = {
    enable = mkEnableOption "Setup wireguard";

  };
  config =
    let
      cfg = config.elss;
      hostname = cfg.hostName;
      secrets = ../machines
                + builtins.toPath "/${hostName}/secrets/wireguard.yaml";
    in
    mkIf cfg.wireguard.enable { };
}
