{ config, pkgs, lib, ... }:
with lib; {
  config.elss.wireguard.interfaces = {
    ellmaunet = {
      # cough @ name
      servers = {
        metis = {
          localIP = "1";
          publicKey = "bla";
        };
      };
      peers = { };

      prefix = {
        ipv4 = "192.168.242.";
      };
    };
  };
}
