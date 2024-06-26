{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config.elss.wireguard = {
    interfaces = {
      stelnet = {
        servers = {
          metis = {
            localIp = "1";
            extraIps = ["1" "2" "142"];
            publicKey = "wP49t1TYXI3ucsYb8RavNGwIf+8nx5UBgDU0PM9VlnI=";
            endpoint = "metis.ellmauthaler.net:51820"; #TODO
          };
        };

        peers = {
          # TODO
          stel-xps = {
            localIp = "2";
            publicKey = "Wmw+gIvMdaAZ+m7Ruk60IZukW2TvMZxdT13xof9mazs=";
          };

          nucturne = {
            localIp = "3";
            publicKey = "DJ1U2EQLkqqapYXKZDgtS/b/xX7ACIHuFuH1sNpecnU=";
          };

          stelphone = {
            localIp = "142";
            publicKey = "UnS5BtlKKTXfNaSsw2PY7Gbd5aLGiJVlCUY7bHosLio=";
          };

          rhea = {
            localIp = "4";
            publicKey = "AxihqSB+Yr333Zjrkl0BpRFl2VbCHy4E9UOGz+0PTD0=";
          };

          keres = {
            localIp = "5";
            publicKey = "cDX5ggZVfoLEQLRVYVE5y0Thr7f8w2DY+/udxHXxrhY=";
          };
        };

        prefixes = {
          ipv4 = ["192.168.244"];
          ipv6 = {
            ula = ["fdaa:3313:9dfa:dfa3"]; # TODO
            gua = [];
          };
          serial = "2022073100";
        };
      };
    };
  };
}
