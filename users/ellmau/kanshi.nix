{ config, pkgs, ...}:
{
  services.kanshi = {
    enable = true;
    profiles = {
      work = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2720Q 1DNY123";
            position = "1920,0";
          }
          {
            criteria = "eDP-1";
            position = "5760,0";
          }
        ];
      };
      unplugged = {
        outputs = [
          {
            criteria = "eDP-1";
          }
        ];
      };
    };
  };
}
