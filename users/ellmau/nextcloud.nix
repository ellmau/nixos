{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical;
  in
    mkIf cfg.enable {
      services.nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
}
