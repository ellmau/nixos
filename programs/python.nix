{ config, lib, pkgs, ... }:
with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    pandas
    requests
    # other python packages you want
  ]; 
  python-with-my-packages = python3.withPackages my-python-packages;
in
{
  environment.systemPackages = [ python-with-my-packages ];
}
