final: prev:

with prev; rec {
  moduleNames = dir: pipe dir [
    builtins.readDir
    (filterAttrs
      (name: type: (!hasPrefix "." name && !hasPrefix "_" name
        && (hasSuffix ".nix" name || type == "directory"))))
    attrNames
  ];
  withModules = dir: f:
    listToAttrs (map
      (filename:
        let
          path = dir + "/${filename}";
          name = removeSuffix ".nix" filename;
        in
        nameValuePair name (f { inherit path name; }))
      (moduleNames dir));
  discoverModules = dir: withModules dir ({ path, name }: import path);
  discoverMachines = dir: args:
    withModules dir ({ path, name }:
      { modules = [ path ]; } // args);
}
