{ config, pkgs, ...}:
{
  variables= {
    hostName = "nucturne";
    graphical = true;
  };
  #networking.hostName = "nucturne"; # define the hostname
}
