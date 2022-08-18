{ config, pkgs, lib, ... }:
with lib; {
  options.elss.graphical = {
    enable = mkEnableOption "configure graphical layer";
    greeterCursorsize = mkOption {
      type = types.int;
      default = 16;
      description = ''
        Size of the cursortheme in the lightdm greeter
      '';
    };
    dpi = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        DPI setting for the xserver
      '';
    };
    i3.enable = mkEnableOption "enable i3";
  };
  config =
    let
      cfg = config.elss.graphical;
      #cursorsize = if config.variables.hostName == "nucturne" then 14 else 16;
      #xserverDPI = if config.variables.hostName == "stel-xps" then 180 else null;
    in
    mkIf cfg.enable {
      elss.users.x11.enable = if cfg.i3.enable then true else false;
      elss.networking.useNetworkManager = true;

      services = {
        xserver = mkIf cfg.i3.enable {
          enable = true;
          dpi = cfg.dpi;
          displayManager.lightdm = {
            enable = true;
            greeters.gtk.cursorTheme.size = cfg.greeterCursorsize;
          };
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
        #pulseaudio.enable = true;
        bluetooth.enable = true;
      };

      services.blueman.enable = true;

      environment.systemPackages = with pkgs; [
        firefox
        thunderbird # v102 has various starting time issues - so back to stable
        ungoogled-chromium
        okular
        texlive.combined.scheme-full
        usbutils
        keepassxc
        libsecret
        arandr
      ];

    };
}
