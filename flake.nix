{
  description = "Configuration for stuff";

  inputs = {
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
    };
  };

  outputs = {self, ...}@inputs: 
    let outputs = rec {
          overlay = import ./local-overlay;
          nixosConfigurations = import self {
            flakes = inputs;
            flakeOutputs = outputs;
          };
          nixosModules = {};
        };
    in outputs;
}
