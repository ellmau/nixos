{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.elss.programs.obsstudio.enable = mkEnableOption "install obs-studio";
  config = mkIf config.elss.programs.obsstudio.enable {
    environment.systemPackages = with pkgs; [
      obs-studio
    ];
  };
}
