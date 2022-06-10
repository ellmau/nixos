final: prev:

with prev; rec {
  moduleNames = dir: pipe dir [
    builtins.readDir
    (filterAttrs (name: type: !hasPrefix "." name && (hasSuffix ".nix" name || type == "directory")))
    attrNames
  ];
  discoverModules = dir: f:
    listToAttrs (map
      (filename:
        nameValuePair (removeSuffix ".nix" filename) (f filename))
      (moduleNames dir));
}
