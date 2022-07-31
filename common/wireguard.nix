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
            publicKey = "UnS5BtlKKTXfNaSsw2PY7Gbd5aLGiJVlCUY7bHosLio=";
          };
        };

        prefixes = {
          ipv4 = [ "192.168.244" ];
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
