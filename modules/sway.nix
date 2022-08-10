{ config, pkgs, lib, ... }:
with lib; {
  options.elss.graphical.sway.enable = mkEnableOption "Use sway";
  config =
    let
      cfg = config.elss.graphical.sway;
    in
      mkIf cfg.enable {
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
        };

        # xdg-desktop-portal works by exposing a series of D-Bus interfaces
        # known as portals under a well-known name
        # (org.freedesktop.portal.Desktop) and object path
        # (/org/freedesktop/portal/desktop).
        # The portal interfaces include APIs for file access, opening URIs,
        # printing and others.
        services.dbus.enable = true;
        xdg.portal = {
          enable = true;
          wlr.enable = true;
          # gtk portal needed to make gtk apps happy
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          gtkUsePortal = true;
        };

        # enable sway window manager
        programs.sway = {
          enable = true;
          wrapperFeatures.gtk = true;
        };

        # greetd login manager
        services.greetd = {
          enable = true;
          package = pkgs.greetd.tuigreet;
          settings = {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
            };
          };
        };

        environment.systemPackages = with pkgs; [
          rofi
        ];
      };
}
