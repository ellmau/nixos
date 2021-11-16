{ config, pkgs, lib, ... }:
let
  isgraphical = config.variables.graphical;
in
{
  networking.networkmanager.enable = isgraphical;

  services = {
    xserver = {
      enable = isgraphical;
      displayManager.lightdm.enable = isgraphical;
      windowManager.i3 = {
        enable = isgraphical;
        extraPackages = with pkgs; [
          rofi # launcher
          polybarFull # bar
          i3lock # lock screen
          xss-lock
          autorandr
        ];
        extraSessionCommands = ''
          ${pkgs.autorandr}/bin/autorandr -c
        '';
      };
      layout = "us";
      xkbOptions = "eurosign:e";
    };
    gnome.gnome-keyring.enable = true;

    printing.enable = true;
  };

  sound.enable = isgraphical;
  
  hardware = {
    pulseaudio.enable = isgraphical;
    bluetooth.enable = isgraphical;
  };
  
  services.blueman.enable = isgraphical;

  environment.systemPackages = if isgraphical then with pkgs; [
    firefox
    alacritty
    thunderbird
    okular
    texlive.combined.scheme-full
    usbutils
    keepassxc
    gnome.libsecret
    arandr
  ] else [ ];
}
