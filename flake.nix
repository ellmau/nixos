{
  description = "Flake to define configurations of 'elss' - ellmauthaler stefan's systems";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix = {
      url = "github:NixOS/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-21.11";

    sops-nix = {
      url = "github:Mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwarffs = {
      url = "github:edolstra/dwarffs";
      inputs = {
        nix.follows = "nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    comma = {
      url = "github:nix-community/comma";
      # TODO: change to nixpkgs when updating to NixOS-22.05;
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        utils.follows = "flake-utils-plus/flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs:
    let
      extended-lib = nixpkgs.lib.extend
        (final: prev: {
          elss = (import ./lib { lib = final; }) prev;
        });
      inherit (extended-lib.elss) discoverModules moduleNames;
    in
    flake-utils-plus.lib.mkFlake rec{
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];

      lib = extended-lib;

      channelsConfig = {
        allowUnfreePredicate = pkg: builtins.elem (extended-lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-runtime"
          "skypeforlinux"
          "teams"
          "zoom"
        ];
      };

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {
          unstable = channels.nixpkgs-unstable;
        })
        (flake-utils-plus.lib.genPkgOverlay inputs.comma "comma")
        inputs.nix.overlay
        inputs.emacs-overlay.overlay
      ];

      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.dwarffs.nixosModules.dwarffs
        ] ++ (map (name: ./modules + "/${name}") (moduleNames ./modules));
        specialArgs = {
          nixos-hardware = inputs.nixos-hardware.nixosModules;
          inherit inputs;
        };
        extraArgs = {
          homeConfigurations = discoverModules ./users
            (name:
              import (./users + "/${name}")
            );
        };
      };

      hosts = discoverModules ./machines (name: {
        modules = [ (./machines + "/${name}") ];
        specialArgs = { lib = extended-lib; };
      });

      homeConfigurations = discoverModules ./users
        (name:
          let
            username = extended-lib.removeSuffix ".nix" name;
          in
          inputs.home-manager.lib.homeManagerConfiguration {
            configuration = import (./users + "/${name}");
            inherit username;
            system = "x86_64-linux";
            homeDirectory = "/home/${username}";
            stateVersion = "21.05";
          });
    };
}
