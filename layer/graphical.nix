{ config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      windowManager.i3 = {
        enable = true;
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

  sound.enable = true;
  
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };
  
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    alacritty
    thunderbird-91
    okular
    texlive.combined.scheme-full
    usbutils
    keepassxc
    gnome.libsecret
    arandr
  ];
}
