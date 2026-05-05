{ pkgs, ... }:

{
  ceirios.packages = {
    inherit (pkgs) bottles;
  };
}
