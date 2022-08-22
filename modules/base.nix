{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss = {
    base.enable = mkEnableOption "Set the base configuration for the system";
    dns = {
      wgZone = mkOption {
        type = types.str;
        description = "Zone for generated wireguard zones";
        default = "wg.ellmauthaler.net";
      };
    };
  };
  config = mkIf config.elss.base.enable {
    services = {
      dbus = {
        enable = true;
        packages = with pkgs; [dconf];
      };
    };

    programs = {
      mtr.enable = true;
      dconf.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    documentation = {
      enable = true;
      man.enable = true;
      dev.enable = true;
    };

    networking = {
      firewall.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alejandra
      alacritty.terminfo
      bintools
      clang
      elfutils
      emacs-all-the-icons-fonts
      gdb
      git
      htop
      neofetch
      nix-prefetch-github
      nixfmt
      nixpkgs-fmt
      procs
      ripgrep
      rnix-lsp
      sysstat
      tcpdump
      unzip
      wget
    ];

    elss = {
      locale.enable = mkDefault true;
      zsh.enable = mkDefault true;
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
