{ pkgs, config, lib, ... }:

{
  # we play celeste here
  ceirios.packages = lib.mkIf config.ceirios.profiles.gaming {
    inherit (pkgs) olympus;
  };
}
