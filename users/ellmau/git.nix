{ config, pkgs, lib, ...}:
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
          gpg = lib.mkIf config.variables.git.gpgsm {
            format = "x509";
            program = "${pkgs.gnupg}/bin/gpgsm";
          };
          #gpg = {
          #  format = "x509";
          #  program = "gpgsm";
          #};
          user = {
            signingKey = config.variables.git.key;
            signByDefault = config.variables.git.signDefault;
          };
          init = { defaultBranch = "main";};
          branch = { autosetuprebase = "always";};
          safe.directory = [ "/etc/nixos" ];
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
