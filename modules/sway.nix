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
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
        ];
        gtkUsePortal = true;
      };

      # enable sway window manager
      programs = {
        sway = {
          enable = true;
          extraPackages = with pkgs; [
            rofi
            swaylock
            swayidle
            waybar
          ];
          wrapperFeatures = {
            base = true;
            gtk = true;
          };
        };

        nm-applet = {
          enable = true;
          indicator = true;
        };
      };

      # greetd login manager
      services.greetd = {
        enable = true;
        package = pkgs.greetd.tuigreet;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway; swaymsg exit";
          };
        };
      };

      security.pam.services.greetd = {
        enableGnomeKeyring = true;
        gnupg.enable = true;
      };

      environment.systemPackages = with pkgs; [
        gnome3.adwaita-icon-theme
        wl-clipboard
        networkmanagerapplet
        pavucontrol
        pamixer
      ];
    };
}
