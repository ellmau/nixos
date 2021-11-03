{ flakes, flakeOutputs, ...}:
  let
    mkMachine = args:
    let
      name = if builtins.isString args then args else args.name;
      system = if args ? system then args.system else "x86_64-linux";
      extraModules = if args ? extraModules then args.extraModules else [ ];
      extraOverlays = if args ? extraOverlays then args.extraOverlays else [ ];
      pkgs = flakes.nixpkgs;
      configuration = import ./configuration.nix  {inherit extraOverlays system pkgs name flakes;} ;
    in
    {
      inherit name;
      value = pkgs.lib.nixosSystem {
        inherit system;
        modules = [
          configuration
          { nix.package = pkgs.legacyPackages.${system}.nixUnstable; }
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
])
