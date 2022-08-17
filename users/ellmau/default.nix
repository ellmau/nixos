{ config, lib, pkgs, ... }:
{
  imports = [
#    ./autorandr.nix
#    ./dunst.nix
    ./git.nix
    ./gpg.nix
    ./i3.nix
    ./kanshi.nix
    ./mako.nix
    ./nextcloud.nix
#    ./polybar.nix
    ./zsh.nix

    ./sway.nix
    ./waybar.nix
  ];
  services = {
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };

  xdg = {
    enable = true;
  };

  home.packages = with pkgs; [
    # comma did not compile on 15.07.2022
    comma
    kanshi
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "none";
        };
        alt_send_esc = true;
        font = {
          normal.family = "Hasklug Nerd Font";
          size = 14;
        };
        # colors = {
        #   primary = {
        #     background = "#282828"; # base3
        #     foreground = "#dfbf8e"; # base00
        #   };

        #   cursor = {
        #     text = "CellBackground";
        #     cursor = "CellForeground";
        #   };

        #   normal = {
        #     black = "#665c54"; # base02
        #     red = "#ea6962"; # red
        #     green = "#a9b665"; # green
        #     yellow = "#e78a4e"; # yellow
        #     blue = "#7daea3"; # blue
        #     magenta = "#d3869b"; # magenta
        #     cyan = "#89b482"; # cyan
        #     white = "#dfbf8e"; # base2
        #   };

        #   bright = {
        #     black = "#928374"; # base03
        #     red = "#ea6962"; # orange
        #     green = "#a6b665"; # base01
        #     yellow = "#e3a84e"; # base00
        #     blue = "#7daea3"; # base0
        #     magenta = "#d3869b"; # violet
        #     cyan = "#89b482"; # base1
        #     white = "#dfbf8e"; # base3
        #   };
        # };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    home-manager = {
      enable = true;
    };

    ssh = {
      enable = true;

      forwardAgent = true;
      serverAliveInterval = 5;
      hashKnownHosts = true;
      controlMaster = "auto";
      controlPersist = "60s";
    };

    go.enable = true;
  };
}
