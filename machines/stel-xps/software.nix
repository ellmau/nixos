{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  programs = {
    java.enable = true;
  };

  services = {
    autorandr.enable = true;
  };
}
