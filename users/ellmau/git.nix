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
          #gpg = {
          #  format = "x509";
          #  program = "gpgsm";
          #};
          user = { signingKey = "C804A9C1B7AF8256"; };
          init = { defaultBranch = "main";};
          branch = { autosetuprebase = "always";};
        };
        lfs.enable = true;
      };

      gh = {
        enable = true;
        settings = {
          aliases = {};
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
    };
  };
}
