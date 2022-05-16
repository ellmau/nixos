{ pkgs, ... }:
{
  home-manager.users.ellmau = {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
