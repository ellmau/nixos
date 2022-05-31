{ config, lib, pkgs, ... }:
with lib; {
  options.elss.sshd.enable = mkEnableOption "Set up sshd";

  config =
    let
      cfg = config.elss.sshd;
    in
      mkIf cfg.enable {
        services.openssh = {
          enable = true;
          passwordAuthentication = false;
          permitRootLogin = "no";
        };
      };
}
