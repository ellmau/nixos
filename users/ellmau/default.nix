{ config, lib, pkgs, ...}:
{
  imports = [
    ./autorandr.nix
    ./dunst.nix
    ./git.nix
    ./gpg.nix
    ./i3.nix
    ./nextcloud.nix
    ./polybar.nix
    ./zsh.nix
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
  };
  
  xdg = {
    enable = true;
  };
  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations = "full";
        };
        alt_send_esc = true;
      };
    };
    
    direnv = {
      enable = true;
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
