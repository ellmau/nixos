{ config, pkgs, lib, ... }:
with lib; {
  options.elss.wireguard = {
    enable = mkEnableOption "Setup wireguard";
    interfaces = mkOption {
      default = { };
      type = types.attrsOf
        (types.submodule {
          options = {
            servers = mkOption {
              type = types.attrsOf (types.submodule {
                options = {
                  localIP = mkOption {
                    type = types.str;
                    description = "local IP for the interface";
                  };
                  port = mkOption {
                    type = types.port;
                    description = "Port to use";
                    default = 51820;
                  };

                  publickey = mkOption {
                    type = types.str;
                    description = "Wireguard public key for the server";
                  };
                };
              });
            };

            peers = mkOption {
              type = types.attrsOf (types.submodule {
                options = {
                  localIp = mkOption {
                    type = types.str;
                    description = "local IP for the peer";
                  };
                  publickey = mkOption {
                    type = types.str;
                    description = "Wireguard public key for the peer";
                  };

                  setup = mkOption {
                    type = types.enum [
                      "none"
                      "key"
                      "wg"
                      "nm"
                    ];
                    description = "How to setup this peer. none does nothing, key only exports the secret, wg sets up wireguard for local cloud and nm adds a tunnel option";
                  };
                };
              });
            };

            prefix = {
              ipv4 = mkOption {
                type = types.str;
                description = "IPv4 prefix for wireguard address room";
              };
            };
          };
        });
    };
  };
  config =
    let
      cfg = config.elss;
      hostName = config.system.name;
      secrets = ../machines
        + builtins.toPath "/${hostName}/secrets/wireguard.yaml";
      mkRemoveEmpty = lib.filter (interface: interface != "");
      mkInterfaces = input: mkRemoveEmpty
        ((expr:
          lib.mapAttrsToList
            (interface: value: if (expr interface value) then interface else "")
            cfg.wireguard.interfaces)
          input);
      mkPeerInterface = mkInterfaces (interface: value: builtins.hasAttr hostName value.peers);
      mkServInterface = mkInterfaces (interface: value: builtins.hasAttr hostName value.servers);
      interfaces = mkServInterface ++ mkPeerInterface;

      mkInterfacename = interface: "wg-${interface}";
      mkInterfaceSops = interface: {
        "wireguard-${interface}" = { sopsFile = secrets; };
      };
    in
    mkIf cfg.wireguard.enable {
      sops.secrets = lib.mkMerge (map mkInterfaceSops interfaces);
    };
}
