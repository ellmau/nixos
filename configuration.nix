# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./programs/emacs
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nucturne"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  #networking.networkmanager.unmanaged = [ "enp0s20f0u4u1u3" ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
   networking.useDHCP = false;
  # networking.interfaces.eno1.useDHCP = true;
  # networking.interfaces.enp0s20f0u4u1u3.useDHCP = true;
  # networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable i3
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      rofi # launcher
      polybar # bar
      i3lock # lock screen
    ];
  };
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.ellmau = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio"];
    description = "Stefan Ellmauthaler";
    shell = pkgs.zsh;
    home = "/home/ellmau";
    hashedPassword = "$6$JZPnaZYG$KL2c3e1it3j2avioovE1WveN/mpmq/tPsSAvHY1XRhtqKaE7TaSQkqRy69farkIR0Xs0.yTjltvKvv28kZtLO1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     #emacs
     aspell
     emacs-all-the-icons-fonts	
     wget
     firefox
     alacritty
     git
     thunderbird
     okular
     texlive.combined.scheme-full
     rustup
     usbutils
     starship
  ];
   
  #services.emacs.enable = true;
  #services.emacs.defaultEditor = true;

  environment.shells = [ pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh = {
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";

    PATH = [ 
      "\${XDG_BIN_HOME}"
    ];
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

