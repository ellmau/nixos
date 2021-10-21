{ pkgs ? import <nixpkgs> {} }:

let
  ellmauEmacs = (import <nixpkgs> {}).emacs;
  emacsWithPackages = (pkgs.emacsPackagesGen ellmauEmacs).emacsWithPackages;
in
  emacsWithPackages ( epkgs: (with epkgs.melpaStablePackages; [
    beacon
  ]) ++ (with epkgs.melpaPackages; [
    magit
    nix-mode
    ewal-spacemacs-themes
    org-roam
    rustic
    company
    projectile
    lsp-mode
    dap-mode
  ]) ++ (with epkgs.elpaPackages; [
    auctex
  ]) ++ [
  ])