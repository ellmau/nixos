{
  lib,
  pkgs,
  epkgs,
  ...
}: let
in
  with epkgs; rec {
    org-roam-ui = trivialBuild {
      pname = "org-roam-ui";
      version = "2022-10-05";
      src = pkgs.fetchFromGitHub {
        owner = "org-roam";
        repo = "org-roam-ui";
        rev = "5ac74960231db0bf7783c2ba7a19a60f582e91ab";
        sha256 = "dCoEQRi86eMerkMQPy3Ow/Kj9kzHxXRSrDk4cl8uLHo=";
      };
      packageRequires = [f websocket org-roam simple-httpd];
      postInstall = ''
        cp -r out $out/share/emacs/site-lisp
      '';
    };

    ligatures = trivialBuild {
      pname = "ligatures";
      version = "unstable-2023-09-01";
      src = pkgs.fetchFromGitHub {
        owner = "mickeynp";
        repo = "ligature.el";
        rev = "0e5d0a8554622bcb0ec634e364795650ff4f2457";
        sha256 = "vmUWt7HcdaaM/lmyKJgEEPn/6xh+75TzMckl8ohCjI4=";
      };
    };

    lean4-mode = trivialBuild {
      pname = "lean4-mode";
      version = "unstable-2023-07-14";
      src = pkgs.fetchFromGitHub {
        owner = "leanprover";
        repo = "lean4-mode";
        rev = "d1c936409ade7d93e67107243cbc0aa55cda7fd5";
        sha256 = "tD5Ysa24fMIS6ipFc50OjabZEUge4riSb7p4BR05ReQ=";
      };
      packageRequires = with epkgs.melpaPackages; [
        dash
        f
        flycheck
        lsp-mode
        magit
      ];
      postInstall = ''
        install -m=755 -D $src/data/abbreviations.json $out/share/emacs/site-lisp/data/abbreviations.json
      '';
    };
  }
