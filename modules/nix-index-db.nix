{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.elss.nix-index-db-update.enable =
    mkEnableOption "periodically update the nix-index database";

  config = let
    cfg = config.elss.nix-index-db-update;
    nix-index-db-update = pkgs.writeShellScript "nix-index-db-update" ''
      set -euo pipefail

      filename="index-x86_64-$(${pkgs.coreutils}/bin/uname | ${pkgs.coreutils}/bin/tr A-Z a-z)"
      cd /var/db/nix-index/
      ${pkgs.wget}/bin/wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
      ${pkgs.coreutils}/bin/ln -f $filename files
    '';
    inherit (lib.elss.withConfig config) mapAllUsers;
  in
    mkIf cfg.enable {
      systemd = {
        services.nix-index-db-update = {
          description = "Update nix-index database";

          serviceConfig = {
            CPUSchedulingPolicy = "idle";
            IOSchedulingClass = "idle";
            ExecStartPre = [
              "+${pkgs.coreutils}/bin/mkdir -p /var/db/nix-index/"
              "+${pkgs.coreutils}/bin/chown nobody:nogroup /var/db/nix-index/"
            ];
            ExecStart = toString nix-index-db-update;
            User = "nobody";
            Group = "nogroup";
          };
        };

        timers.nix-index-db-update = {
          description = "nix-index database periodic update";

          timerConfig = {
            Unit = "nix-index-db-update.service";
            OnCalendar = "daily";
            Persistent = true;
          };

          wantedBy = ["timers.target"];
        };
      };

      home-manager.users = mapAllUsers (_: {config, ...}: {
        home.file.".cache/nix-index".source =
          config.lib.file.mkOutOfStoreSymlink "/var/db/nix-index/";
      });
    };
}
