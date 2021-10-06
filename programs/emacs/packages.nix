{ config, lib, pkgs, epkgs, ...}:
let
in
with epkgs; rec{
  org-roam-ui = trivialBuild{
    pname = "org-roam-ui";
    version = "2021-10-06";
    src = pkgs.fetchFromGitHub {
      owner = "org-roam";
      repo = "org-roam-ui";
      rev = "bae6487afd5e6eec9f04b38b235bbac24042ca62";
      sha256 = "14dbdvxf1l0dwbhc0ap3wr3ffafy4cxmwc9b7gm0gzzmcxvszisc";
    };
    packageRequires = [ f websocket org-roam simple-httpd ];
    postInstall = ''
      cp -r out $out/share/emacs/site-lisp
    '';  
  };
}
