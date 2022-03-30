{ config, pkgs, ... }:
{
  sops.defaultSopsFile = ./secrets.yaml;
}
