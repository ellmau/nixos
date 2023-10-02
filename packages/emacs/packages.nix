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
      version = "2021-10-06";
      src = pkgs.fetchFromGitHub {
        owner = "org-roam";
        repo = "org-roam-ui";
        rev = "bae6487afd5e6eec9f04b38b235bbac24042ca62";
        sha256 = "14dbdvxf1l0dwbhc0ap3wr3ffafy4cxmwc9b7gm0gzzmcxvszisc";
      };
      packageRequires = [f websocket org-roam simple-httpd];
      postInstall = ''
        cp -r out $out/share/emacs/site-lisp
      '';
    };

    ligatures = trivialBuild {
      pname = "ligatures";
      version = "unstable-2021-08-27";
      src = pkgs.fetchFromGitHub {
        owner = "mickeynp";
        repo = "ligature.el";
        rev = "d3426509cc5436a12484d91e48abd7b62429b7ef";
        sha256 = "baFDkfQLM2MYW2QhMpPnOMSfsLlcp9fO5xfyioZzOqg=";
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
