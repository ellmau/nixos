{ config, pkgs, lib, ... }:
with lib; {
  options.elss.graphical= {
    enable = mkEnableOption "configure i3-based graphical layer";
    greeterCursorsize = mkOption{
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
  };
  config = 
    let
      cfg = config.elss.graphical;
      #cursorsize = if config.variables.hostName == "nucturne" then 14 else 16;
      #xserverDPI = if config.variables.hostName == "stel-xps" then 180 else null;
    in
      {
        config.elss.users.x11.enable = true;
        networking.networkmanager.enable = true;

        services = {
          xserver = {
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
          pulseaudio.enable = true;
          bluetooth.enable = true;
        };
        
        services.blueman.enable = true;

        environment.systemPackages = with pkgs; [
          firefox
          thunderbird
          okular
          texlive.combined.scheme-full
          usbutils
          keepassxc
          gnome.libsecret
          arandr
        ];
      };
}
