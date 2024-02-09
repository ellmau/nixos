{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.container.podman.enable = mkEnableOption "enable podman dockerisation";

  config = let
    cfg = config.elss.container.podman;
  in
    mkIf cfg.enable {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
}
