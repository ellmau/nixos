{ config, pkgs, ...}:
{
  environment.systempackages = with pkgs; [
    brightnessctl
  ];

  programs = {
    java.enable = true;
  };

  services = {
    autorandr.enable = true;
  };
}
