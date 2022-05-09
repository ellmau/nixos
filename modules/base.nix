{ config, lib, pkgs, ...} :
with lib; {
  options.elss.base.enable = mkEnableOption "Set the base configuration for the system";
  config = mkIf config.elss.base.enable {
    services = {
      dbus = {
        enable = true;
        packages = with pkgs; [ gnome3.dconf ];
      };
    };

    programs = {
      mtr.enable = true;
      dconf.enable = true;
    };

    documentation = {
      enable = true;
      man.enable = true;
      dev.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alacritty.terminfo
      bintools
      clang
      elfutils
      emacs-all-the-icon-fonts
      gdb
      git
      procs
      rnis-lsp
      sysstat
      tcpdump
      unzip
      wget
    ];

    elss = {
      locale.enable = mkDefault true;
      zsh.enable = mkdDefault true;
    };

    boot = {
      loader = {
        systemd-boot.enable = mkDefault true;
        efi.canTouchEfiVariables = mkDefault true;
      };
      kernelPackages = mkDefault pkgs.linuxPackages_latest;
    };
  };
}
