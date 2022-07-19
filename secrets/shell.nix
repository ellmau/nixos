{ pkgs ? import <nixpkgs> { }
, sops-nix ? pkgs.callPackage <sops-nix> { }
, ...
}:

let
  sops-rekey = pkgs.writeShellScriptBin "sops-rekey" ''
    ${pkgs.findutils}/bin/find . -wholename '*/secrets/*.yaml' -exec ${pkgs.sops}/bin/sops updatekeys {} \;
  '';
in
pkgs.mkShell {
  sopsPGPKeyDirs = [ ./keys/users ./keys/hosts ];

  nativeBuildInputs = [
    sops-nix.sops-import-keys-hook
    sops-nix.ssh-to-pgp
    sops-rekey
    pkgs.wireguard-tools
  ];
}
