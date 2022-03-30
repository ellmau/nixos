{ config, pkgs, lib, ...}:
{
  config = lib.mkIf config.variables.server {
    services.sshd.enable = true;
    imports = [
      ../services
      ../secrets
    ];
  };
}
