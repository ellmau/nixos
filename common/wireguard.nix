{ config, pkgs, lib, ... }:
with lib; {
  config.elss.wireguard = {

    interfaces = {
      stelnet = {
        servers = {
          metis = {
            localIp = "1";
            extraIps = [ "142" ];
            publicKey = "wP49t1TYXI3ucsYb8RavNGwIf+8nx5UBgDU0PM9VlnI=";
            endpoint = "metis.ellmauthaler.net:51820"; #TODO
          };
        };

        peers = { # TODO
          stelphone = {
            localIp = "142";
            publicKey = "6ZwilfrS1J/dMYRnwIMcQ3cW0KtJdLRj5VnSOjwOpn8=";
          };
        };

        prefixes = {
          ipv4 = [ ]; # TODO
          ipv6 = {
            ula = [ ]; # TODO
            gua = [ ];
          };
          serial = "2022073100";
        };
      };
    };
  };
}
