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
                };
              });
            };

            prefix = {
              ipv4 = mkOption {
                type = types.str;
                description = "IPv4 prefix for wireguard address room";
              };
            };

            port = mkOption {
              type = types.port;
              description = "Port to use";
              default = 51820;
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

      mkInterfaceName = interface: "wg-${interface}";
      mkInterfaceSops = interface: {
        "wireguard-${interface}" = { sopsFile = secrets; };
      };

      mkConfig = hostName: interface: value:
        let
          isServer = builtins.hasAttr hostName value.servers;
          isPeer = builtins.hasAttr hostName value.peers;
          curConf =
            if isServer then
              value.servers."${hostName}"
            else
              value.peers."${hostName}";
        in
        assert lib.asserts.assertMsg
          ((isServer || isPeer) && !(isServer && isPeer))
          "host must be either server or peer";
        lib.nameValuepair (mkInterfaceName interface) (
          {
            privateKeyFile = sops.secrets."wireguard-${interface}".path;
            listenPort = value.listenPort;
          } // (if isServer then { } else if isPeer then {
          }
          else
            { })
        );
    in
    mkIf cfg.wireguard.enable {
      sops.secrets = lib.mkMerge (map mkInterfaceSops interfaces);
    };
}
