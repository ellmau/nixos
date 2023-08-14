{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical.xserver;
    fehArgs = "--bg-fill --no-fehbg";
  in
    mkIf cfg.enable {
      systemd.user = {
        services = {
          desktop-background = {
            Unit = {
              Description = "Set desktop background";
              Documentation = ["man:feh(1)"];
              After = ["graphical-session-pre.target"];
              ParOf = ["graphical-session.target"];
            };

            Service = {
              type = "oneshot";
              ExecStart = "${pkgs.feh}/bin/feh ${fehArgs} ${config.xdg.configHome}/background.png";
            };

            Install = {WantedBy = ["graphical-session.target"];};
          };
        };
      };
    };
}
