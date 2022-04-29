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
    git = {
      key = mkOption {
        type = types.str;
        example = "0xBEEE1234";
        default = "C804A9C1B7AF8256";
        description = "Signkey for git commits";
      };
      gpgsm = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use gpgsm for commit signatures";
      };
      signDefault = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to force signing commits or not";
      };
    };
  };
}
