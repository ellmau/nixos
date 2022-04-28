{ pkgs, extraOverlays, name, flakes, flakeOutputs, ...}:
{ config, pkgs, lib, ...}:
{    
  imports =
    [ # hardware-configuration result
      ((./machine + "/${name}") + /hardware-configuration.nix)
      # machine-specific configuration
      (./machine + "/${name}")
      # additional programs
      ./programs
      # home-manager entry-point
      ./users
      # layers
      ./layer
      # options
      ./options.nix
    ];
  

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    useDHCP = false;
    hostName = config.variables.hostName;
  };

  nix = {
    autoOptimiseStore = true;
    # Enable flakes
    # Free up to 50GiB whenever there is less than 10GiB left.
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (10* 1024 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs = {
    overlays = [ flakes.emacs-overlay.overlay flakeOutputs.overlay ] ++ extraOverlays;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "skypeforlinux"
      "teams"
      "zoom"
    ];
  };

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [gnome3.dconf];
    };

    lorri.enable = true;
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/share/zsh/" ];
    systemPackages = with pkgs; [
      emacs-all-the-icons-fonts
      wget
      git
      clang
      rnix-lsp
      procs
    ];
    sessionVariables = rec {
      XDG_CACHE_HOME  = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME    = "\${HOME}/.local/bin";
      XDG_DATA_HOME   = "\${HOME}/.local/share";

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
      setOptions = [ "auto_pushd" "correct" "extendedglob" "nocaseglob" "rcexpandparam" "numericglobsort" "nobeep" "appendhistory" ];
    };

    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    dconf.enable = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      hasklig
      # corefonts # not free
      liberation_ttf
      comic-relief
      dejavu_fonts
      gyre-fonts
      open-sans
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      roboto
      roboto-mono
      (nerdfonts.override { fonts = [ "Hasklig" ]; })
      material-icons
      weather-icons
    ];

    fontconfig = {
      enable = true;
      # defaultFonts = {
      #   serif = [ "TeX Gyre Heros" ];
      #   emoji = [ "Noto Color Emoji" ];
      #   sansSerif = [ "TeX Gyre Pagella" ];
      #   monospace = [ "Hasklug Nerd Font Mono" ];
      # };
    };
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
