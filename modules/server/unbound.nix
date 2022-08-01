{ config, lib, pkgs, ... }:
with lib; {
  config =
    let
      cfg = config.elss.server.unbound;
    in
    mkIf cfg.enable {
      services = {
        resolved = {
          enable = true;
          dnssec = "true";
          llmnr = "true";
          fallbackDns = [ "127.0.0.1" "::1" ];
          extraConfig = ''
            DNS = 127.0.0.1 ::1
            Domains = ~.
          '';
        };
        unbound = {
          enable = true;
          settings.server.interface = [ "127.0.0.0" "::1" ];
          settings.server.access-control = [ "192.168.244.0/24 allow" "fdaa:3313:9dfa:dfa3::/64 allow" ];
        };
        
      };
      networking = {
        nameservers = [ "127.0.0.1" "::1"];
        resolvconf.useLocalResolver = true;
      };
    };
}
