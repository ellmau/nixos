{ config, pkgs, lib, ... }:
with lib; {
  options.elss.sops.enable = mkEnableOption "Use sops config";

  config =
    let
      cfg = config.elss.sops;
    in
    mkIf cfg.enable {
      sops = {
        defaultSopsFile = ../secrets/secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        age.keyFile = "/var/lib/sops-nix/key.txt";
        age.generateKey = true;
      };
    };
}
