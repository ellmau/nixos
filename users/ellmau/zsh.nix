{pkgs, ...}: {
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
      config = {theme = "ansi";};
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
      plugins = with pkgs; [
        tmuxPlugins.nord
      ];
      extraConfig = ''
        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %
      '';
    };
  };
}
