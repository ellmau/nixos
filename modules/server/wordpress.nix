{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = let
    cfg = config.elss.server.wordpress;
    fetchPackage = {
      name,
      version,
      hash,
      isTheme,
    }:
      pkgs.stdenv.mkDerivation rec {
        inherit name version hash;
        src = let
          type =
            if isTheme
            then "theme"
            else "plugin";
        in
          pkgs.fetchzip {
            inherit name version hash;
            url = "https://downloads.wordpress.org/${type}/${name}.${version}.zip";
          };
        installPhase = "mkdir -p $out; cp -R * $out/";
      };
    fetchPlugin = {
      name,
      version,
      hash,
    }: (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = false;
    });

    fetchTheme = {
      name,
      version,
      hash,
    }: (fetchPackage {
      name = name;
      version = version;
      hash = hash;
      isTheme = true;
    });

    neve = fetchTheme {
      name = "neve";
      version = "3.8.3";
      hash = "sha256-X3Jv2kn0FCCOPgrID0ZU8CuSjm/Ia/d+om/ShP5IBgA=";
    };
    antispam-bee = fetchPlugin {
      name = "antispam-bee";
      version = "2.1.15";
      hash = "sha256-X3Jv2kn0FCCOPgrID0ZU8CuSjm/Ia/d+om/ShP5IBgA=";
    };
    wordpress-seo = fetchPlugin {
      name = "wordpress-seo";
      version = "22.2";
      hash = "sha256-X3Jv2kn0FCCOPgrID0ZU8CuSjm/Ia/d+om/ShP5IBgA=";
    };
  in
    mkIf cfg.enable {
      services.wordpress = {
        webserver = "nginx";
        sites."${cfg.domain}" = {
          plugins = {inherit antispam-bee wordpress-seo;};
          themes = {inherit neve;};
          settings = {WP_DEFAULT_THEME = "neve";};
          virtualHost = {
            enableACME = true;
            forceSSL = true;
          };
        };
      };
    };
}
