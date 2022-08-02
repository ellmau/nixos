{ config, lib, pkgs, ... }:

{
  options.elss.wireguard = with lib; {
    enable = mkEnableOption "wireguard overlay network";

    interfaces = mkOption {
      default = { };
      type = types.attrsOf (types.submodule {
        options = {
          servers = mkOption {
            type = types.attrsOf (types.submodule {
              options = {
                localIp = mkOption {
                  type = types.str;
                  description = "local IP part for the interfaces";
                };

                extraIps = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = "extra IPs to add to allowedIPs";
                };

                listenPort = mkOption {
                  type = types.port;
                  description = "Port to listen on";
                  default = 51820;
                };

                publicKey = mkOption {
                  type = types.str;
                  description = "Wireguard public key for this peer";
                };

                endpoint = mkOption {
                  type = types.str;
                  description = "Wireguard endpoint for this peer.";
                };
              };
            });
          };

          peers = mkOption {
            type = types.attrsOf (types.submodule {
              options = {
                localIp = mkOption {
                  type = types.str;
                  description = "local IP part for the interfaces";
                };

                listenPort = mkOption {
                  type = types.port;
                  description = "Port to listen on";
                  default = 51820;
                };

                publicKey = mkOption {
                  type = types.str;
                  description = "Wireguard public key for this peer";
                };

                additionalAllowedIps = mkOption {
                  type = types.listOf types.str;
                  description = "Additional IPs to add to allowedIPs ";
                  default = [ ];
                };
              };
            });
          };

          prefixes = {
            ipv4 = mkOption {
              type = types.listOf types.str;
              description = "IPv4 prefixes to use for wireguard addressing";
            };

            ipv6 = {
              ula = mkOption {
                type = types.listOf types.str;
                description =
                  "IPv6 prefixes to use for ULA wireguard addressing";
              };

              gua = mkOption {
                type = types.listOf types.str;
                description =
                  "IPv6 prefixes to use for GUA wireguard addressing";
              };
            };

            serial = mkOption {
              type = types.str;
              description = "serial for the generated DNS zone";
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
      secretsFile = ../machines
        + builtins.toPath "/${hostName}/secrets/wireguard.yaml";
      takeNonEmpty = lib.filter (interface: interface != "");
      testInterface = predicate:
        lib.mapAttrsToList
          (interface: value: if (predicate interface value) then interface else "")
          cfg.wireguard.interfaces;
      onlyInterfaces = predicate: takeNonEmpty (testInterface predicate);
      peerInterfaces =
        onlyInterfaces (interface: value: builtins.hasAttr hostName value.peers);
      serverInterfaces = onlyInterfaces
        (interface: value: builtins.hasAttr hostName value.servers);
      interfaces = serverInterfaces ++ peerInterfaces;

      mkAddresses = prefixes: localIp:
        (map (prefix: "${prefix}.${localIp}/32") prefixes.ipv4)
        ++ (map (prefix: "${prefix}::${localIp}/128") prefixes.ipv6.ula)
        ++ (map (prefix: "${prefix}::${localIp}/128") prefixes.ipv6.gua);

      mkServerAddresses = prefixes: serverIp:
        (map (prefix: "${prefix}.${serverIp}") prefixes.ipv4)
        ++ (map (prefix: "${prefix}::${serverIp}") prefixes.ipv6.ula)
        ++ (map (prefix: "${prefix}::${serverIp}") prefixes.ipv6.gua);

      mkInterfaceName = interface: "wg-${interface}";

      mkServerPeer = prefixes: peer: {
        allowedIPs = mkAddresses prefixes peer.localIp;
        inherit (peer) publicKey;
      };

      mkPeerPeer = prefixes: peers: peer: {
        allowedIPs = (mkAddresses prefixes peer.localIp)
          ++ (lib.concatMap (mkAddresses prefixes) peer.extraIps) ++ (if lib.hasAttr hostName peers then peers.${hostName}.additionalAllowedIps else [ ]);
        persistentKeepalive = 25;
        inherit (peer) publicKey endpoint;
      };

      mkPostSetup = name: prefixes: servers:
        let
          ifName = mkInterfaceName name;
          serverIps = name: server: mkServerAddresses prefixes server.localIp;
          dnsServers = lib.concatLists (lib.mapAttrsToList serverIps servers);
        in
        lib.concatStrings ([
          # will be needed for nsd
          # ''
          #   ${pkgs.systemd}/bin/resolvectl domain ${ifName} ${name}.${config.elss.dns.wgZone}
          #   ${pkgs.systemd}/bin/resolvectl default-route ${ifName} true
          # ''
          ''
            ${pkgs.systemd}/bin/resolvectl default-route ${ifName} true
          ''
        ] ++ (map
          (ip: ''
            ${pkgs.systemd}/bin/resolvectl dns ${ifName} ${ip}
          '')
          dnsServers));

      mkInterfaceConfig = hostName: interface: value:
        let
          isServer = builtins.hasAttr hostName value.servers;
          isPeer = builtins.hasAttr hostName value.peers;
          myConfig =
            if isServer then
              value.servers."${hostName}"
            else
              value.peers."${hostName}";
        in
        assert lib.asserts.assertMsg
          ((isServer || isPeer) && !(isServer && isPeer))
          "host must be either server or peer";
        lib.nameValuePair (mkInterfaceName interface) ({
          privateKeyFile = config.sops.secrets."wireguard-${interface}".path;
          ips = mkAddresses value.prefixes myConfig.localIp;
          inherit (myConfig) listenPort;
        } // (if isServer then {
          peers = lib.mapAttrsToList (_: mkServerPeer value.prefixes) value.peers;
        } else if isPeer then {
          peers = lib.mapAttrsToList (_: mkPeerPeer value.prefixes value.peers) value.servers;
          postSetup = mkPostSetup interface value.prefixes value.servers;
        } else
          { }));

      mkInterfaceSecret = interface: {
        "wireguard-${interface}" = { sopsFile = secretsFile; };
      };

      mkListenPorts = hostName: interface: value:
        if builtins.hasAttr hostName value.servers then
          value.servers."${hostName}".listenPort
        else if builtins.hasAttr hostName value.peers then
          value.peers."${hostName}".listenPort
        else
          -1;

      mkSysctl = hostName: interface: [
        {
          name = "net.ipv4.conf.${mkInterfaceName interface}.forwarding";
          value = "1";
        }
        {
          name = "net.ipv6.conf.${mkInterfaceName interface}.forwarding";
          value = "1";
        }
        {
          name = "net.ipv6.conf.all.forwarding";
          value = "1";
        }
      ];

    in
    lib.mkIf cfg.wireguard.enable {
      networking = {
        wireguard.interfaces =
          lib.mapAttrs' (mkInterfaceConfig hostName) cfg.wireguard.interfaces;
        firewall = {
          # allowedUDPPorts = lib.filter (port: port > 0)
          #   (lib.mapAttrsToList (mkListenPorts hostName) cfg.wireguard.interfaces);
          allowedUDPPorts = lib.filter (port: port > 0) (map
            (interface:
              lib.attrByPath [ interface "servers" hostName "listenPort" ] (-1)
                cfg.wireguard.interfaces)
            serverInterfaces);
          trustedInterfaces = map mkInterfaceName interfaces;
        };
        interfaces = lib.listToAttrs (map
          (interface: {
            name = mkInterfaceName interface;
            value = { mtu = 1300; };
          })
          interfaces);
      };

      services.unbound.settings.server.interface = map mkInterfaceName serverInterfaces;
      systemd.services = lib.listToAttrs (map
        (interface: {
          name = "wireguard-${mkInterfaceName interface}";
          value = { serviceConfig.Restart = "on-failure"; };
        })
        interfaces);


      boot.kernel.sysctl =
        builtins.listToAttrs (lib.concatMap (mkSysctl hostName) serverInterfaces);

      sops.secrets = lib.mkMerge (map mkInterfaceSecret interfaces);
    };
}
