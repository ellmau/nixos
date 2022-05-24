{ config, lib, pkgs, ... }:
with lib; {
  options.elss.texlive = {
    enable = mkEnableOption "configure texlife on the system";

    package = mkOption {
      type = types.package;
      default = pkgs.texlive.combined.scheme-full;
      description = ''
        This option specifies which texlive package shall be installed
      '';   
    };
  };

  config =
    let
      cfg = config.elss.texlive;
    in
      mkIf cfg.enable {
        environment.systemPackages = [
          cfg.package
        ];
      };
}
