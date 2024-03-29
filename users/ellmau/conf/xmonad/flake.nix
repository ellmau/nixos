{
  description = "basic tool setup flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    flake-utils,
    flake-utils-plus,
    ...
  } @ inputs:
    {}
    // (flake-utils.lib.eachDefaultSystem (
      system: let
        unstable = import nixpkgs-unstable {
          inherit system;
        };
        pkgs = import nixpkgs {
          inherit system;
        };
      in rec {
        devShell = pkgs.mkShell {
          name = "xmonad";
          nativeBuildInputs = [
            # add packages here, like
            # pkgs.clingo
            (pkgs.ghc.withPackages
              (haskellPackages: [
                haskellPackages.dbus
                haskellPackages.monad-logger
                haskellPackages.hostname
                haskellPackages.xmonad
                haskellPackages.xmonad-contrib
              ]))
            pkgs.haskell-language-server
          ];
        };
      }
    ));
}
