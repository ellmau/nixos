{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.grocy;
  in
    mkIf cfg.enable {
      services.grocy = {
        enable = true;
        hostname = "grocy.ellmauthaler.net";
        settings = {
          currency = "EUR";
          culture = "de";
          calendar = {
            showWeekNumber = true;
            firstDayOfWeek = 1;
          };
        };
      };
    };
}
