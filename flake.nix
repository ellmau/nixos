{
  description = "Flake to define configurations of 'elss' - ellmauthaler stefan's systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    #nix = {
    #      url = "github:NixOS/nix?ref=latest-release";
    #  url = "github:NixOS/nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/release-2.93.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {url = "github:NixOS/nixos-hardware/master";};

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus = {url = "github:gytis-ivaskevicius/flake-utils-plus";};

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma = {
      url = "github:nix-community/comma";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        utils.follows = "flake-utils-plus/flake-utils";
      };
    };

    glpi-inventory = {
      url = "github:mmarx/glpi-inventory";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils-plus";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils-plus,
    ...
  } @ inputs: let
    extended-lib =
      nixpkgs.lib.extend
      (final: prev: {elss = (import ./lib {lib = final;}) prev;});
    inherit
      (extended-lib.elss)
      discoverModules
      moduleNames
      discoverMachines
      withModules
      discoverTemplates
      discoverOverlay
      ;
    inherit (flake-utils-plus.lib) genPkgOverlay;
  in
    flake-utils-plus.lib.mkFlake rec {
      inherit self inputs;
      supportedSystems = ["x86_64-linux" "aarch64-darwin"];

      lib = extended-lib;

      channelsConfig = {
        allowUnfreePredicate = pkg:
          builtins.elem (extended-lib.getName pkg) [
            "aspell-dict-en-science"
            "discord"
            "slack"
            "steam"
            "steam-original"
            "steam-run"
            "steam-runtime"
            "steam-unwrapped"
            "teams"
            "vscode-extension-ms-vscode-cpptools"
            "zoom"
          ];
      };

      channels.nixpkgs.overlaysBuilder = channels:
        [
          (final: prev: {unstable = channels.nixpkgs-unstable;})
          (flake-utils-plus.lib.genPkgOverlay inputs.comma "comma")
          #inputs.nix.overlay
          inputs.emacs-overlay.overlay
          inputs.glpi-inventory.overlays.default
        ]
        ++ (nixpkgs.lib.attrValues overlays);

      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        modules =
          [
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
            inputs.simple-nixos-mailserver.nixosModules.mailserver
            ./common/wireguard.nix
            inputs.glpi-inventory.nixosModules.glpi-inventory
            inputs.lix-module.nixosModules.default
          ]
          ++ (map (name: ./modules + "/${name}") (moduleNames ./modules));
        specialArgs = {
          nixos-hardware = inputs.nixos-hardware.nixosModules;
          inherit inputs;
        };
        extraArgs = {
          homeConfigurations = withModules ./users ({
              name,
              path,
            }:
            #import (./users + "/${name}")
              import path);
        };
      };

      hosts =
        discoverMachines ./machines {specialArgs = {lib = extended-lib;};};

      nixosModules = discoverModules ./modules;

      homeConfigurations = withModules ./users (name: let
        username = extended-lib.removeSuffix ".nix" name;
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          configuration = import (./users + "/${name}");
          inherit username;
          system = "x86_64-linux";
          homeDirectory = "/home/${username}";
          stateVersion = extended-lib.mkDefault "21.05";
        });

      overlays = rec {
        elss = discoverOverlay ./packages;
        default = elss;
        emacs-overlay = inputs.emacs-overlay.overlay;
        flake-utils-plus = genPkgOverlay inputs.flake-utils-plus "fup-repl";
        glpi-inventory = inputs.glpi-inventory.overlays.default;
      };

      outputsBuilder = channels: {
        devShells = let
          pkgs = channels.nixpkgs;
        in rec {
          sops = import ./secrets/shell.nix {
            pkgs = channels.nixpkgs;
            sops-nix = inputs.sops-nix.packages."${channels.nixpkgs.system}";
            name = "sops";
          };

          xmonad = pkgs.mkShell {
            name = "xmonad";
            nativeBuildInputs = [
              # add packages here, like
              # pkgs.clingo
              (pkgs.ghc.withPackages (haskellPackages: [
                haskellPackages.dbus
                haskellPackages.monad-logger
                haskellPackages.hostname
                haskellPackages.xmonad
                haskellPackages.xmonad-contrib
              ]))
              pkgs.haskell-language-server
            ];
          };

          default = sops;
        };
        formatter = channels.nixpkgs.alejandra;
        packages =
          (flake-utils-plus.lib.exportPackages {
              inherit
                (overlays)
                default
                flake-utils-plus
                ;
            }
            channels)
          // {inherit (channels.nixpkgs) emacs;};
      };

      templates = discoverTemplates ./templates {
        base = {
          description = "Basic setup of tools in nixpkgs/unstable";
          welcomeText = "Change into the folder and add the wanted packages to the buildInputs";
        };

        rust = {
          description = "Rust development environment flake";
          welcomeText = "Change into the folder and follow the prompt to create an automatic rust environment in this folder";
        };
        jupyter = {
          description = "Jupyter server flake";
          welcomeText = "Use `nix run .` to run a jupyter server instance.";
        };
      };
    };
}
