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
      services.openvpn.servers.TUD = {
        config = "config config/TUD.ovpn";
        autoStart = false;
      };
    };
}
