{ pkgs, ... }:
{
  home-manager.users.ellmau = {
    programs = {
      zsh = {
        enable = true;
        defaultKeymap = "emacs";
        oh-my-zsh.enable = false;
        # remove extra stuff on the right side of the prompt
        initExtra = ''
      unset RPS1
      # Color man pages
      export LESS_TERMCAP_mb=$'\E[01;32m'
      export LESS_TERMCAP_md=$'\E[01;32m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;47;34m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[01;36m'
      export LESS=-R
    '';
        shellAliases = {
          cp = "cp -i";
          ls = "exa --icons --git";
          ll = "exa --long --icons --binary --group";
          llg = "exa --long --icons --grid --binary --group";
          lal = "ll --all";
          lla = "ll --all";
          emacsc = "emacsclient -n";
        };
        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.4.0";
              sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
            };
          }
        ];
      };
      
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          format = "$all";
          username.show_always = false;
          git_commit.tag_disabled = false;
          hostname.ssh_only = false;
          directory.truncate_to_repo = true;
        };
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      bat = {
        enable = true;
        config = { theme = "ansi"; };
      };

      exa = {
        enable = true;
        enableAliases = false;
      };
    };

  };
}
