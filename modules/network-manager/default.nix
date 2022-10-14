{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.elss.networking = {
    useNetworkManager = mkEnableOption "enable networkmanager";
    nmConnections = mkOption {
      type = types.listOf types.str;
      description = "Connections to instantiate for the machine";
      default = [];
    };
  };

  config = let
    hostName = config.system.name;
    connections = config.elss.networking.nmConnections;

    mkSopsSecrets = connection: {
      "${connection}" = {
        sopsFile = ../../machines + builtins.toPath "/${hostName}/secrets/networks.yaml";
        path = "/run/NetworkManager/system-connections/${connection}.nmconnection";
      };
    };
  in
    mkIf config.elss.networking.useNetworkManager {
      networking.networkmanager = {
        enable = true;
      };

      sops.secrets = mkMerge (map mkSopsSecrets connections);
    };
}
