{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical.xmonad;
  in
    mkIf cfg.enable {
      programs.rofi = {
        enable = true;
        terminal = ${pkgs.alacritty} /bin/alacritty;
        #theme = conf/rofi/theme.rafi;
      };
    };
}
