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
      hash = "sha256-JsW1dpSF7ZyZzFscK/YoLD1emgd7toYPlXzTpPhhBLY=";
    };
    antispam-bee = fetchPlugin {
      name = "antispam-bee";
      version = "2.11.5";
      hash = "sha256-LTF7kDGJ36JuQ7ZGWl2wRCrQBmo9uD30/OlPDpl7cd0=";
    };
    wordpress-seo = fetchPlugin {
      name = "wordpress-seo";
      version = "22.2";
      hash = "sha256-pqVY82MfDQp2BuawETyeORLxRzfXdEbmkUU9JESeQxA=";
    };
    templates-patterns-collection = fetchPlugin {
      name = "templates-patterns-collection";
      version = "1.2.7";
      hash = "sha256-r4jwy2bS5u8E+JSXn8k73qIcWJYjFy2McdV1YlbPQQk=";
    };
    code-block-pro = fetchPlugin {
      name = "code-block-pro";
      version = "1.26.1";
      hash = "sha256-Ble+LCZ68QIRbxiyg7X0Zoq9WTQxqiVnS5HWvsES+E8=";
    };
    teachpress = fetchPlugin {
      name = "teachpress";
      version = "9.0.6";
      hash = "sha256-GwH2fgopgsNBsR27V1Gp7eba9uDYi0AJqdGjQCZU4hM=";
    };
  in
    mkIf cfg.enable {
      services.nginx.virtualHosts."${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
      };

      services.wordpress = {
        webserver = "nginx";
        sites."${cfg.domain}" = {
          package = pkgs.wordpress6_4;
          plugins = {inherit antispam-bee wordpress-seo templates-patterns-collection code-block-pro teachpress;};
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
