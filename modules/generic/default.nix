{ lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib) types;
in
{
  imports = [
    ./packages.nix
    ./profiles.nix
  ];

  options.ceirios.packages = mkOption {
    type = types.lazyAttrsOf types.package;
    default = { };
    description = "A set of packages to install";
  };
}
