{ config, pkgs, lib, ... }:
let
  isgraphical = config.variables.graphical;
  cursorsize = if config.variables.hostName == "nucturne" then 14 else 16;
in
{
  networking.networkmanager.enable = isgraphical;

  services = {
     xserver = {
       enable = isgraphical;
       displayManager.sddm = {
         enable = isgraphical;
    #     greeters.gtk.cursorTheme.size = cursorsize;
       };
    #   # displayManager.sessionCommands = ''
    #   #   ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
    #   #   Xcursor.size: 14
    #   #   EOF
    #   # '';
    #   windowManager.i3 = {
    #     enable = isgraphical;
    #     extraPackages = with pkgs; [
    #       rofi # launcher
    #       polybarFull # bar
    #       i3lock # lock screen
    #       xss-lock
    #       autorandr
    #     ];
    #     extraSessionCommands = ''
    #       ${pkgs.autorandr}/bin/autorandr -c
    #     '';
    #   };
       layout = "us";
       xkbOptions = "eurosign:e";
     };
    
    # greetd = {
    #   enable = isgraphical;
    #   settings = {
    #     default_session = {
    #       #command = "${lib.makeBinPath [pkgs.greetd.tuigreet] }/tuigreet --time --cmd sway";
    #       command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
    #       #command = "agreety --cmd sway";
    #       user = "greeter";
    #     };
    #   };
    # };
    gnome.gnome-keyring.enable = true;

    printing.enable = true;
  };
  
  programs.sway = {
  enable = isgraphical;
  wrapperFeatures.gtk = isgraphical; # so that gtk works properly
  extraPackages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    dunst # notification daemon
    alacritty # Alacritty is the default terminal in the config
    wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
  ];
  };

  programs.qt5ct.enable = isgraphical;
  sound.enable = isgraphical;
  
  hardware = {
    pulseaudio.enable = isgraphical;
    bluetooth.enable = isgraphical;
  };
  
  services.blueman.enable = isgraphical;

  environment.systemPackages = if isgraphical then with pkgs; [
    firefox
    #alacritty
    thunderbird
    okular
    texlive.combined.scheme-full
    usbutils
    keepassxc
    gnome.libsecret
    arandr
    gtk-engine-murrine
    gtk_engines
    libappindicator-gtk3
    gsettings-desktop-schemas
    lxappearance
  ] else [ ];
}
