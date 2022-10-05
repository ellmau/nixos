{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.elss.networking.useNetworkManager = mkEnableOption "enable networkmanager";

  config = let
    hostName = config.system.name;
    connections = [
      "tartaros"
      "eduroam"
    ];

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
