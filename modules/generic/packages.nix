{
  lib,
  config,
  _class,
  ...
}:

let
  inherit (lib) mergeAttrsList optionalAttrs;
in
{
  config = mergeAttrsList [
    (optionalAttrs (_class == "nixos" || _class == "darwin") {
      environment.systemPackages = builtins.attrValues config.ceirios.packages;
    })

    (optionalAttrs (_class == "homeManager") {
      home.packages = builtins.attrValues config.ceirios.packages;
    })
  ];
}
