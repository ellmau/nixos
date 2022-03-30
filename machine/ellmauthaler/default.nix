{ config, pkgs, ...}:
{

  variables = {
    hostName = "ellmauthaler";
    server = true;
  };
  
  networking = {
    domain = "net";
  };
}
