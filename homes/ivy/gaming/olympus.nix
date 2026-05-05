{ pkgs, ... }:

{
  # we play celeste here
  ceirios.packages = {
    inherit (pkgs) olympus;
  };
}
