{
  lib,
  pkgs,
  ...
}:
with lib; let
  defaultEl = ./default.el;
  #environment.systemPackages = [pkgs.gdb]; # use gdb for dap-mode
  localsettings =
    if pkgs.system == "x86_64-linux"
    then
      pkgs.writeText "local-settings.el" ''
        (defconst elss/paths/cpptools "    ${pkgs.unstable.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools")
        (defconst elss/paths/cpptools-program "${pkgs.unstable.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7")
         (provide 'local-settings)
      ''
    else
      pkgs.writeText "local-settings.el" ''
        (provide 'local-settings)
      '';

  defaultConfig = pkgs.runCommand "default.el" {} ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${defaultEl} $out/share/emacs/site-lisp/default.el
    cp ${localsettings} $out/share/emacs/site-lisp/local-settings.el
  '';
  overrides = self: super: {
    elpaPackages =
      super.elpaPackages
      // {
        seq = self.callPackage ({
          elpaBuild,
          fetchurl,
          lib,
        }:
          elpaBuild rec {
            pname = "seq";
            ename = "seq";
            version = "2.24";
            src = fetchurl {
              url = "https://elpa.gnu.org/packages/seq-2.24.tar";
              sha256 = "1w2cysad3qwnzdabhq9xipbslsjm528fcxkwnslhlkh8v07karml";
            };
            packageRequires = [];
            meta = {
              homepage = "https://elpa.gnu.org/packages/seq.html";
              license = lib.licenses.free;
            };
            # tests take a _long_ time to byte-compile, skip them
            postInstall = ''rm -r $out/share/emacs/site-lisp/elpa/${pname}-${version}/tests'';
          }) {};
      };
  };

  emacsPackage = (pkgs.emacsPackagesFor pkgs.emacs29).emacsWithPackages (epkgs: let
    lpkgs = import ./packages.nix {inherit lib pkgs epkgs;};
    #[ (defaultConfig lpkgs) ] ++ (with pkgs; [
    #  aspell
    #  emacs-all-the-icons-fonts
    #  gnupg
    #  nixpkgs-fmt
    #])
  in
    [defaultConfig]
    ++ [(with epkgs.elpaPackages; [auctex org flymake seq])]
    ++ (with epkgs.melpaStablePackages; [])
    ++ (with epkgs.melpaPackages;
      [
        ac-helm
        academic-phrases
        add-hooks
        alert
        all-the-icons
        all-the-icons-dired
        apheleia
        beacon
        bln-mode
        cargo-mode
        company
        company-auctex
        company-bibtex
        company-flx
        company-quickhelp
        company-reftex
        cov
        dap-mode
        diminish
        direnv
        dockerfile-mode
        docker-compose-mode
        flycheck
        free-keys
        haskell-mode
        highlight-indentation
        helm
        helm-bbdb
        helm-company
        helm-flx
        helm-descbinds
        helm-lsp
        helm-projectile
        helm-rg
        json-mode
        less-css-mode
        lsp-haskell
        lsp-mode
        lsp-ui
        magit
        markdown-mode
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
        #use-package
        #vscode-dark-plus-theme
        yaml-mode
        yasnippet
        #zenburn-theme
      ]
      ++ (with lpkgs; [org-roam-ui ligatures lean4-mode])));
in
  emacsPackage
#nixpkgs.overlays = [ (self: super: { emacsOrig = super.emacs; }) (import (builtins.fetchTarball {
#    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#})) ];
#nixpkgs.overlays = [
#  (import (builtins.fetchTarball {
#    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
#  }))
#];
