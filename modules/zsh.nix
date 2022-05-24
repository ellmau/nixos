{ config, pkgs, lib, ... }:
with lib; {
  options.elss.zsh.enable = mkEnableOption "Setup systemwide zsh";
  config =
    let
      inherit (elss.withConfig config) mapAllUsers;
    in
    mkIf config.elss.zsh.enable {
      environment = {
        shells = [ pkgs.zsh ];
        pathsToLink = [ "/share/zsh/" ];
        sessionVariables = rec {
          XDG_CACHE_HOME = "\${HOME}/.cache";
          XDG_CONFIG_HOME = "\${HOME}/.config";
          XDG_BIN_HOME = "\${HOME}/.local/bin";
          XDG_DATA_HOME = "\${HOME}/.local/share";

          PATH = [
            "\${XDG_BIN_HOME}"
          ];
        };
      };
      programs = {
        zsh = {
          enable = true;
          enableCompletion = true;
          enableGlobalCompInit = true;
          autosuggestions.enable = true;
          syntaxHighlighting = {
            enable = true;
            highlighters = [ "main" "brackets" "root" "line" ];
            #styles = { cursor = "standout,underline"; };
          };
          setOptions = [ "auto_pushd" "correct" "nocaseglob" "rcexpandparam" "numericglobsort" "nobeep" "appendhistory" ];
        };
      };

      users.users = mapAllUsers (_: { shell = pkgs.zsh; }

      );
    };
}
