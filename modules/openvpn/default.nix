{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.openvpn.enable = mkEnableOption "Setup  TUD openvpn";
  config = let
    cfg = config.elss.openvpn;
  in
    mkIf cfg.enable {
      services.openvpn.servers = {
        TUD_full = {
          config = "config ${config.sops.secrets.TUD_VPN_full.path}";
          autoStart = false;
        };

        TUD_split = {
          config = "config ${config.sops.secrets.TUD_VPN_split.path}";
          autoStart = false;
        };
      };
      sops.secrets = {
        "TUD_VPN_full" = {
          sopsFile = ../../secrets/networks.yaml;
        };
        "TUD_VPN_split" = {
          sopsFile = ../../secrets/networks.yaml;
        };
      };
    };
}
