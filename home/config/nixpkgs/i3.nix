{ config, pkgs, lib, ...}:
{
  xdg = {
    configFile."i3" = {
      source = conf/i3;
      recursive = true;
    };
  };
}
