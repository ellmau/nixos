{ config, pkgs, ...}:
{
  home-manager.users.ellmau = {
    programs= {
      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "Stefan Ellmauthaler";
        userEmail = "stefan.ellmauthaler@tu-dresden.de";
        extraConfig = {
          core = { editor = "emacsclient"; };
          gpg = {
            format = "x509";
            program = "gpgsm";
          };
          user = { signingKey = "0x4998BEEE"; };
          init = { defaultBranch = "main";};
          branch = { autosetuprebase = "always";};
        };
      };

      gh = {
        enable = true;
        settings = {
          aliases = {};
          editor = {};
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
    };
  };
}
