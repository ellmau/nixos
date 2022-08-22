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
      xdg = {
        configFile."i3" = {
          source = conf/i3;
          recursive = true;
        };
      };
    };
}
