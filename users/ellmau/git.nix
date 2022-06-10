{ config, pkgs, lib, ...}:
{
  programs= {
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      extraConfig = {
        core = { editor = "emacsclient"; };
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
}
