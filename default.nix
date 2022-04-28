{ flakes, flakeOutputs, ...}:
let
  mkMachine = args:
    let
      name = if builtins.isString args then args else args.name;
      system = if args ? system then args.system else "x86_64-linux";
      extraModules = if args ? extraModules then args.extraModules else [ ];
      extraOverlays = if args ? extraOverlays then args.extraOverlays else [ overlay-unstable ];
      pkgs = flakes.nixpkgs;
      configuration = if args ? configuration then args.configuration else import ./baseconfiguration.nix  {inherit extraOverlays system pkgs name flakes flakeOutputs;} ;
      overlay-unstable = final: prev: {
        unstable = import flakes.nixpkgs-unstable {
          system = "${system}";
          config.allowUnfree=true;
        };
      };
    in
      {
        inherit name;
        value = pkgs.lib.nixosSystem {
          inherit system;
          modules = [
            configuration
            { nix = {
                package = pkgs.legacyPackages.${system}.nixUnstable;
                nixPath= [ "nixpkgs=${pkgs}" ];
                registry.nixpkgs.flake = pkgs;
                registry.nixpkgs-unstable.flake = flakes.nixpkgs-unstable;
              }
              ;}
          ] ++ extraModules
          ++ flakes.nixpkgs.lib.mapAttrsToList (_: module: module)
            flakeOutputs.nixosModules;
        };
      };
in
flakes.nixpkgs.lib.listToAttrs (map mkMachine [
  {
    name = "stel-xps";
    extraModules = [ flakes.nixos-hardware.nixosModules.dell-xps-13-7390 flakes.home-manager.nixosModules.home-manager ];
  }
  {
    name = "nucturne";
    extraModules = [ flakes.home-manager.nixosModules.home-manager ];
  }
  {
    name = "ellmauthaler";
    extraModules = [ flakes.home-manager.nixosModules.home-manager flakes.simple-nixos-mailserver.nixosModule flakes.sops-nix.nixosModules.sops ];
  }
])
