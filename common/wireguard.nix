{ config, pkgs, lib, ... }:
with lib; {
  config.elss.wireguard.interfaces = {
    sellnet = {
      # cough @ name
      servers = {
        metis = {
          localIP = "1";
          publicKey = "bla";
        };
      };
      peers = { };
    };
  };
}
