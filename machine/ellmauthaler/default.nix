{ config, pkgs, ...}:
{

  variables = {
    hostName = "ellmauthaler";
  };
  
  networking = {
    domain = "net";
  };
}
