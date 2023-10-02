final: prev:
with prev; rec {
  moduleNames = dir:
    pipe dir [
      builtins.readDir
      (filterAttrs
        (name: type: (!hasPrefix "." name
          && !hasPrefix "_" name
          && (hasSuffix ".nix" name || type == "directory"))))
      attrNames
    ];
  withModules = dir: f:
    listToAttrs (map
      (filename: let
        path = dir + "/${filename}";
        name = removeSuffix ".nix" filename;
      in
        nameValuePair name (f {inherit path name;}))
      (moduleNames dir));
  discoverModules = dir:
    withModules dir ({
      path,
      name,
    }:
      import path);

  discoverOverlay = dir: final: prev: (withModules dir ({
    path,
    name,
  }: (final.callPackage path {})));

  discoverMachines = dir: args:
    withModules dir ({
      path,
      name,
    }:
      {modules = [path];} // args);
  discoverTemplates = dir: overrides:
    pipe dir [
      builtins.readDir
      (filterAttrs (_name: type: type == "directory"))
      attrNames
      (map (template:
        nameValuePair template (recursiveUpdate
          {
            path = "${dir}/${template}";
            description = "a template for ${template} projects";
          }
          (
            if hasAttr template overrides
            then getAttr template overrides
            else {}
          ))))
      listToAttrs
    ];
}
