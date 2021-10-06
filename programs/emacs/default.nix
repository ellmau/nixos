{ config, lib, pkgs, ... }:

let
  defaultEl = ./default.el;

  # defaultConfig = pkgs.runCommand "default.el" { } ''
  #  mkdir -p $out/share/emacs/site-lisp
  #  cp ${defaultEl} $out/share/emacs/site-lisp/default.el
  #'';
  emacsPackage = (pkgs.emacsPackagesGen pkgs.emacs).emacsWithPackages
    (epkgs:
      let
        lpkgs = import ./packages.nix {
          inherit config lib pkgs epkgs;
        };
      in
      #[ (defaultConfig lpkgs) ] ++ (with pkgs; [
      #  aspell
      #  emacs-all-the-icons-fonts
      #  gnupg
      #  nixpkgs-fmt
      #])
      #[(defaultConfig)] ++
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
        dap-mode
        dockerfile-mode
        docker-compose-mode
        flycheck
        free-keys
        highlight-indentation
	      ivy
        json-mode
        less-css-mode
        lsp-mode
        lsp-ui
        magit
        moe-theme
        multiple-cursors
        nix-mode
        nixpkgs-fmt
        org-bullets
        org-roam
	      #org-roam-server
        pasp-mode
        pdf-tools
        projectile
        projectile-ripgrep
        rustic
	      spacemacs-theme
        solarized-theme
        sparql-mode
        sudo-edit
        use-package
        yaml-mode
        yasnippet
      ] ++ (with lpkgs; [org-roam-ui])));
in
{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = emacsPackage;
  };
  #nixpkgs.overlays = [ (self: super: { emacsOrig = super.emacs; }) (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #})) ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
}
