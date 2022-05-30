{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
    libreoffice-fresh
  ];

  programs = {
    java.enable = true;
  };

  services = {
    autorandr.enable = true;
  };

  elss = {
    programs = {
      aspell.enable = true;
      # Enable communication programs
      communication.enable = true;
      emacs.enable = true;
      obsstudio.enable = true;
      python.enable = true;
    };

    texlive.enable = true;
    steam-run.enable = true;
  };
}
