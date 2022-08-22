{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs;
with lib; let
  my-python-packages = python-packages:
    with python-packages; [
      pandas
      requests
      # other python packages you want
    ];
  python-with-my-packages = python3.withPackages my-python-packages;
in {
  options.elss.programs.python.enable = mkEnableOption "install python 3";
  config = mkIf config.elss.programs.python.enable {
    environment.systemPackages = [python-with-my-packages];
  };
}
