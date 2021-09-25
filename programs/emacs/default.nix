{ config, lib, pkgs, ... }:

let
  defaultEl = ./default.el;

  defaultConfig = pkgs.runCommand "default.el" { } ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${defaultEl} $out/share/emacs/site-lisp/default.el
  '';

  emacsPackage = (pkgs.emacsPackagesGen pkgs.emacsUnstable).emacsWithPackages
    (epkgs:
      #let
      #  lpkgs = import ./packages.nix {
      #    inherit config lib pkgs epkgs;
      #  };
      #in
      #[ (defaultConfig lpkgs) ] ++ (with pkgs; [
      #  aspell
      #  emacs-all-the-icons-fonts
      #  gnupg
      #  nixpkgs-fmt
      #])
      [(with epkgs.elpaPackages; [
        auctex
	org
        flymake
      ])]
      ++ (with epkgs.melpaStablePackages; [ ]) ++ (with epkgs.melpaPackages; [
        academic-phrases
        add-hooks
        alert
        all-the-icons
        all-the-icons-dired
        beacon
        bln-mode
        cargo-mode
        company
        company-auctex
        company-bibtex
        company-flx
        company-quickhelp
        company-reftex
        dockerfile-mode
        docker-compose-mode
        flycheck
        free-keys
        highlight-indentation
	ivy
        json-mode
        less-css-mode
        lsp-mode
        magit
        multiple-cursors
        nix-mode
        nixpkgs-fmt
        org-bullets
        org-pdftools
        org-roam
        pasp-mode
        pdf-tools
        projectile
        projectile-ripgrep
        rustic
	spacemacs-theme
        sparql-mode
        use-package
        yaml-mode
      ]));
in
{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = emacsPackage;
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
}