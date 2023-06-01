{
  pkgs ? import <nixpkgs> {},
  sops-nix ? pkgs.callPackage <sops-nix> {},
  name ? "secrets",
  ...
}: let
  sops-rekey = pkgs.writeShellScriptBin "sops-rekey" ''
    ${pkgs.findutils}/bin/find . -wholename '*/secrets/*.yaml' -exec ${pkgs.sops}/bin/sops updatekeys {} \;
  '';
in
  pkgs.mkShell {
    sopsPGPKeyDirs = [./keys/users ./keys/hosts];
    name = name;
    nativeBuildInputs = [
      sops-nix.sops-import-keys-hook
      sops-nix.ssh-to-pgp
      sops-rekey
      pkgs.wireguard-tools
    ];
  }
