{ config, pkgs, lib, ...}:
{
  home-manager.users.ellmau = {
    xdg = {
      configFile."i3" = {
        source = conf/i3;
        recursive = true;
      };
    };
  };
}
