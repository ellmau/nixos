{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical;
  in
    mkIf cfg.enable {
      services = {
        gtk.enable = true;
        blueman-applet.enable = true;
        home.file.".background-image".source = ../../common/wallpaper/nix-wallpaper-nineish-dark-gray.png;
      };
    };
}
