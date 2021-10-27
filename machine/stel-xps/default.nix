{ config, pkgs, ...}:
{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/dell/xps/13-7390"
    ./printer.nix
  ];
  networking.hostName = "stel-xps"; # define the hostname

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.autorandr.enable = true;
  services.xserver.desktopManager.wallpaper.mode = "fill";
}
