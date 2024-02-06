{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.elss.programs.vscodium.enable = mkEnableOption "Configure VSCodium with needed extensions";

  config = let
    cfg = config.elss.programs.vscodium;
  in
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        (vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions;
            [
              mkhl.direnv
              vadimcn.vscode-lldb
              rust-lang.rust-analyzer
              serayuzgur.crates
              tamasfe.even-better-toml
              yzhang.markdown-all-in-one
              bbenoist.nix
              redhat.vscode-yaml
              ms-python.python
              ms-azuretools.vscode-docker
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "vscode-rustfmt";
                publisher = "statiolake";
                version = "0.1.2";
                sha256 = "8caLIaURug+7tclziywtKh86sKAMYHNO5oEPIwvp+U4=";
              }
            ];
        })
      ];
    };
}
