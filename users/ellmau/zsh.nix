{ pkgs, ... }:
{
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
            # v0.5.0
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "4eb69b044ffab5197dfbf0f5d40e7cdb3d75e222";
            sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
            fetchSubmodules = true;
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

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "emacs";
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };
}
