{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.programs.emacs.enable = mkEnableOption "Setup emacs package and install it";
  config = mkIf config.elss.programs.emacs.enable {
    services.emacs = {
      enable = true;
      defaultEditor = true;
      package = pkgs.emacsPackage;
    };
  };
}
