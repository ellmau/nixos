{ config, pkgs, lib, ... }:

let
  aspellConf = ''
    data-dir /run/current-system/sw/lib/aspell
    dict-dir /run/current-system/sw/lib/aspell
    master en_GB-ise
    extra-dicts en-computers.rws
    add-extra-dicts en_GB-science.rws
  '';
in
{
  options.elss.programs.aspell.enable = lib.mkEnableOption "setup aspell";

  config = lib.mkIf config.elss.programs.aspell.enable {
    environment.systemPackages = [ pkgs.aspell ]
                                 ++ (with pkgs.aspellDicts; [ de en sv en-computers en-science ]);
  };
}
