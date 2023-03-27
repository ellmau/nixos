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
      services = {
        blueman-applet.enable = true;
      };
      gtk.enable = true;
      home.file.".background-image".source = ../../common/wallpaper/nix-wallpaper-nineish-dark-gray.png;
    };
}