{ config, pkgs, lib, ...}:
{
  config = lib.mkIf config.variables.graphical {
    home-manager.users.ellmau = {
      xdg = {
        configFile."i3" = {
          source = conf/i3;
          recursive = true;
        };
      };
    };
  };
}
