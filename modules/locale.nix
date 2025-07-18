{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.elss.locale.enable = mkEnableOption "setup default locale and font-handling";

  config = mkIf config.elss.locale.enable {
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_GB.UTF-8";

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
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
        nerd-fonts.hasklug
        material-icons
        weather-icons
        xits-math
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
  };
}
