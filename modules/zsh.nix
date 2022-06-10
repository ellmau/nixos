{ config, pkgs, lib, ... }:
with lib; {
  options.elss.zsh.enable = mkEnableOption "Setup systemwide zsh";
  config =
    let
      inherit (elss.withConfig config) mapAllUsers;
      cfg = config.elss.zsh;
    in
    mkIf cfg.enable {
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

          shellInit = ''
            if [[ $TERM == "dumb" ]]; then
              INSIDE_EMACS=1
            fi;
          '';

          interactiveShellInit = ''
            source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

            zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
            zstyle ':completion:*:descriptions' format "- %d -"
            zstyle ':completion:*:corrections' format "- %d - (errors %e})"
            zstyle ':completion:*:default' list-prompt '%S%M matches%s'
            zstyle ':completion:*:manuals' separate-sections true
            zstyle ':completion:*:manuals.(^1*)' insert-sections true
            zstyle ':completion:*' menu select
            zstyle ':completion:*' verbose yes
            zstyle ':completion:*' squeeze-slashes true
            zstyle ':completion:*:*:kill:*' menu yes select
            zstyle ':completion:*:kill:*' force-list always
          '';
        };
      };

      users.users = mapAllUsers (_: { shell = pkgs.zsh; }

      );
    };
}
