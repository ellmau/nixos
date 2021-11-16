{ config, pkgs, lib, ...}:
{
  options.variables = with lib; {
    hostName = mkOption {
      type = types.str;
      example = "nucturne";
      description = "Hostname of the system";
      default = "hostnamenotset";
    };
    graphical = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the graphical environment";
    };
    server = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this system is a server";
    };
  };
}
