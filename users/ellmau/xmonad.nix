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
      xsession = {
        enable = true;

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.dbus
            haskellPackages.monad-logger
            haskellPackages.hostname
          ];
          config = mkDefault conf/xmonad/xmonad.hs;
        };
      };
    };
}
