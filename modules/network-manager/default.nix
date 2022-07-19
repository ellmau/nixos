{ config, pkgs, lib, ...}:
with lib; {
  options.elss.networking.useNetworkManager = mkEnableOption "enable networkmanager";

  config =
    let
      connections = [
        # "tartaros"
        # "eduroam"
      ];

      mkSopsSecrets = connection: {
        "${connection}" = {
          sopsFile = ../../secrets/networks.yaml;
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
  
