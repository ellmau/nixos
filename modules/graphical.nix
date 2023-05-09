{
  config,
  pkgs,
  lib,
  ...
}:
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
    xserver.enable = mkEnableOption "enable X server";
    xmonad = {
      enable = mkEnableOption "enable xmonad";
      polybar.enable = mkEnableOption "enable Polybar for xmonad";
    };
    i3.enable = mkEnableOption "enable i3";
  };
  config = let
    cfg = config.elss.graphical;
    #cursorsize = if config.variables.hostName == "nucturne" then 14 else 16;
    #xserverDPI = if config.variables.hostName == "stel-xps" then 180 else null;

    okular-x11 = pkgs.symlinkJoin {
      name = "okular";
      paths = [pkgs.okular];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/okular \
        --set QT_QPA_PLATFORM xcb
      '';
    };
  in
    mkIf cfg.enable {
      #      cfg.xserver.enable = cfg.i3.enable;
      elss.users.x11.enable = cfg.xserver.enable || cfg.xmonad.enable;

      elss.networking.useNetworkManager = true;

      services = {
        xserver = mkIf cfg.xserver.enable {
          enable = true;
          dpi = cfg.dpi;
          displayManager.lightdm = {
            enable = true;
            greeters.gtk.cursorTheme.size = cfg.greeterCursorsize;
          };
          windowManager.i3 = mkIf cfg.i3.enable {
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

      security.pam.services.lightdm.enableGnomeKeyring = true;

      services.blueman.enable = true;

      environment.systemPackages = with pkgs; [
        ungoogled-chromium
        # force okular to use xwayland, because of https://github.com/swaywm/sway/issues/4973
        okular-x11
        texlive.combined.scheme-full
        usbutils
        keepassxc
        libsecret
      ];
    };
}
